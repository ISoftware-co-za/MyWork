import 'package:flutter/material.dart';

import '../execution/executor.dart';

typedef FutureCallback = Future<void> Function();

class ControlDelete extends StatelessWidget {
  const ControlDelete({required String pageName, required FutureCallback onDelete}) :
    _pageName = pageName,
    _onDelete = onDelete;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(Icons.delete),
      label: const Text('Delete'),
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        Executor.runCommandAsync("Delete", _pageName, () async {
          await _onDelete();
        });
      },
    );
  }

  final String _pageName;
  final FutureCallback _onDelete;
}
