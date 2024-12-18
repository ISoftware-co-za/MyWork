using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace client_service.Work;

public class DocumentWork
{
    [BsonId]
    public ObjectId Id { get; set; }
    
    public string Name { get; set; }
    
    public string? Type { get; set; }
    
    public string? Reference { get; set; }

    public string? Description { get; set; }
}
