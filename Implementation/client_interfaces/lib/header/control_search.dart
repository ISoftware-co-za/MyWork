import 'package:flutter/material.dart';

class ControlSearch extends StatelessWidget {
  const ControlSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 40, child: SearchBar(onChanged: (value) {debugPrint('SearchBar onChanged: $value');}));
  }
}
