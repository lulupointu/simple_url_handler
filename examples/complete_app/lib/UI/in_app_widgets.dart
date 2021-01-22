import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final VoidCallback onPressed;

  ProfileWidget({@required this.onPressed}) : super();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Your profile'),
    );
  }
}

class SettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Your settings'),
          FlatButton(
            color: Colors.redAccent,
            child: Icon(Icons.arrow_back_ios),
            onPressed: () {
              return Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
