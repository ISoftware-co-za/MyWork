using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace ClientService.Activities;

public record class ActivityNote
{
    [BsonElement("id")]
    public ObjectId Id { get; init; }
    
    [BsonElement("created")]
    public required string Created { get; init; }
    
    [BsonElement("text")]
    public required string Text { get; init; }
}