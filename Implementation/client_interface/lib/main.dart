import 'package:flutter/material.dart';

import 'activity_widget_layout_constructor.dart';
import 'state_base.dart';
import 'layout_activity.dart';
import 'state_note.dart';
import 'state_work.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', activities: [
        StateNote(initialText: '', timestamp: DateTime.now()),
        StateWork(
            title: "Design error handling mechanism",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi facilisis ultrices interdum. Mauris tempus sollicitudin eros id maximus. Praesent scelerisque nulla eget volutpat malesuada. Nullam tincidunt, ligula in congue pharetra, urna nisi ornare elit, accumsan tempus libero nisl sit amet nisi. Sed varius lacinia ipsum. Nullam dictum hendrerit tincidunt. Nunc pharetra sollicitudin blandit.",
            timestamp: DateTime.now(),
          workLog: [
            StateWorkEntry(
              start: DateTime.now(),
              durationInMinutes: 60,
              currentEstimateInMinutes: 60,
              notes: 'This is the first work entry for this task.'
            ),
            StateWorkEntry(
              start: DateTime.now(),
              durationInMinutes: 45,
              currentEstimateInMinutes: 90,
              notes: 'This is the second work entry for this task.'
            ),
          ]
        ),
        StateNote(initialText: 'This is the second note for this task.', timestamp: DateTime.now()),
      ],),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final List<StateBase> activities;
  const MyHomePage({required this.title, required this.activities, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        width: 800,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: _createActivityWidgets()
          ),
        ),
      ),
    );
  }

  List<Widget> _createActivityWidgets() {
    var widgets = <Widget>[];
    for (var activity in widget.activities) {
      if (activity is StateNote) {
        widgets.add(LayoutActivity(model: ActivityWidgetConstructorNote(activity: activity)));
      } else if (activity is StateWork) {
        widgets.add(LayoutActivity(model: ActivityWidgetConstructorWork(activity: activity)));
      }
    }
    return widgets;
  }

}
