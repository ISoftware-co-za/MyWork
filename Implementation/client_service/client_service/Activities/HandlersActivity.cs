using System.ComponentModel.DataAnnotations;
using System.Diagnostics;
using ClientService.Execution;
using ClientService.Utilities;
using ClientService.Validation;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Bson;
using MongoDB.Driver;

namespace ClientService.Activities;

public static class HandlersActivity
{
    #region METHODS

    public static void MapActivityURLs(this WebApplication app, string urlPrefix, string corsPolicyName)
    {
        _urlPrefix = urlPrefix;
        var groupBuilder = app.MapGroup(urlPrefix);
        groupBuilder.MapGet("/{workID}/activities", ListALlWorkActivities).RequireCors(corsPolicyName);
        groupBuilder.MapPost("/{workID}/activities", Post).RequireCors(corsPolicyName);
        groupBuilder.MapPatch("/{workID}/activities/{id}", Patch).RequireCors(corsPolicyName);
        groupBuilder.MapDelete("/{workID}/activities/{id}", Delete).RequireCors(corsPolicyName);
    }

    public static void AddActivityValidation(this RequestValidation requestValidation)
    {
        List<ValidatedProperty> activityProperties =
        [
            new(nameof(CreateActivityRequest.What),
                [new RequiredAttribute(), new StringLengthAttribute(80)]),
            new(nameof(CreateActivityRequest.Why),
                [new StringLengthAttribute(240)]),
            new(nameof(CreateActivityRequest.How),
                [new StringLengthAttribute(240)])
        ];
        requestValidation.RegisterValidation(new ValidatedRequest(
            nameof(CreateActivityRequest),
            new ValidatedPropertyCollection(activityProperties.ToArray())
        ));

        List<ValidatedProperty> noteProperties =
        [
            new(nameof(CreateActivityNote.Text),
                [new RequiredAttribute(), new StringLengthAttribute(300)]),
        ];
        requestValidation.RegisterValidation(new ValidatedRequest(
            nameof(CreateActivityNote),
            new ValidatedPropertyCollection(noteProperties.ToArray())
        ));
    }

    public static async Task DeleteWorkActivities(string workID, IMongoDatabase database)
    {
        await Executor.RunProcessAsync($"{CollectionName}.DeleteManyAsync({workID})", Executor.CategoryMongoDB,
            "Unable to delete activities for work with id ${workID}",
            async () =>
            {
                var filter = Builders<DocumentActivity>.Filter.Eq("work_id", ObjectId.Parse(workID));
                var activityCollection =
                    database.GetCollection<DocumentActivity>(CollectionName);
                await activityCollection.DeleteManyAsync(filter);
                return Results.NoContent();
            });
    }

    #endregion

    #region PRIVATE HANDLERS

    private static async Task<IResult> ListALlWorkActivities(string workID, [FromServices] IMongoDatabase database,
        [FromServices] ILogger<Program> logger, HttpRequest httpRequest)
    {
        return await Executor.RunProcessAsync($"{CollectionName}.Find(filter).ToListAsync()", Executor.CategoryMongoDB,
            "Unable to obtain the list of activities for the work.", async () =>
            {
                var activityItems = new List<Activity>();
                var activityCollection =
                    database.GetCollection<DocumentActivity>(CollectionName);
                var userId = httpRequest.GetSid();
                var filter = Builders<DocumentActivity>.Filter.And(
                    Builders<DocumentActivity>.Filter.Eq(p => p.UserId, ObjectId.Parse(userId)),
                    Builders<DocumentActivity>.Filter.Eq(p => p.WorkId, ObjectId.Parse(workID))
                );
                var activityDocuments = await activityCollection.Find(filter).ToListAsync();
                foreach (var document in activityDocuments)
                {
                    DateTime? dueDate = null;
                    if (document.DueDate != null)
                    {
                        dueDate = DateTime.Parse(document.DueDate);
                    }

                    var notes = FormatNotesForResponse(document);
                    var activity = new Activity(
                        document.Id.ToString(),
                        document.What,
                        document.State.ToString(),
                        dueDate,
                        document.RecipientId?.ToString(),
                        document.Why,
                        document.How,
                        notes);
                    activityItems.Add(activity);
                }

                return Results.Ok(new GetWorkActivityListResponse(activityItems));
            });
    }

