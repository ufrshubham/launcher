import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:launcher/widgets/app.dart';
import 'package:provider/provider.dart';

// This is the first screen that users will see.
class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      /// Make sure that Home will not get popped by system.
      onWillPop: () async => false,
      child: Scaffold(
        body: Consumer<List<Application>>(
          builder:
              (BuildContext context, List<Application> apps, Widget child) {
            return GridView.builder(
              padding: const EdgeInsets.only(
                top: 50.0,
                left: 20.0,
                right: 20.0,
                bottom: 50.0,
              ),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: apps.length,
              itemBuilder: (BuildContext context, int index) {
                return App(
                  app: apps.elementAt(index) as ApplicationWithIcon,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
