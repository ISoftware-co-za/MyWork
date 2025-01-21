using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace client_service.Users;

public class DocumentUser
{
    [BsonId]
    public ObjectId Id { get; set; }
    
    public required string Email { get; set; }
    
    public required string Password { get; set; }
    
    public required string[] WorkTypes  { get; set; }
}