import 'package:flutter/material.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';

import '../UI/authentication_widget.dart';
import 'app_state.dart';
import 'nested_router.dart';

class AuthenticationRouter extends StatefulWidget {
  final BuildContext context;

  const AuthenticationRouter({Key key, @required this.context})
      : super(key: key);

  @override
  _AuthenticationRouterState createState() => _AuthenticationRouterState();
}

class _AuthenticationRouterState extends State<AuthenticationRouter> {
  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: AuthenticationRouterDelegate(),
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}

final GlobalKey<NavigatorState> _authenticationRouterDelegateNavigatorKey =
    GlobalKey<NavigatorState>();

class AuthenticationRouterDelegate extends RouterDelegate with ChangeNotifier {
  @override
  Future<bool> popRoute() async {
    MoveToBackground.moveTaskToBack();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _authenticationRouterDelegateNavigatorKey,
      observers: [HeroController()],
      pages: [
        MaterialPage(
          key: ValueKey('MyHomePage'),
          child: MyAuthenticationWidget(
            onPressed: () {
              Provider.of<AppState>(context, listen: false).isAuthenticated =
                  true;
            },
          ),
        ),
        if (Provider.of<AppState>(context).isAuthenticated)
          MaterialPage(
            key: ValueKey('NestedNavigatorPage'),
            child: NestedRouterWidget(),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        Provider.of<AppState>(context, listen: false).isAuthenticated = false;
        return true;
      },
    );
  }

  // Navigation state to app state
  @override
  Future<void> setNewRoutePath(navigationState) => null;
}
