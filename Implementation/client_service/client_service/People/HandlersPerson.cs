using System.ComponentModel.DataAnnotations;
using ClientService.Activities;
using ClientService.Execution;
using ClientService.Utilities;
using ClientService.Validation;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Bson;
using MongoDB.Driver;

namespace ClientService.People;

public static class HandlersPerson
{
    #region METHODS
    
    public static void MapPersonURLs(this WebApplication app, string urlPrefix, string corsPolicyName)
    {
        RouteGroupBuilder groupBuilder = app.MapGroup(urlPrefix);
        groupBuilder.MapGet("/", ListAllPeople).RequireCors(corsPolicyName);
        groupBuilder.MapPost("/", Post).RequireCors(corsPolicyName);
    }
    
    public static void AddPersonValidation(this RequestValidation requestValidation)
    {
        List<ValidatedProperty> properties =
        [
            new ValidatedProperty(nameof(PersonDetails.FirstName),
                [new RequiredAttribute(), new StringLengthAttribute(maximumLength: 30)]),
            new ValidatedProperty(nameof(PersonDetails.LastName),
                [new RequiredAttribute(), new StringLengthAttribute(maximumLength: 30)])
        ];
        requestValidation.RegisterValidation(new ValidatedRequest(
            nameof(PersonDetails), 
            new ValidatedPropertyCollection(properties.ToArray())
        ));
    }
    
    #endregion
    
    #region HTTP HANDLERS
    
    [ProducesResponseType(typeof(GetAllPeopleResponse), StatusCodes.Status200OK)]
    private static async Task<IResult> ListAllPeople([FromServices] IMongoDatabase database, [FromServices] ILogger<Program> logger, HttpRequest httpRequest)
    {
        return await Executor.RunProcessAsync($"{CollectionName}.Find(filter).ToListAsync()", Executor.CategoryMongoDB, "Unable to obtain the list of people.", async () =>
        {
            IMongoCollection<DocumentPerson> personCollection = database.GetCollection<DocumentPerson>(CollectionName);
            ObjectId userId = ObjectId.Parse(httpRequest.GetSid());
            var filter = Builders<DocumentPerson>.Filter.Eq(p => p.UserId, userId); 
            var personDocuments = await personCollection.Find(filter).ToListAsync();
            
            var people = new List<Person>(); 
            foreach (var document in personDocuments)
            {
                var personDetailsItem = new Person
                {
                    Id = document.Id.ToString(),
                    FirstName = document.FirstName,
                    LastName = document.LastName
                };
                people.Add(personDetailsItem);
            }
            var response = new GetAllPeopleResponse { People = people.ToArray() };
            return Results.Ok(response);
        }) ;
    }

    [ProducesResponseType(typeof(ModifyPeopleResponse), StatusCodes.Status200OK)]
    private static async Task<IResult> Post([FromBody] ModifyPeopleRequest request,
        [FromServices] RequestValidation requestValidation, [FromServices] IMongoDatabase database,
        [FromServices] ILogger<Program> logger, HttpRequest httpRequest)
    {
        return await Executor.RunProcessAsync("HandlersPerson.Post", Executor.CategoryEndpoint,
            "Unable to update modified people.",
            async () =>
            {
                ModifyPeopleResponse response = CreateEmptyRequest(request);
                bool hasErrors = ValidateModifyPeopleRequest(request, requestValidation, response);
                if (hasErrors)
                    return Results.Ok(response);

                ObjectId userId = ObjectId.Parse(httpRequest.GetSid());
                IMongoCollection<DocumentPerson> peopleCollection =
                    database.GetCollection<DocumentPerson>(CollectionName);
                if (IsNotNullOrEmpty(request.AddedPeople))
                    await InsertAddedPeople(userId, request.AddedPeople!, peopleCollection, response);
                if (IsNotNullOrEmpty(request.UpdatedPeople))
                    await UpdatePeople(request.UpdatedPeople!, peopleCollection, response);
                if (IsNotNullOrEmpty(request.RemovedPersonIds))
                    await DeletePeople(request.RemovedPersonIds!, peopleCollection, database, response);

                return await Task.FromResult(Results.Ok(response));
            });
    }
    
