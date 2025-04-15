
# Naming Convention
Prefix to describe purpose
## Widgets
Tab
Layout
LayoutDialog
LayoutTaLayout
Control
## Facade
State
ListItem
# Data Grid
A data grid display data in a grid. Columns represent properties, rows instance of objects who have the properties expected by the columns.

The object instance are obtained from a data sources. The initial version of the data grid will allow filtering on columns.

The data grid is defined by a `ColumnCollection`. It can contain the following column types. The type determines the filter control for column. It can be one of the following types:
- The label of the column
- The relative width of the column, or 0 to size to content


