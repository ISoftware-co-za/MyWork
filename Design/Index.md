# Client
A Flutter based UI. Currently supports web, but will be extended to other platforms in the future. The content is usually updated as part of some other process: in a meeting, on a call etc. The content should be easy to update, the structure flat for easy navigation, and the UI as modeless as possible.
## Layers

![[Client Interface Layers.jpg|500]]

### Flutter Widgets
Flutter Widgets, either predefined. The widgets accept data and callbacks. In addition to these, the following will also be handled by this layer.
- Data entry validation.
### Facade
The facade is the bridge between the Flutter Widgets and Service Client. It is responsible for:
- Manage the application state.
- Providing data to the Flutter Widgets.
- Providing callbacks to the Flutter Widgets to process events.
- Transforming and passing data to the Service using the Service Client.
- Processing responses, updating the the application state and in turn the Flutter Widgets.
### Service Client
- Generate request objects to serialise to the service.
- Deserialise responses to response objects.
- Communicate with the service.
- Pass errors to the Facade for processing.
## Document Storage
A document database is used. The following document collections will be maintained:
- Work - All the users work.
- Tasks - A document per work item, containing all the tasks for the work item.
- Activities - A document per task, containing all the activities for the task.
## Service Interaction
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
# Services