    #endregion
    
    #region PRIVATE METHODS
    
    private static ModifyPeopleResponse CreateEmptyRequest(ModifyPeopleRequest request)
    {
        ModifyOutcome[]? addedPeopleOutcomes = null;
        ModifyOutcome[]? updatedPeopleOutcomes = null;
        ModifyOutcome[]? deletePeopleOutcomes = null;

        if (IsNotNullOrEmpty(request.AddedPeople))
        {
            addedPeopleOutcomes = new ModifyOutcome[request.AddedPeople!.Length];
            for (int index = 0; index < request.AddedPeople!.Length; index++)
                addedPeopleOutcomes[index] = new ModifyOutcome { Id = ""};
        }
        if (IsNotNullOrEmpty(request.UpdatedPeople))
            updatedPeopleOutcomes = request.UpdatedPeople!.Select(person => new ModifyOutcome{Id = person.Id}).ToArray();
        if (IsNotNullOrEmpty(request.RemovedPersonIds))
            deletePeopleOutcomes = request.RemovedPersonIds!.Select(personId => new ModifyOutcome{Id = personId}).ToArray();
        return new ModifyPeopleResponse
        {
            AddedPeople = addedPeopleOutcomes,
            UpdatedPeople = updatedPeopleOutcomes,
            RemovedPeople = deletePeopleOutcomes
        };
    }
    
    private static bool ValidateModifyPeopleRequest(ModifyPeopleRequest request,
        RequestValidation requestValidation, ModifyPeopleResponse response)
    {
        bool hasInsertValidationErrors = false;
        bool hasUpdateValidationErrors = false;

        if (IsNotNullOrEmpty(request.AddedPeople))
        {
            hasInsertValidationErrors = ValidatePeopleAdded(request.AddedPeople!, requestValidation, response);
            if (hasInsertValidationErrors)
                response.AddedPeopleErrorMessage = "Some added people have validation errors.";
        }

        if (IsNotNullOrEmpty(request.UpdatedPeople))
        {
            hasUpdateValidationErrors = ValidatePeopleUpdated(request.UpdatedPeople!, requestValidation, response);
            if (hasUpdateValidationErrors)
                response.UpdatedPeopleErrorMessage = "Some updated people have validation errors.";            
        }
        
        return hasInsertValidationErrors || hasUpdateValidationErrors;
    }

    private static bool ValidatePeopleAdded(PersonDetails[] peopleAdded, RequestValidation requestValidation,
        ModifyPeopleResponse response)
    {
        bool hasErrors = false;
        IValidator peopleAddedValidator = requestValidation.GetValidatorForRequest(nameof(PersonDetails));
        for (int index = 0; index < peopleAdded.Length; index++)
        {
            ValidationResult[] validationResult = peopleAddedValidator.Validate(peopleAdded[index]);
            if (validationResult.Length > 0)
            {
                hasErrors = true;
                response.AddedPeople![index].ErrorMessage =
                    string.Join("; ", validationResult.Select(x => x.ErrorMessage));
            }
        }
        return hasErrors;
    }
    
    private static bool ValidatePeopleUpdated(UpdatedPerson[] updatedPersons, RequestValidation requestValidation,
        ModifyPeopleResponse response)
    {
        bool hasErrors = false;
        IValidator peopleUpdatedValidator = requestValidation.GetValidatorForRequest(nameof(PersonDetails));
        for (int index = 0; index < updatedPersons.Length; index++)
        {
            ValidationResult[] validationResult = peopleUpdatedValidator.Validate(updatedPersons[index]);
            if (validationResult.Length > 0)
            {
                hasErrors = true;
                response.UpdatedPeople![index].ErrorMessage =
                    string.Join("; ", validationResult.Select(x => x.ErrorMessage));
            }
        }
        return hasErrors;
    }
    
