import 'package:client_interfaces1/notification/layout_notification_list.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'execution/executor.dart';
import 'execution/ui_container_context.dart';
import 'notification/controller_notifications.dart';
import 'state/facade_base.dart';
import 'ui toolkit/custom_icon_buttons.dart';
import 'dialog_work/control_header.dart';
import 'header/control_button_select_work.dart';
import 'header/layout_header.dart';
import 'state/provider_state_application.dart';
import 'state/controller_work.dart';
import 'ui toolkit/control_form_fields.dart';
import 'state/properties.dart';
import 'state/state_note.dart';
import 'state/state_action.dart';
import 'tabs/layout_tab_bar.dart';
import 'tabs/page_details/page_details.dart';
import 'tabs/page_tasks/page_tasks.dart';
import 'ui toolkit/hover.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://df440e5981662d9f3951e28cf7f3f041@o4506012740026368.ingest.us.sentry.io/4508544378863616';
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
      options.enableUserInteractionTracing = true;
      options.enableUserInteractionBreadcrumbs = true;
    },
    appRunner: () {
      setupFacade();
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _CustomisedTheme.getTheme(),
      home: MainPage(
        title: 'Flutter Demo Home Page',
        activities: [
          StateNote(initialText: '', timestamp: DateTime.now()),
          StateAction(
              title: "Design error handling mechanism",
              description:
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi facilisis ultrices interdum. Mauris tempus sollicitudin eros id maximus. Praesent scelerisque nulla eget volutpat malesuada. Nullam tincidunt, ligula in congue pharetra, urna nisi ornare elit, accumsan tempus libero nisl sit amet nisi. Sed varius lacinia ipsum. Nullam dictum hendrerit tincidunt. Nunc pharetra sollicitudin blandit.",
              timestamp: DateTime.now(),
              workLog: [
                StateWorkEntry(
                    start: DateTime.now(),
                    durationInMinutes: 60,
                    currentEstimateInMinutes: 60,
                    notes: 'This is the first work entry for this task.'),
                StateWorkEntry(
                    start: DateTime.now(),
                    durationInMinutes: 45,
                    currentEstimateInMinutes: 90,
                    notes: 'This is the second work entry for this task.'),
              ]),
          StateNote(
              initialText: 'This is the second note for this task.',
              timestamp: DateTime.now()),
        ],
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final String title;
  final List<PropertyOwner> activities;
  const MainPage({required this.title, required this.activities, super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabSelected);
    setCurrentContainerFromTabIndex();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderStateApplication(
      workController: ControllerWork(),
      notificationController: ControllerNotifications(),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        LayoutHeader(),
        Expanded(
            child: Scaffold(
                body: Stack(
          children: [
            Column(
              children: [
                LayoutTabBar(controller: _tabController),
                Expanded(
                  child: ProviderHover(
                    controller: _controllerHover,
                    child: TabBarView(
                      controller: _tabController,
                      children: [PageDetails(), PageTasks()],
                    ),
                  ),
                ),
              ],
            ),
            LayoutNotifications(),
          ],
        )))
      ]),
    );
  }

  void _onTabSelected() {
    if (_tabController.indexIsChanging) {
      setCurrentContainerFromTabIndex();
    }
  }

  void setCurrentContainerFromTabIndex() {
    if (_tabController.index == 0 ) {
      Executor.uiContext.setCurrentContainer(UIContainer.tabWorkDetails);
      _controllerHover.setVisibility(name: ControllerHover.workDetails, isVisible: true);
    } else {
      Executor.uiContext.setCurrentContainer(UIContainer.tabTasks);
      _controllerHover.setVisibility(name: ControllerHover.workDetails, isVisible: false);
    }
  }
  
  late final TabController _tabController;
  final ControllerHover _controllerHover = ControllerHover();

/*
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
*/
}

class _CustomisedTheme {
  static ThemeData getTheme() {
    return ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          primary: Colors.red,
          secondary: Colors.black,
        ),
        useMaterial3: true,
        extensions: <ThemeExtension<dynamic>>[
          IconButtonAcceptTheme(
              style: ButtonStyle(
                  iconSize: WidgetStateProperty.all(24.0),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(2.0)),
                  foregroundColor: WidgetStateProperty.all(Colors.green))),
          IconButtonRejectTheme(
              style: ButtonStyle(
                  iconSize: WidgetStateProperty.all(24.0),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(2.0)),
                  foregroundColor: WidgetStateProperty.all(Colors.red))),
          IconButtonActionTheme(
              style: ButtonStyle(
                  iconSize: WidgetStateProperty.all(24.0),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(2.0)),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  backgroundColor: WidgetStateProperty.all(Colors.red))),
          ControlWorkButtonTheme(
              padding: 8,
              hoverColor: Colors.white.withOpacity(0.3),
              hoverBorderWidth: 2.0),
          const WorkDialogTheme(
              gridSize: 8,
              headerTextStyle: TextStyle(
                  fontSize: 28,
                  decoration: TextDecoration.none,
                  color: Colors.black),
              width: 800,
              height: 500,
              backgroundColor: Colors.white),
          const FormTheme(
            labelStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
            valueStyle: TextStyle(fontSize: 16.0),
            valueStyleError: TextStyle(
                fontSize: 16.0,
                backgroundColor: Color.fromARGB(255, 255, 200, 200),
                color: Colors.red),
            textFieldDecoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 255, 255, 255),
                hoverColor: Color.fromARGB(255, 245, 245, 245),
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero)),
            textFieldDecorationChanged: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 255, 255, 235),
                hoverColor: Color.fromARGB(255, 255, 255, 245),
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero)),
            textFieldDecorationError: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 255, 240, 240),
                hoverColor: Color.fromARGB(255, 255, 250, 250),
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero)),
            fleatherEditorHeight: 400,
          )
        ]).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        toolbarHeight: 64.0,
        iconTheme: IconThemeData(color: Colors.white, size: 40),
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.none),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          color: Colors.grey, // Default label color
        ),
        focusColor: Colors.blue,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey), // Focused underline color
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black, width: 2) // Focused underline color
            ),
        activeIndicatorBorder: BorderSide(
            color: Colors.black, width: 2), // Focused underline color
      ),
    );
  }
}