    private static async Task<IResult> Post(string workID, [FromBody] CreateActivityRequest request,
        [FromServices] RequestValidation requestValidation, [FromServices] IMongoDatabase database,
        [FromServices] ILogger<Program> logger, HttpRequest httpRequest)
    {
        List<ValidationResult> validationResults = [];
        requestValidation.Validate(request, nameof(CreateActivityRequest), false, validationResults);
        if (request.Notes != null && request.Notes.Length > 0)
        {
            for (int i = 0; i < request.Notes.Length; i++)
            {
                var note = request.Notes[i];
                requestValidation.Validate(note, nameof(CreateActivityNote), false, validationResults);
            }
        }

        if (validationResults.Count == 0)
            return await Executor.RunProcessAsync($"{CollectionName}.InsertOne(activityDocument)",
                Executor.CategoryMongoDB, "Unable to save the new activity", async () =>
                {
                    var activityCollection =
                        database.GetCollection<DocumentActivity>(CollectionName);
                    var noteList = new List<ActivityNote>();
                    List<string>? noteIds = null;
                    if (request.Notes != null && request.Notes!.Length > 0)
                    {
                        foreach (var note in request.Notes)
                        {
                            var activityNote = new ActivityNote
                            {
                                Id = ObjectId.GenerateNewId(),
                                Created = note.Created,
                                Text = note.Text
                            };
                            noteList.Add(activityNote);
                            if (noteIds == null)
                                noteIds = new List<string>();
                            noteIds.Add(activityNote.Id.ToString());
                        }
                    }

                    var activityDocument = new DocumentActivity
                    {
                        UserId = ObjectId.Parse(httpRequest.GetSid()),
                        WorkId = ObjectId.Parse(workID),
                        What = request.What,
                        State = Enum.Parse<ActivityState>(request.State, true),
                        DueDate = request.DueDate,
                        RecipientId = string.IsNullOrWhiteSpace(request.RecipientId)
                            ? null
                            : ObjectId.Parse(request.RecipientId!),
                        Why = request.Why,
                        How = request.How,
                        Notes = noteList.ToArray()
                    };
                    await activityCollection.InsertOneAsync(activityDocument);
                    return Results.Created($"{_urlPrefix}/{activityDocument.Id}",
                        new CreateActivityResponse(activityDocument.Id.ToString(), noteIds?.ToArray()));
                });

        return RequestValidation.GenerateValidationFailedResponse(validationResults);
    }

    private static async Task<IResult> Patch(string workID, string id, ChangeEntityRequest request,
        [FromServices] RequestValidation requestValidation, [FromServices] IMongoDatabase database,
        [FromServices] ILogger<Program> logger)
    {
        var validationResults = ValidatePatchRequest(request, requestValidation);

        if (validationResults.Count == 0)
            return await Executor.RunProcessAsync($"{CollectionName}.UpdateOneAsync({id})", Executor.CategoryMongoDB,
                "Unable to save the updated activity",
                async () =>
                {
                    var activityFilter = Builders<DocumentActivity>.Filter.Eq("_id", ObjectId.Parse(id));
                    var activityCollection = database.GetCollection<DocumentActivity>(CollectionName);

                    ChangeEntityResponse response = GenerateEmptyResult(request);
                    bool mustContinue = true;
                    if (request.UpdatedProperties != null)
                        mustContinue = await UpdateActivity(id, request, activityCollection, activityFilter, response);

                    if (mustContinue && request.ChildUpdates != null)
                    {
                        for (int index = 0; index < request.ChildUpdates!.Length; ++index)
                        {
                            ChildEntityTypeInRequest childUpdate = request.ChildUpdates[index];
                            if (childUpdate.CreateTypeName == nameof(CreateActivityNote))
                            {
                                await ChangeNotes(childUpdate, activityCollection, activityFilter, response.ChildUpdateResults![index]);
                            }
                        }
                    }
                    return Results.Json(response, statusCode: response.GetStatusCode());
                });
        return RequestValidation.GenerateValidationFailedResponse(validationResults);
    }
    
    private static async Task<IResult> Delete(string workID, string id, IMongoDatabase database,
        [FromServices] ILogger<Program> logger)
    {
        return await Executor.RunProcessAsync($"{CollectionName}.DeleteOneAsync({id})", Executor.CategoryMongoDB,
            "Unable to save the updated work",
            async () =>
            {
                var filter = Builders<DocumentActivity>.Filter.Eq("_id", ObjectId.Parse(id));
                var activityCollection =
                    database.GetCollection<DocumentActivity>(CollectionName);
                await activityCollection.DeleteOneAsync(filter);
                return Results.NoContent();
            });
    }

    #endregion

    #region PRIVATE METHODS
    
