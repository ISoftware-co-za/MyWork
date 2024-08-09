import 'package:flutter/material.dart';

class PageDetails extends StatelessWidget {
  const PageDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              debugPrint(textEditingValue.text);
              return <String>[textEditingValue.text, 'Project', 'Incident', 'Event', 'Ad-hoc'];
            },
            onSelected: (String selection) {
              debugPrint('You just selected $selection');
            }
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Reference'),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
