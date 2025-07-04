using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace ClientService.Activity;

public record class DocumentActivity
{
    [BsonId]
    public ObjectId Id { get; init; }
    
    [BsonElement("user_id")]
    public ObjectId UserId { get; init; }

    [BsonElement("work_id")]
    public ObjectId WorkId { get; init; }

    [BsonElement("what")]
    public required string What { get; init; }

    [BsonElement("state")]
    [BsonRepresentation(BsonType.String)]
    public required ActivityState State { get; init; }

    [BsonElement("why")]
    public string? Why { get; init; }

    [BsonElement("notes")]
    public string? Notes { get; init; }

    [BsonElement("dueDate")]
    public DateTime? DueDate { get; init; }
}