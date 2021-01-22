import 'package:flutter/material.dart';

class MyAuthenticationWidget extends StatelessWidget {
  final VoidCallback onPressed;

  MyAuthenticationWidget({@required this.onPressed}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('You are NOT connected'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Container(
                padding: EdgeInsets.all(8.0),
                color: Colors.greenAccent,
                child: Text('Click me to connect.'),
              ),
              onPressed: onPressed,
            )
          ],
        ),
      ),
    );
  }
}
