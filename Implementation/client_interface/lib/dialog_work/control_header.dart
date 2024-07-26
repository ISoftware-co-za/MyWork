import 'package:flutter/material.dart';

class ControlHeader extends StatelessWidget {
  const ControlHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Work', style: TextStyle(fontSize: 28, decoration: TextDecoration.none, color: Colors.black)),
        IconButton(onPressed: () => debugPrint('Add work pressed'), icon: const Icon(Icons.add_circle, color: Colors.red, size: 30), padding: const EdgeInsets.all(2)),
        const Spacer(),
        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded, color: Colors.red, size: 30), padding: const EdgeInsets.all(2)),
      ],
    );
  }
}
