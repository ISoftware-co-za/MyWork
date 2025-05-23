import 'package:client_interfaces1/notification/layout_notification_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'dialog_work/dialog_work_layout.dart';
import 'execution/executor.dart';
import 'execution/ui_container_context.dart';
import 'header/layout_header.dart';
import 'notification/controller_notifications.dart';
import 'app/controller_user.dart';
import 'app/controller_work_types.dart';
import 'service/service_setup.dart';
import 'app/coordinator_login.dart';
import 'ui_toolkit/custom_icon_buttons.dart';
import 'header/control_button_select_work.dart';
import 'app/provider_state_application.dart';
import 'app/controller_work.dart';
import 'model/properties.dart';
import 'app/state_note.dart';
import 'app/state_action.dart';
import 'tabs/layout_tab_bar.dart';
import 'tabs/page_details/page_details.dart';
import 'tabs/page_tasks/page_tasks.dart';
import 'ui_toolkit/form/form.dart';
import 'ui_toolkit/hover.dart';

Future<void> main() async {
  // TODO: Remove this line before production
  // debugPaintSizeEnabled = true;
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://df440e5981662d9f3951e28cf7f3f041@o4506012740026368.ingest.us.sentry.io/4508544378863616';
      options.sendDefaultPii = true;
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
      options.enableUserInteractionTracing = true;
      options.enableUserInteractionBreadcrumbs = true;
    },
    appRunner: () {
      setupFacades();
      runApp(SentryWidget(child: MyApp()));
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var theme = _CustomisedTheme.getTheme();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
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
          StateNote(initialText: 'This is the second note for this task.', timestamp: DateTime.now()),
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
    _setCurrentContainerFromTabIndex();

    _workController = ControllerWork();
    _userController = ControllerUser();
    _workTypesController = ControllerWorkTypes();
    GetIt.instance.registerSingleton(CoordinatorLogin(_userController, _workTypesController));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderStateApplication(
      userController: _userController,
      workController: _workController,
      workTypesController: _workTypesController,
      notificationController: ControllerNotifications(),
      child: Builder(builder: (context) {
        return FutureBuilder(
          future: Executor.runCommandAsync('login', null, _initializeAsync, context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _mainPage();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      }),
    );
  }

  //#region PRIVATE METHODS

  Future<dynamic> _initializeAsync() async {
    if (_isLoggedIn == false) {
      await GetIt.instance<CoordinatorLogin>().login();
      await _workController.initialise();
      _isLoggedIn = true;
    }
  }

  Widget _mainPage() {
    return Column(mainAxisSize: MainAxisSize.max, children: [
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
    ]);
  }

  void _onTabSelected() {
    if (_tabController.indexIsChanging) {
      _setCurrentContainerFromTabIndex();
    }
  }

  void _setCurrentContainerFromTabIndex() {
    if (_tabController.index == 0) {
      Executor.uiContext.setCurrentContainer(UIContainer.tabWorkDetails);
      _controllerHover.setVisibility(name: ControllerHover.workDetails, isVisible: true);
    } else {
      Executor.uiContext.setCurrentContainer(UIContainer.tabTasks);
      _controllerHover.setVisibility(name: ControllerHover.workDetails, isVisible: false);
    }
  }

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

  //#endregion

  //#region FIELDS

  late final ControllerUser _userController;
  late final ControllerWork _workController;
  late final ControllerWorkTypes _workTypesController;
  late final TabController _tabController;
  final ControllerHover _controllerHover = ControllerHover();
  static bool _isLoggedIn = false;

  //#endregion
}

class _CustomisedTheme {
  static ThemeData getTheme() {
    return ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
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
          ControlWorkButtonTheme(padding: 8, hoverColor: Colors.white.withValues(alpha: 0.3), hoverBorderWidth: 2.0),
          const WorkDialogTheme(
              width: 800,
              height: 500,
              padding: 16,
              horizontalSpacing: 8,
              verticalSpacing: 8,
              headerTextStyle: TextStyle(fontSize: 28, decoration: TextDecoration.none, color: Colors.black),
              backgroundColor: Colors.white),
          const FormTheme(
            labelStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
            valueStyle: TextStyle(fontSize: 16.0),
            valueStyleError:
                TextStyle(fontSize: 16.0, backgroundColor: Color.fromARGB(255, 255, 200, 200), color: Colors.red),
            textFieldDecoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 255, 255, 255),
                hoverColor: Color.fromARGB(255, 245, 245, 245),
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero)),
            textFieldDecorationChanged: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 255, 255, 235),
                hoverColor: Color.fromARGB(255, 255, 255, 245),
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero)),
            textFieldDecorationError: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 255, 240, 240),
                hoverColor: Color.fromARGB(255, 255, 250, 250),
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero)),
            fleatherEditorHeight: 400,
          )
        ]).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        toolbarHeight: 64.0,
        iconTheme: IconThemeData(color: Colors.white, size: 40),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.normal, decoration: TextDecoration.none),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          color: Colors.grey, // Default label color
        ),
        focusColor: Colors.blue,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey), // Focused underline color
        ),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2) // Focused underline color
                ),
        activeIndicatorBorder: BorderSide(color: Colors.black, width: 2), // Focused underline color
      ),
    );
  }
}
