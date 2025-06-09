# Client
A Flutter based UI. Currently supports web, but will be extended to other platforms in the future. The content is usually updated as part of some other process: in a meeting, on a call, etc. The content should be easy to update, the structure flat for easy navigation, and the UI as modeless as possible.
## Layers
The diagram below shows the layers making up the application. These are described below. The diagram also defines the naming convention for classes and source files. Prefixes are used in both. The prefix is used to describe the purpose of the class within the application. It does not contribute to the name and role of the class within the application.

![[Client Interface Layers and Components.jpg]]
### Flutter Widgets
Flutter Widgets, either predefined or custom. The widgets accept data and callbacks from controllers. Widgets are categorised as follows:
- Layouts - Layout control Widgets and possibly also establish regions within the user interface.
- Controls - Building blocks of the user interface. Either display information or afford client interaction.
#### UI Toolkit
Reusable UI components used across the app.
#### Executor
Used to wrap the execution of event handler code. The events either raised by the user or the system itself. Its purpose global exception handling and end-to-end observability of these processing of these events.
### Application
The actual application. It stores the following states of the application:
- Navigation state
- Application state
- Model state by storing hydrated model objects.
#### Controller classes
These classes act as orchestrators within the Application layer. They manage the application's UI state and facilitate interactions between the UI and the underlying Model objects. 
**Purpose:**
- Manage the application's UI state.
- Provide data to Flutter Widgets for display.
- Handle user interactions by providing callbacks to Flutter Widgets.
- Delegate to the Model for business functionality and access to the service, via the ServiceClient. 
- Data is passed via parameters. Responses can be Model objects or Result objects.
Characteristics:
- There is not a one-to-one relationship between UI elements and controllers. Some UI elements may utilise multiple controllers, and controllers may collaborate with each other via Coordinators.
- Controllers reside within the Application layer and are responsible for coordination, they take on no processing themselves.
- They should strive to be thin, and delegate business logic to the domain objects.
#### Model
Implementation of the domain model. Should be a rich object oriented representation of the Domain. It should align with Agile's ubiquitous language and be understandable by all. Besides domain responsibilities, it also takes on service interaction activities
### Service Client
Used by the Model to access the service. The model creates the request objects and process the response objects. The ServiceClient is only accessible by the Model.
# Service Interaction
The implementation will optimise for the following:
- Minimise number of service calls
- Minimise amount of data in requests and responses

To achieve thi, the following implementation strategy will be followed:
- Entities will be downloaded from the service on demand and cached on the client.
- Updates to the entities are made on the service, and if successful duplicated on the cached entities.
	- Create
	- Update
	- Delete
- Updates are batched allowing the user to access or reject the batch of updates. 
- When the selected Task changes, the changes in the batched updates are accepted by default if there is not validation error. A validation error will prevent the task switch.
### Services Entities
The entities will be structured as follows.

![[Main.jpg|600]]

The following sequence diagrams show how these entities are exchanged between the client and services.

To list all entities set a GET request to the entities URL.
![[Read.jpg]]

To create an entity POST the EntityData to the entities URL. If successful the EntityKey is returned.
![[Create.jpg]]

To update an entity PUT EntityUpdate to the entities URL.
![[Update.jpg]]

To delete an Entity DELETE EntityKey to the entities URL.
![[Delete.jpg]]

> It may be useful to batch these CRUD updates. Doing so does not align with the RESTful architectural style. Whether this is required will depend on usage patterns. There should be sufficient observability to determine these usage patterns.
# Service
TBD.
# Document Storage
A document database is used. The following document collections will be maintained:
- Users - Email, password and work types.
- Work - All the users work. References a user through `user_id:ObjectID`.
- Tasks - A document per work item, containing all the tasks for the work item.
- Activities - A document per task, containing all the activities for the task.