import 'package:flutter/material.dart';

class ControlTabBar extends StatelessWidget {
  const ControlTabBar({required TabController controller, super.key})
      : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
        controller: _controller,
        dividerHeight: 0,
        indicator: const BoxDecoration(),
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.33),
        tabs: const [
          Tab(icon: Icon(Icons.note)),
          Tab(icon: Icon(Icons.work)),
        ]);
  }

  final TabController _controller;
}
