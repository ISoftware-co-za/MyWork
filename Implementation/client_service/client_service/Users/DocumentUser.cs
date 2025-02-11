using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace client_service.Users;

public class DocumentUser
{
    [BsonId]
    public ObjectId Id { get; set; }
    
    [BsonElement("email")]
    public required string Email { get; set; }
    
    [BsonElement("password")]
    public required string Password { get; set; }
    
    [BsonElement("workTypes")]
    public required string[] WorkTypes  { get; set; }
}