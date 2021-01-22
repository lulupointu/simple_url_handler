import 'package:flutter/foundation.dart';

enum InAppPages {
  profile,
  settings,
}

class AppState extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  set isAuthenticated(bool value) {
    if (value != _isAuthenticated) {
      // If we are authenticating and redirectFrom is set, redirect
      if (!_isAuthenticated && _redirectedFrom != null) {
        switch (_redirectedFrom) {
          case InAppPages.profile:
            selectedBottomNavigationBarIndex = 0;
            break;
          case InAppPages.settings:
            selectedBottomNavigationBarIndex = 1;
            break;
        }
        _redirectedFrom = null;
      }

      _isAuthenticated = value;
      notifyListeners();
    }
  }

  int _selectedBottomNavigationBarIndex = 0;

  int get selectedBottomNavigationBarIndex => _selectedBottomNavigationBarIndex;

  set selectedBottomNavigationBarIndex(int value) {
    if (value != _selectedBottomNavigationBarIndex) {
      _selectedBottomNavigationBarIndex = value;
      notifyListeners();
    }
  }

  InAppPages _redirectedFrom;

  InAppPages get redirectedFrom => _redirectedFrom;

  set redirectedFrom(InAppPages value) {
    if (value != _redirectedFrom) {
      _redirectedFrom = value;
      notifyListeners();
    }
  }
}
