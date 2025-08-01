namespace ClientService;

public record UpdateProperty(string Name, object? Value)
{
    public string NameInPascalCase()
    {
        if (string.IsNullOrEmpty(Name))
            return Name;
        return char.ToUpper(Name[0]) + Name.Substring(1);
    }
}
