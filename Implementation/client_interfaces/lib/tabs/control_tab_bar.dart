import 'package:flutter/material.dart';

class ControlTabBar extends StatelessWidget {
  const ControlTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
        dividerHeight: 0,
        indicator: const BoxDecoration(),
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.primary.withOpacity(0.33),
        tabs: const [
          Tab(icon: Icon(Icons.note)),
          Tab(icon: Icon(Icons.work)),
        ]);
  }
}