    private static ActivityNoteResponseFragment[]? FormatNotesForResponse(DocumentActivity document)
    {
        ActivityNoteResponseFragment[]? notes = null;
        if (document.Notes is { Length: > 0 })
        {
            var noteList = new List<ActivityNoteResponseFragment>();
            foreach (var note in document.Notes)
                noteList.Add(new ActivityNoteResponseFragment
                {
                    Id = note.Id.ToString(),
                    Created = note.Created,
                    Text = note.Text
                });
            notes = noteList.ToArray();
        }

        return notes;
    }

    private static List<ValidationResult> ValidatePatchRequest(ChangeEntityRequest request,
        RequestValidation requestValidation)
    {
        var validationResults = new List<ValidationResult>();
        if (request.UpdatedProperties != null)
            requestValidation.Validate(request, nameof(CreateActivityRequest), true, validationResults);
        if (request.ChildUpdates != null && request.ChildUpdates!.Length > 0)
        {
            for (int index = 0; index < request.ChildUpdates.Length; index++)
            {
                ChildEntityTypeInRequest childEntityTypeInRequest = request.ChildUpdates[index];
                if (childEntityTypeInRequest.CreateTypeName == nameof(CreateActivityNote))
                {
                    if (childEntityTypeInRequest.Create != null)
                    {
                        foreach(CreateChild newChild in childEntityTypeInRequest.Create!)
                            requestValidation.Validate(newChild.Properties, nameof(CreateActivityNote), true,
                                validationResults);
                    }
                    if (childEntityTypeInRequest.Update != null)
                    {
                        foreach(UpdateChild updatedChild in childEntityTypeInRequest.Update!)
                            requestValidation.Validate(updatedChild.UpdatedProperties, nameof(CreateActivityNote), true,
                                validationResults);
                    }
                }
            }
        }
        return validationResults;
    }
    
    private static ChangeEntityResponse GenerateEmptyResult(ChangeEntityRequest request)
    {
        ResultBase? result = null;
        ChildEntityTypeInResponse[]? childTypeArray = null;
        if (request.UpdatedProperties != null)
            result = new ResultBase(null, null);
        if (request.ChildUpdates != null)
        {
            List<ChildEntityTypeInResponse> childTypes = [];
            foreach(var child in request.ChildUpdates)
            {
                CreateChildResult[]? created = null;
                ChangeChildResult[]? updated = null;
                ChangeChildResult[]? deleted = null;
                
                if (child.Create != null) 
                    created = child.Create!.Select(_ => new CreateChildResult(null, null, null)).ToArray();
                if (child.Update != null) 
                    updated = child.Update!.Select(_ => new ChangeChildResult(null, null)).ToArray();
                if (child.Delete != null) 
                    updated = child.Delete!.Select(_ => new ChangeChildResult(null, null)).ToArray();
                
                childTypes.Add(new ChildEntityTypeInResponse(
                    child.CreateTypeName,
                    created,
                    updated,
                    deleted));
            }
            childTypeArray = childTypes.ToArray();
        }

        return new ChangeEntityResponse(result, childTypeArray);
    }

    private static async Task<bool> UpdateActivity(string id, ChangeEntityRequest request,
        IMongoCollection<DocumentActivity> activityCollection,
        FilterDefinition<DocumentActivity> activityFilter,
            ChangeEntityResponse response)
    {
        Debug.Assert(request.UpdatedProperties != null, "Cannot update activity with no updated properties");
        List<UpdateDefinition<DocumentActivity>> updates = [];
        foreach (var updateProperty in request.UpdatedProperties)
        {
            var value = DeserializeUpdateValue(updateProperty.NameInPascalCase(), updateProperty.Value);
            updates.Add(
                Builders<DocumentActivity>.Update.Set(updateProperty.NameInPascalCase(), value));
        }

        UpdateDefinition<DocumentActivity> combinedUpdates =
            Builders<DocumentActivity>.Update.Combine(updates);
        UpdateResult result = await activityCollection.UpdateOneAsync(activityFilter, combinedUpdates);
        if (result.IsAcknowledged == false || result.MatchedCount != 1)
        {
            response.Result!.Success = false;
            response.Result!.FailureMessage = $"Activity with id {id} could not be updated as it was not found.";
            return false;
        }
        response.Result!.Success = true;
        return true;
    }

