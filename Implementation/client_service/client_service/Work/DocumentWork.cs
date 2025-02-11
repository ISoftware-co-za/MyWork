using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace client_service.Work;

public record class DocumentWork
{
    [BsonId]
    public ObjectId Id { get; init; }
    
    [BsonElement("user_id")]
    public ObjectId UserId { get; init; }
    
    [BsonElement("name")]
    public required string Name { get; init; }
    
    [BsonElement("type")]
    public string? Type { get; init; }
    
    [BsonElement("reference")]
    public string? Reference { get; init; }

    [BsonElement("description")]
    public string? Description { get; init; }
    
    [BsonElement("archived")]
    public bool Archived { get; init; }
}
