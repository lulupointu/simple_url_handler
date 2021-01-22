import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../UI/in_app_widgets.dart';
import 'app_state.dart';

class NestedRouterWidget extends StatelessWidget {
  NestedRouterWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final childBackButtonDispatcher =
        ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher);
    childBackButtonDispatcher.takePriority();
    return Router(
      routerDelegate: NestedRouterDelegate(),
      backButtonDispatcher: childBackButtonDispatcher,
    );
  }
}

final GlobalKey<NavigatorState> _nestedRouterDelegateNavigatorKey =
    GlobalKey<NavigatorState>();

class NestedRouterDelegate extends RouterDelegate with ChangeNotifier {
  @override
  Future<bool> popRoute() async {
    print('popRoute NestedRouterDelegate');
    _nestedRouterDelegateNavigatorKey.currentState?.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('You are connected'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            Provider.of<AppState>(context).selectedBottomNavigationBarIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
        onTap: (int index) {
          Provider.of<AppState>(context, listen: false)
              .selectedBottomNavigationBarIndex = index;
        },
      ),
      body: Navigator(
        key: _nestedRouterDelegateNavigatorKey,
        pages: [
          if (Provider.of<AppState>(context).selectedBottomNavigationBarIndex ==
              0)
            MaterialPage(
              key: ValueKey('ProfilePage'),
              child: ProfileWidget(
                onPressed: () {},
              ),
            ),
          if (Provider.of<AppState>(context).selectedBottomNavigationBarIndex ==
              1)
            MaterialPage(
              key: ValueKey('NestedNavigatorPage'),
              child: SettingWidget(),
            ),
        ],
        onPopPage: (route, result) {
          print('onPopPage NestedRouterDelegate');
          return false;
        },
      ),
    );
  }

  // We don't use this
  @override
  Future<void> setNewRoutePath(configuration) => SynchronousFuture(null);
}
