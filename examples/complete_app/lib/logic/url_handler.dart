import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_url_handler/simple_url_handler.dart';

import 'app_state.dart';
import 'authentication_router.dart';

class MyUrlHandler extends StatelessWidget {
  static int i = 0;
  final BuildContext context;

  const MyUrlHandler({Key key, this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleUrlHandler(
      urlToAppState: urlToAppState,
      appStateToUrl: appStateToUrl,
      child: Builder(
        builder: (BuildContext context) {
          Provider.of<AppState>(context, listen: false)
              .addListener(SimpleUrlNotifier.of(context).notify);
          return AuthenticationRouter(context: context);
        },
      ),
    );
  }

  Future<void> urlToAppState(BuildContext context, RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location);
    if (uri.pathSegments.length == 0) {
      SimpleUrlNotifier.of(context).notify();
      return null;
    }

    // If we are authenticated
    if (Provider.of<AppState>(context, listen: false).isAuthenticated) {
      if (uri.pathSegments[0] == 'login') {
        // If the user is authenticated and wants to go to the login, check for redirection data
        switch (uri.fragment) {
          case 'profile':
            // If the user is authenticated and wants to be redirected to the profile, go to the profile
            Provider.of<AppState>(context, listen: false).selectedBottomNavigationBarIndex = 0;
            break;
          case 'settings':
            // If the user is authenticated and wants to be redirected to the settings, go to the settings
            Provider.of<AppState>(context, listen: false).selectedBottomNavigationBarIndex = 1;
            break;
          default:
            // If no redirection or wrong redirection, do nothing
            break;
        }

        // In any case, call notify manually because the AppState might not change
        // but the url has to be updated to a valid one
        SimpleUrlNotifier.of(context).notify();
        return null;
      } else if (uri.pathSegments[0] == 'profile') {
        // If the user is authenticated and wants to go to the profile, go to profile
        Provider.of<AppState>(context, listen: false).selectedBottomNavigationBarIndex = 0;
        return null;
      } else if (uri.pathSegments[0] == 'settings') {
        // If the user is authenticated and wants to go to the settings, go to settings
        Provider.of<AppState>(context, listen: false).selectedBottomNavigationBarIndex = 1;
        return null;
      } else {
        // No valid case was caught, update the url back to a valid one
        SimpleUrlNotifier.of(context).notify();
        return null;
      }
    }

    // If we are NOT authenticated
    if (uri.pathSegments[0] == 'login') {
      InAppPages redirectedFrom;
      switch (uri.fragment) {
        case 'profile':
          redirectedFrom = InAppPages.profile;
          break;
        case 'settings':
          redirectedFrom = InAppPages.settings;
          break;
      }

      // If the user is not authenticated and wants to go to the login, check for redirection data
      Provider.of<AppState>(context, listen: false).redirectedFrom = redirectedFrom;
      return null;
    } else if (uri.pathSegments[0] == 'profile') {
      // If the user is authenticated and wants to go to the profile, set redirection to profile
      Provider.of<AppState>(context, listen: false).redirectedFrom = InAppPages.profile;
      return null;
    } else if (uri.pathSegments[0] == 'settings') {
      // If the user is authenticated and wants to go to the settings, set redirection to settings
      Provider.of<AppState>(context, listen: false).redirectedFrom = InAppPages.settings;
      return null;
    }

    // No valid case was caught, update the url back to a valid one
    SimpleUrlNotifier.of(context).notify();
    return null;
  }

  RouteInformation appStateToUrl() {
    // If we are NOT authenticated, set navigation state to login
    if (!Provider.of<AppState>(context, listen: false).isAuthenticated) {
      switch (Provider.of<AppState>(context, listen: false).redirectedFrom) {
        case InAppPages.profile:
          return RouteInformation(location: '/login#profile');
        case InAppPages.settings:
          return RouteInformation(location: '/login#settings');
          break;
        default:
          return RouteInformation(location: '/login');
      }
    }

    // Else set it as a function of the selectedBottomNavigationBarIndex
    final int selectedBottomNavigationBarIndex =
        Provider.of<AppState>(context, listen: false).selectedBottomNavigationBarIndex;
    if (selectedBottomNavigationBarIndex == 0) {
      return RouteInformation(location: '/profile');
    } else {
      return RouteInformation(location: '/settings');
    }
  }
}
