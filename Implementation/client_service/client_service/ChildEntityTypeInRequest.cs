using System.Diagnostics;
using Microsoft.AspNetCore.Authorization.Infrastructure;

namespace ClientService;

public record class ChildEntityTypeInRequest(string CreateTypeName, CreateChild[]? Create, UpdateChild[]? Update, DeleteChild[]? Delete);

public record class CreateChild(EntityProperty[] Properties)
{
    public string? GetUpdatedPropertyAsString(string name)
    {
        EntityProperty? locatedProperty = Properties.FirstOrDefault(p => p.Name == name);
        Debug.Assert(locatedProperty != null, $"There is no EntityProperty with name '{name}'");
        return locatedProperty.Value?.ToString() ?? null;
    }
}

public record class UpdateChild(string Id, EntityProperty[] UpdatedProperties)
{
    public string? GetUpdatedPropertyAsString(string name)
    {
        EntityProperty? locatedProperty = UpdatedProperties.FirstOrDefault(p => p.Name == name);
        Debug.Assert(locatedProperty != null, $"There is no EntityProperty with name '{name}'");
        return locatedProperty.Value?.ToString() ?? null;
    }
}

public record class DeleteChild(string Id);