using MongoDB.Driver;
using NLog.Web;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;

using client_service.Work;
using client_service.Validation;

try
{
    const string corsPolicyName = "WyWorkCORSPolicy";
    var builder = WebApplication.CreateBuilder(args);
    builder.Logging.ClearProviders();
    builder.Host.UseNLog();
    builder.Services.AddCors(options =>
    {
        options.AddPolicy(corsPolicyName, policy =>
        {
            policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
        });
    });
    builder.Services.AddEndpointsApiExplorer();
    builder.Services.AddSwaggerGen();
    builder.Services.AddProblemDetails();
    
    IConfigurationSection mongoDBConfiguration = builder.Configuration.GetSection("MongoDB");
    string mongoDBConnectionString = mongoDBConfiguration["ConnectionString"]!;
    var validation = new Validation();
    builder.Services.AddSingleton<IMongoClient>(sp => new MongoClient(mongoDBConnectionString));
    builder.Services.AddScoped<IMongoDatabase>(sp =>
    {
        var client = sp.GetRequiredService<IMongoClient>();
        return client.GetDatabase("my_work");
    });
    builder.Services.AddSingleton<Validation>(validation);

    var app = builder.Build();
    var url = app.Configuration["Service:URL"];
    if (url == null)
        throw new Exception("Startup error: The service URL is not defined. Add Service.URL to the configuration.");
    app.Urls.Add(url!);
    
    app.UseExceptionHandler(exceptionHandlerApp => exceptionHandlerApp.Run(async context =>
    {
        var exceptionHandlerPathFeature = context.Features.Get<IExceptionHandlerPathFeature>();
        app.Logger.LogError("{Path} - {ExceptionMessage}", context.Request.Path, exceptionHandlerPathFeature?.Error.Message);
        var problemDetails = new ProblemDetails
        {
            Status = StatusCodes.Status500InternalServerError,
            Title = "An unexpected error occurred",
            Detail = exceptionHandlerPathFeature?.Error.Message,
            Instance = context.Request.Path
        };
        context.Response.StatusCode = StatusCodes.Status500InternalServerError;
        context.Response.ContentType = "application/problem+json";
        await context.Response.WriteAsJsonAsync(problemDetails);
    }));
    app.UseHttpsRedirection();
    if (app.Environment.IsDevelopment())
    {
        app.UseSwagger();
        app.UseSwaggerUI();
    }
    app.UseCors(corsPolicyName);
    app.MapWorkURLs("/work", corsPolicyName);
    validation.AddWorkValidation();
    app.Run();
}
catch (Exception exception)
{
   Console.Error.WriteLine(exception.Message); 
}