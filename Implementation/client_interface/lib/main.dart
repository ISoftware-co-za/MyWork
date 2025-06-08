import 'package:client_interfaces1/notification/layout_notification_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'theme/custom_theme_data.dart';
import 'execution/executor.dart';
import 'execution/ui_container_context.dart';
import 'header/layout_header.dart';
import 'notification/controller_notifications.dart';
import 'app/controller_user.dart';
import 'app/controller_work_types.dart';
import 'service/service_setup.dart';
import 'app/coordinator_login.dart';
import 'app/provider_state_application.dart';
import 'app/controller_work.dart';
import 'model/properties.dart';
import 'model/state_note.dart';
import 'model/state_action.dart';
import 'tabs/layout_tab_bar.dart';
import 'tabs/page_details/widgets/layout_page_details.dart';
import 'tabs/page_tasks/page_tasks.dart';
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
    var theme = CustomThemeData.getTheme();
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
    var stateProvider = ProviderStateApplication(
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

    stateProvider.registerController(_userController);
    stateProvider.registerController(_workController);
    stateProvider.registerController(_workTypesController);
    stateProvider.registerController(ControllerNotifications());
    return stateProvider;
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
                    children: [LayoutPageDetails(), PageTasks()],
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

