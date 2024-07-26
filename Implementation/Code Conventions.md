# Class naming convension

This project establishes a clear and consistent prefix convention for naming classes, enhancing code readability and maintainability. By adhering to this convention, you can:

- **Easily Identify Class Roles:** The prefix immediately indicates the class's primary purpose, streamlining code comprehension.
- **Gain High-Level Visibility:** File names within a folder quickly reveal their corresponding components, providing a high-level overview of the project structure.

The convension is:

| Prefix   | Role                                                         |
| -------- | ------------------------------------------------------------ |
| Page     | A widget representing a route or a page within a tab bar.    |
| Control  | A user interface component designed to be embedded within another Control or Page. It is an element of the UI. The control may also contain content that is laid out. The content and layout should be separated to easily distinguish between the two. |
| Layout   | A widget responsible for arranging and positioning Controls and other Layouts. |
| ListItem | Data associated with items displayed in a list.              |
| Provider | An InheritedWidget supplying access to services and data.    |
| Producer | A class that fetches or processes data, often obtaining input from a Provider. |