    private static async Task ChangeNotes(ChildEntityTypeInRequest child,
        IMongoCollection<DocumentActivity> activityCollection,
        FilterDefinition<DocumentActivity> activityFilter,
        ChildEntityTypeInResponse response)
    {
        if (child.Create != null)
            await CreateNotes(child.Create!, activityCollection, activityFilter, response);
        if (child.Update != null)
            await UpdateNotes(child.Update!, activityCollection, activityFilter, response);
        if (child.Delete != null)
            await DeleteNotes(child.Delete!, activityCollection, activityFilter, response);
    }

    private static async Task CreateNotes(CreateChild[] newChildren,
        IMongoCollection<DocumentActivity> activityCollection,
        FilterDefinition<DocumentActivity> activityFilter,
        ChildEntityTypeInResponse response)
    {
        for(int index = 0; index < newChildren.Length; index++)
        {
            CreateChild newChild = newChildren[index];
            var noteId = ObjectId.GenerateNewId();
            var note = new ActivityNote
            {
                Id = noteId,
                Created = newChild.GetUpdatedPropertyAsString("created")!,
                Text = newChild.GetUpdatedPropertyAsString("text")!
            };
            var pushUpdate = Builders<DocumentActivity>.Update.Push(a => a.Notes, note);
            UpdateResult updateResults = await activityCollection.UpdateOneAsync(activityFilter, pushUpdate);
            CreateChildResult result = response.CreateResults![index];
            if (updateResults.IsAcknowledged == false || updateResults.MatchedCount != 1)
            {
                result.Success = false;
                result.FailureMessage = "Activity note could not be created.";
            }
            else
            {
                result.Success = true;
                result.Id = noteId.ToString();
            }
        }
    }

    private static async Task UpdateNotes(UpdateChild[] updatedChildren,
        IMongoCollection<DocumentActivity> activityCollection,
        FilterDefinition<DocumentActivity> activityFilter,
        ChildEntityTypeInResponse response)
    {
        for (int index = 0; index < updatedChildren.Length; ++index)
        {
            UpdateChild updatedChild = updatedChildren[index];
            Debug.Assert(updatedChild.UpdatedProperties != null, "Cannot update activity note with no updated properties");
            var noteFilter = Builders<DocumentActivity>.Filter.And(
                activityFilter,
                Builders<DocumentActivity>.Filter.ElemMatch(a => a.Notes,
                    note => note.Id == ObjectId.Parse(updatedChild.Id))
            );
            var update = Builders<DocumentActivity>.Update.Set("Notes.$.Text",
                updatedChild.UpdatedProperties[0].Value);
            UpdateResult updateResult = await activityCollection.UpdateOneAsync(
                noteFilter,
                update);
            ChangeChildResult result = response.UpdateResults![index];
            if (updateResult.IsAcknowledged == false || updateResult.MatchedCount != 1)
            {
                result.Success = false;
                result.FailureMessage = $"Activity note {updatedChild.Id} could not be created.";
            }
            else
            {
                result.Success = true;
            }            
        }
    }

    private static async Task DeleteNotes(DeleteChild[] oldChildren,
        IMongoCollection<DocumentActivity> activityCollection,
        FilterDefinition<DocumentActivity> activityFilter,
        ChildEntityTypeInResponse response)
    {
        for(int index = 0; index < oldChildren.Length; ++index)
        {
            DeleteChild oldNote = oldChildren[index];
            var noteFilter = Builders<DocumentActivity>.Filter.And(
                activityFilter,
                Builders<DocumentActivity>.Filter.ElemMatch(a => a.Notes,
                    note => note.Id == ObjectId.Parse(oldNote.Id))
            );
            var update = Builders<DocumentActivity>.Update.PullFilter(a => a.Notes,
                note => note.Id == ObjectId.Parse(oldNote.Id));
            UpdateResult updateResult = await activityCollection.UpdateOneAsync(
                noteFilter,
                update);
            ChangeChildResult result = response.UpdateResults![index];
            if (updateResult.IsAcknowledged == false)
            {
                result.Success = false;
                result.FailureMessage = $"Activity note {oldNote.Id} could not be deleted.";
            }
            else
            {
                result.Success = true;
            }   
        }
    }

    private static object? DeserializeUpdateValue(string name, object? value)
    {
        if (value == null)
            return value;
        if (name == nameof(DocumentActivity.State))
            return Enum.Parse(typeof(ActivityState), value.ToString()!, true);
        if (name == nameof(DocumentActivity.RecipientId))
            return ObjectId.Parse(value.ToString()!);
        return value;
    }

    #endregion

    #region FIELDS

    private const string CollectionName = "activities";
    private static string? _urlPrefix;

    #endregion
}