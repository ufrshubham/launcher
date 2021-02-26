import 'package:device_apps/device_apps.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:launcher/screens/home.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Launcher());
}

class Launcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<List<Application>>(
          create: (BuildContext context) => DeviceApps.getInstalledApplications(
            onlyAppsWithLaunchIntent: true,
            includeSystemApps: true,
            includeAppIcons: true,
          ),
          initialData: [], // This makes sure that while getInstalledApplications is running, nothing breaks downstream.
        ),
        Provider<Logger>(
          create: (context) =>
              Logger(level: kDebugMode ? Level.debug : Level.nothing),
        ),
      ],
      builder: (BuildContext context, Widget child) {
        return MaterialApp(
          title: 'Launcher',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          home: child,
        );
      },
      child: Home(),
    );
  }
}
