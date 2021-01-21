import 'package:flutter/material.dart';
import 'package:simple_url_handler/simple_url_handler.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return SimpleUrlHandler(
      debugShowCheckedModeBanner: false,
      urlToAppState: (BuildContext context, RouteInformation routeInformation) {
        final newCounter = int.tryParse(routeInformation.location.substring(1));
        if (newCounter != null && newCounter != count) {
          setState(() {
            count = newCounter;
          });
        } else if (newCounter == null) {
          // if newCounter is null, the url is illicit so
          // change the url back to the one synced with the state
          SimpleUrlNotifier.of(context).notify();
        }
        return;
      },
      appStateToUrl: () => RouteInformation(location: '/$count'),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Counter App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$count',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              count++;
            });
            // No need to call SimpleUrlNotifier.of(context).notify();
            // Since the widget will be rebuilt which will rebuild
            // the SimpleUrlHandler.
          },
          tooltip: 'Counter',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
