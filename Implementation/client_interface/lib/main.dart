import 'package:client_interfaces1/controller/state_application.dart';
import 'package:client_interfaces1/model/person_list.dart';
import 'package:client_interfaces1/model/provider_state_model.dart';
import 'package:client_interfaces1/tabs/page_activities/controller/controller_activity_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'controller/coordinator_work_and_activity_list_loader.dart';
import 'model/state_model.dart';
import 'notification/layout_notification_list.dart';
import 'tabs/controller_tab_bar.dart';
import 'tabs/page_activities/controller/controller_activity.dart';
import 'tabs/page_activities/widget/layout_page_activities.dart';
import 'theme/custom_theme_data.dart';
import 'execution/executor.dart';
import 'execution/ui_container_context.dart';
import 'header/layout_header.dart';
import 'notification/controller_notifications.dart';
import 'controller/controller_user.dart';
import 'controller/controller_work_types.dart';
import 'service/service_setup.dart';
import 'controller/coordinator_login.dart';
import 'controller/provider_state_application.dart';
import 'controller/controller_work.dart';
import 'tabs/layout_tab_bar.dart';
import 'tabs/page_details/widget/layout_page_details.dart';
import 'ui_toolkit/hover.dart';

void main() {
  // TODO: Remove this line before production
  // debugPaintSizeEnabled = true;
  Intl.defaultLocale = 'en_ZA';
  initializeDateFormatting(Intl.defaultLocale, null);
  setupServiceClients();
  runApp(const MyApp());
  /*
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://df440e5981662d9f3951e28cf7f3f041@o4506012740026368.ingest.us.sentry.io/4508544378863616';
      options.sendDefaultPii = true;
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
      options.enableUserInteractionTracing = true;
      options.enableUserInteractionBreadcrumbs = true;
    },
    appRunner: () {
      Intl.defaultLocale = 'en_ZA';
      initializeDateFormatting(Intl.defaultLocale, null);

      setupServiceClients();
      runApp(SentryWidget(child: MyApp()));
    },
  );
  */
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
      home: MainPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MainPage extends StatefulWidget {
  final String title;
  const MainPage({required this.title, super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabSelected);
    _initialise(_stateApplication);
    _initialiseData = _obtainerDataFromService(_modelState, _stateApplication);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var stateProvider = ProviderStateApplication(
      state: _stateApplication,
      child: Builder(
        builder: (context) {
          return FutureBuilder(
            future: _initialiseData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasError) {
                  debugPrint('Returning _mainPage');
                  return _mainPage();
                } else {
                  debugPrint(snapshot.error.toString());
                  return const Placeholder();
                }
              } else {
                debugPrint('Waiting for _obtainerDataFromService');
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        }
      )
    );
    return ProviderStateModel(state: _modelState, child: stateProvider);
  }

  //#region PRIVATE METHODS

  void _initialise(StateApplication state) {
    final notificationsController = ControllerNotifications();
    final userController = ControllerUser();
    final workTypesController = ControllerWorkTypes();
    Executor.notificationController = notificationsController;
    state.registerController(notificationsController);
    state.registerController(userController);
    state.registerController(workTypesController);
    state.registerCoordinator(
      CoordinatorLogin(userController, workTypesController),
    );
  }

  Future _obtainerDataFromService(
    StateModel stateModel,
    StateApplication stateApplication,
  ) async {
    await _login(stateApplication);
    await _initialiseState(stateModel, stateApplication);
    _setCurrentContainerFromTabIndex();
  }

  Future _login(StateApplication state) async {
    if (_isLoggedIn == false) {
      debugPrint('Perform _login - START');
      try
      {
        await state.getCoordinator<CoordinatorLogin>()!.login();
      } catch(e) {
        debugPrint(e.toString());
      }

      debugPrint('Perform _login - END');
      _isLoggedIn = true;
    }
  }

  Future _initialiseState(
    StateModel stateModel,
    StateApplication stateApplication,
  ) async {
    if (_isStateInitialised == false) {
      debugPrint('Perform _initialiseState - START');

      final people = PersonList();
      _workController = ControllerWork();
      _activityListController = ControllerActivityList(people);
      _controllerTabBar = ControllerTabBar(
        _tabController,
        _workController,
        _activityListController,
      );

      await people.loadAll();
      stateModel.registerInstance(people);
      await _workController.initialise();

      stateApplication.registerController(_workController);
      stateApplication.registerController(_activityListController);
      stateApplication.registerController(
        ControllerActivity(people, _activityListController.selectedActivity),
      );
      stateApplication.registerController(_controllerTabBar);
      stateApplication.registerCoordinator(
        CoordinatorWorkActivityListLoader(
          stateApplication.getController<ControllerWork>()!,
          _activityListController,
        ),
      );
      debugPrint('Perform _initialiseState - END');
      _isStateInitialised = true;
    }
  }

  Widget _mainPage() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        LayoutHeader(),
        Expanded(
          child: Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    LayoutTabBar(
                      coordinatorWorkAndActivityChange:
                          _controllerTabBar.coordinatorWorkAndActivityChange,
                      controller: _tabController,
                    ),
                    Expanded(
                      child: ProviderHover(
                        controller: _controllerHover,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            LayoutPageDetails(),
                            LayoutPageActivities(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                LayoutNotifications(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onTabSelected() {
    if (_tabController.indexIsChanging) {
      _setCurrentContainerFromTabIndex();
    }
  }

  void _setCurrentContainerFromTabIndex() async {
    if (_tabController.index == 0 &&
        await _activityListController.saveActivityIfRequired() == false) {
      _tabController.index = 1;
      return;
    }
    if (_tabController.index == 1 &&
        await _workController.saveActivityIfRequired() == false) {
      _tabController.index = 0;
      return;
    }
    if (_tabController.index == 0) {
      Executor.uiContext.setCurrentContainer(UIContainer.tabWorkDetails);
      _controllerHover.setVisibility(
        name: ControllerHover.workDetails,
        isVisible: true,
      );
      _controllerHover.setVisibility(
        name: ControllerHover.layoutDetailsForm,
        isVisible: false,
      );
    } else {
      Executor.uiContext.setCurrentContainer(UIContainer.tabTasks);
      _controllerHover.setVisibility(
        name: ControllerHover.layoutDetailsForm,
        isVisible: true,
      );
      _controllerHover.setVisibility(
        name: ControllerHover.workDetails,
        isVisible: false,
      );
    }
  }

  //#endregion

  //#region FIELDS

  late final TabController _tabController;
  late final ControllerTabBar _controllerTabBar;
  final ControllerHover _controllerHover = ControllerHover();
  late final Future _initialiseData;
  bool _isLoggedIn = false;
  bool _isStateInitialised = false;
  final _modelState = StateModel();
  final _stateApplication = StateApplication();
  late final ControllerWork _workController;
  late final ControllerActivityList _activityListController;

  //#endregion
}
