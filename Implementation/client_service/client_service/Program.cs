using client_service.Users;
using client_service.Validation;
using MongoDB.Driver;
using NLog.Web;
using client_service.Work;
using Microsoft.AspNetCore.Diagnostics;
using NLog;
using LogLevel = Microsoft.Extensions.Logging.LogLevel;

Logger? logger = null;

try
{
    LogManager.Setup().LoadConfigurationFromFile();
    logger = LogManager.GetCurrentClassLogger();
    logger?.Info("Service is starting");

    const string corsPolicyName = "WyWorkCORSPolicy";
    var builder = WebApplication.CreateBuilder(args);

    // Configure logging
    builder.Logging.ClearProviders();
    builder.Logging.AddConsole();
    builder.Logging.AddDebug();
    builder.Logging.SetMinimumLevel(LogLevel.Debug);

    builder.Host.UseNLog();

    builder.Services.AddSentry();
    builder.WebHost.UseSentry(options =>
    {
        options.Dsn = "https://76ff866ed0c9853a5fbb4dcc1afd2424@o4506012740026368.ingest.us.sentry.io/4508544632881152";
        options.Debug = true;
        options.AutoSessionTracking = true;
        options.IsGlobalModeEnabled = false;
        options.CaptureFailedRequests = true;
        options.TracesSampleRate = 1;
        options.ProfilesSampleRate = 1;
    });

    builder.Services.AddCors(options =>
    {
        options.AddPolicy(corsPolicyName,
            policy =>
            {
                policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader()
                    .WithExposedHeaders("sentry-trace", "baggage");
            });
    });
    builder.Services.AddEndpointsApiExplorer();
    builder.Services.AddSwaggerGen();
    builder.Services.AddProblemDetails();
    
    builder.Services.AddSingleton<RequestValidation>();
    
    IConfigurationSection mongoDBConfiguration = builder.Configuration.GetSection("MongoDB");
    string mongoDBConnectionString = mongoDBConfiguration["ConnectionString"]!;
    builder.Services.AddSingleton<IMongoClient>(_ => new MongoClient(mongoDBConnectionString));
    builder.Services.AddScoped<IMongoDatabase>(sp =>
    {
        var client = sp.GetRequiredService<IMongoClient>();
        return client.GetDatabase("my_work");
    });
    
    var app = builder.Build();
    var url = app.Configuration["Service:URL"];
    if (url == null)
        throw new Exception("Startup error: The service URL is not defined. Add Service.URL to the configuration.");
    app.Urls.Add(url!);

    app.UseHttpsRedirection();
    app.UseHsts();
    app.UseExceptionHandler(exceptionHandlerApp => exceptionHandlerApp.Run(async context =>
    {
        var exceptionHandlerPathFeature = context.Features.Get<IExceptionHandlerPathFeature>();
        app.Logger.LogError("{Path} - {ExceptionMessage}", context.Request.Path,
            exceptionHandlerPathFeature?.Error.Message);
    }));
    if (app.Environment.IsDevelopment())
    {
        app.UseSwagger();
        app.UseSwaggerUI();
    }

    var validation = app.Services.GetRequiredService<RequestValidation>();
    app.UseCors(corsPolicyName);
    app.MapUsersURLs("/users", corsPolicyName);
    validation.AddUserValidation();
    app.MapWorkURLs("/work", corsPolicyName);
    validation.AddWorkValidation();
    
    logger?.Info("Service is running");
    app.Run();
}
catch (Exception exception)
{
    logger?.Error(exception);
}