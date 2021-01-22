import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'logic/app_state.dart';
import 'logic/url_handler.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      builder: (context, _) {
        return MyUrlHandler(context: context,);
      },
    ),
  );
}
