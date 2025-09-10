using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace ClientService.People;

public class DocumentPerson
{
    [BsonId]
    public ObjectId Id { get; set; }
    
    [BsonElement("user_id")]
    public ObjectId UserId { get; init; }
    
    [BsonElement("firstName")]
    public required string FirstName { get; init; }
    
    [BsonElement("lastName")]
    public required string LastName { get; init; }
}