# Client
A Flutter based UI. Currently supports web, but will be extended to other platforms in the future. The content is usually updated as part of some other process: in a meeting, on a call etc. The content should be easy to update, the structure flat for easy navigation, and the UI as modeless as possible.
## Layers

![[Client Interface Layers and Components.png]]
### Flutter Widgets
Flutter Widgets, either predefined or custom. The widgets accept data and callbacks from controllers. In addition to these, the following will also be handled by this layer.
- Data entry validation.
#### UI Toolkit
Reusable UI components used across the app.
### Facade
The actual application. Used by the Flutter layer to obtain data and process input. Uses the Service client, via the Facade classes to communicate with the service. Made up of the following:
#### Controller classes
These classes act as orchestrators within the Facade layer of the Flutter application. They manage the application's UI state and facilitate interactions between the UI and the underlying domain/service layer. 
**Purpose:**
- Manage the application's UI state.
- Provide data to Flutter Widgets for display.
- Handle user interactions by providing callbacks to Flutter Widgets.
- Delegate to facade for call the service layer. 
- Data is passed via parameters, which can be state objects. Responses can be state objects or result objects.
Characteristics:
- There is not a one-to-one relationship between UI elements and controllers. Some UI elements may utilise multiple controllers, and controllers may collaborate with each other via shared classes.
- They reside within the Facade layer and are responsible for coordination, they take on no processing themselves.
- They should strive to be thin, and delegate business logic to the domain objects/service layer.
#### State classes
Data classes that notify when updated.
TBD: There are also stateless classes, these need to be integrated into 
#### Result classes
Facades accept and return state
#### Facade classes
The facade is the bridge between the Flutter Widgets and Service Client. It is responsible for:
- Transforming and passing data to the Service using the Service Client.
- Processing responses, updating the the application state and in turn the Flutter Widgets.
### Service Client
- Generate request objects to serialise to the service.
- Deserialise responses to response objects.
- Communicate with the service.
- Pass errors to the Facade for processing.
# Service Interaction
The implementation will optimise for the following:
- Minimise number of service calls
- Minimise amount of data in requests and responses

To achieve this the following implementation strategy will be followed:
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

> It may be useful to batch these CRUD updates. Doing so does no align with the RESTful architectural style. Usage patterns would determine if this is required. There should be sufficient observability to determine these usage patterns.
# Service
TBD.
# Document Storage
A document database is used. The following document collections will be maintained:
- Users - Email, password and work types.
- Work - All the users work. References a user through `user_id:ObjectID`.
- Tasks - A document per work item, containing all the tasks for the work item.
- Activities - A document per task, containing all the activities for the task.