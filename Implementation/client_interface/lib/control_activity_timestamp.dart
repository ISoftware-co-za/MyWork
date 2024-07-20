import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ControlActivityTimestamp extends StatelessWidget {
  final DateTime timestamp;
  const ControlActivityTimestamp({required this.timestamp, super.key});

  @override
  Widget build(BuildContext context) {
    var formattedDateTime = DateFormat.yMd().add_Hm().format(timestamp);
    return Text(formattedDateTime, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold) );
  }
}
