using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace ClientService.Activities;

public record class DocumentActivity
{
    [BsonId]
    public ObjectId Id { get; init; }
    
    [BsonElement("user_id")]
    public ObjectId UserId { get; init; }

    [BsonElement("work_id")]
    public ObjectId WorkId { get; init; }
    
    [BsonElement("recipient_id")]
    public ObjectId? RecipientId { get; init; }

    [BsonElement("what")]
    public required string What { get; init; }

    [BsonElement("state")]
    [BsonRepresentation(BsonType.String)]
    public required ActivityState State { get; init; }

    [BsonElement("why")]
    public string? Why { get; init; }

    [BsonElement("how")]
    public string? How { get; init; }

    [BsonElement("dueDate")]
    public string? DueDate { get; init; }
    
    [BsonElement("notes")]
    public required ActivityNote[] Notes { get; init; }
}