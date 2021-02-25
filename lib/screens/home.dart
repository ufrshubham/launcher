import 'package:flutter/material.dart';

// This is the first screen that users will see.
class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to Launcher!',
        ),
      ),
    );
  }
}