    private static async Task InsertAddedPeople(ObjectId userId, PersonDetails[] addedPeople, IMongoCollection<DocumentPerson> peopleCollection,
        ModifyPeopleResponse response)
    {
        var addedPeopleDocuments = new List<DocumentPerson>();
        foreach (PersonDetails person in addedPeople)
        {
            addedPeopleDocuments.Add(new DocumentPerson
            {
                UserId = userId,
                FirstName = person.FirstName,
                LastName = person.LastName,
            });
        }

        try
        {
            await peopleCollection.InsertManyAsync(addedPeopleDocuments);
        }
        catch (MongoBulkWriteException ex)
        {
            foreach (BulkWriteError writeError in ex.WriteErrors)
                response.AddedPeople![writeError.Index].ErrorMessage = writeError.Message;
        }
        for (int index = 0; index < addedPeople.Length; index++)
        {
            ModifyOutcome addedPersonOutcome = response.AddedPeople![index];
            if (addedPersonOutcome.ErrorMessage == null) 
                response.AddedPeople![index].Id = addedPeopleDocuments[index].Id.ToString();   
        }
    }
    
    private static async Task UpdatePeople(UpdatedPerson[] updatedPeople, IMongoCollection<DocumentPerson> peopleCollection,
        ModifyPeopleResponse response)
    {
        var updates = new List<WriteModel<DocumentPerson>>();
        
        foreach (var person in updatedPeople)
        {
            var filter = Builders<DocumentPerson>.Filter.Eq(p => p.Id, ObjectId.Parse(person.Id));
            var updateDefs = new List<UpdateDefinition<DocumentPerson>>();
            foreach (var prop in person.UpdatedProperties)
                updateDefs.Add(Builders<DocumentPerson>.Update.Set(prop.NameInPascalCase(), prop.Value));
            var update = Builders<DocumentPerson>.Update.Combine(updateDefs);
            updates.Add(new UpdateOneModel<DocumentPerson>(filter, update));
        }

        try
        {
            var result = await peopleCollection.BulkWriteAsync(updates);
            if (result.ModifiedCount != updatedPeople.Length)
                response.UpdatedPeopleErrorMessage = "Some people could not be updated.";            
        }
        catch (MongoBulkWriteException ex)
        {
            foreach (BulkWriteError writeError in ex.WriteErrors)
                response.AddedPeople![writeError.Index].ErrorMessage = writeError.Message;
        }
    }
    
    private static async Task DeletePeople(string[] deletePeopleIds, IMongoCollection<DocumentPerson> peopleCollection, IMongoDatabase database,
        ModifyPeopleResponse response)
    {
        var filters = new List<FilterDefinition<DocumentActivity>>();
        foreach (var id in deletePeopleIds)
        {
            filters.Add(Builders<DocumentActivity>.Filter.Eq(p => p.RecipientId, ObjectId.Parse(id)));
        }
        var removedRecipientsFilter = Builders<DocumentActivity>.Filter.Or(filters);
        var removedRecipientsUpdate = Builders<DocumentActivity>.Update.Set(p => p.RecipientId, null);
        IMongoCollection<DocumentActivity> activityCollection = database.GetCollection<DocumentActivity>("activities");
        await activityCollection.UpdateManyAsync(removedRecipientsFilter, removedRecipientsUpdate);
        
        var deletes = new List<WriteModel<DocumentPerson>>();
        foreach (var id in deletePeopleIds) 
        {
            var filter = Builders<DocumentPerson>.Filter.Eq(p => p.Id, ObjectId.Parse(id));
            deletes.Add(new DeleteOneModel<DocumentPerson>(filter));
        }

        try
        {
            var result = await peopleCollection.BulkWriteAsync(deletes);
            if (result.DeletedCount != deletePeopleIds.Length)
                response.RemovedPeopleErrorMessage = "Some people could not be deleted.";
        }
        catch (MongoBulkWriteException ex)
        {
            response.RemovedPeopleErrorMessage = ex.Message;
            foreach (BulkWriteError writeError in ex.WriteErrors)
                response.RemovedPeople![writeError.Index].ErrorMessage = writeError.Message;
        }
    }

    private static bool IsNotNullOrEmpty<T>(T[]? array) => array is { Length: > 0 };

    #endregion

    #region  FIELDS

    private const string CollectionName = "people";
    
    #endregion
}