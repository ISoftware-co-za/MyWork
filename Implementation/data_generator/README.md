# Overview

To generate data use the command `dart run bin/data_generator.dart <generator>`. 
The other command line parameters are generator dependent.

# Generators

## Work

| Parameter | Abbreviation | Description                            | Range                 |
|-----------|--------------|----------------------------------------|-----------------------|
| count     | -c           | The number of work records to generate | 1 <= count <= 1000000 |
| types     | -t           | The number of types for the works.     | 0 <= count < 1000     |
