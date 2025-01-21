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



