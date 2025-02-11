# Error handling
This section describes how error are handled by the client interface. 

**ServiceBase**
The `ServiceBase` class defined the `processResponse` method. This method is used by all HTTP calls to process and throw Exceptions when a non-successful status code is returned from the service.

**Executor**
Each event handled by the app, wether as a result of direct user manipulation or not, is wrapped in on of the methods:
- `Executor.runCommand`
- `Executor.runCommandAsync`
These methods handle the exception, report it to the Observability provider and display an appropriate message to the client via the notification classes. This includes exceptions thrown by `ServiceBase.processResponse`
# Sprints

A sprint is 20 hours a week. The following story point estimation is used:

| Story Point | Amount of sprint |
| ----------- | ---------------- |
| 1           | 0.03125          |
| 2           | 0.0625           |
| 4           | 0.125            |
| 8           | 0.25             |
| 16          | 0.5              |
# Data generator

The format of the data generator is:

`dart run data_generator.dart collection p1 p2 ... pn`

Where collection can be one of the following:

## users

p1 = number of users to add to the users collection. If p1 is not specified is default to 100.

## work

p1 = number of work items to add to each user in the collection. If p1 is not specified then the number of items will be random varying from 0 to 1 000 000.



