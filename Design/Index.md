# Client
A Flutter-based UI. Currently supports web, but will be extended to other platforms in the future. The content is usually updated as part of some other process: in a meeting, on a call etc. The content should be easy to update, the structure flat for easy navigation, and the UI as modeless as possible.
## Layers
The diagram shows the layers making up the UI application. It illustrates the classes within each layer and the relationships between classes across different layers. It also details the class and Dart source file naming conventions.

![[Client Interface Layers and Components.jpg]]
The **Application** layer is open, while the **Model** layer is closed. Each layer and its class types are discussed below.
### Flutter Widgets
**Flutter Widgets**, either predefined or custom, form the top layer of the UI. As shown in the diagram, these widgets accept data and callbacks from **Controllers**.
#### UI Toolkit
The **UI Toolkit** (labeled `ui_toolbox` in the diagram) provides reusable UI components used across the application.
### Controller
The Controller layer houses the core application-specific logic that orchestrates UI behaviour and interacts with the **Model** and **Service Client**. As depicted, it's used by the **Flutter Widgets** layer to obtain data and process input. It communicates with the **Model** and the wrapped **Service Client**.

The **Application** layer is made up of the following:
#### Controller classes
These **Controller** classes act as orchestrators within the **Application** layer (see the `Controller*` box in the diagram). They manage the application's UI state and facilitate interactions between the UI and the underlying **Model** and **Service Client**.

**Purpose:**
- Manage the application's UI state.
- Initiate changes to the **Model's** state by invoking its methods.
- Provide data to **Flutter Widgets** for display.
- Handle user interactions by providing callbacks to **Flutter Widgets**.
- Delegate to **Coordinator** or **Model** classes.

Characteristics:
- There is not a one-to-one relationship between UI elements and **Controllers**. Some UI elements may utilise multiple **Controllers**, and **Controller** classes may collaborate with each other via **Coordinators** classes (as indicated by the connection between `Coordinator*` and `Controller*` in the diagram).
- **Controllers** are responsible for coordination; they take on no processing themselves. They should strive to be thin and delegate business logic to the **Coordinators** and **Model** classes.
- Data is passed via parameters, which can be **Model** objects. Responses can be **Model** or Result objects.
### Model
The **Model** layer is the implementation of the domain model. It should be a rich, object-oriented implementation, with real relationships between the domain objects.
### Service Client
The **Service Client** layer (the bottom brown layer in the diagram) allows the **Model** to interact with the Service. It does the following:
- Receives and serialises request objects.
- Deserialises responses to response objects.
- Communicates with the service.
- Processes service errors.
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
- Activities - A document per work item, containing all the activities for the work item.
- Tasks - A document per activity, containing all the tasks for the activities.

