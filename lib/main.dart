import 'package:flutter/material.dart';
import 'package:launcher/screens/home.dart';

void main() {
  runApp(Launcher());
}

class Launcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Launcher',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Home(),
    );
  }
}
