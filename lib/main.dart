import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:launcher/models/preferences.dart';
import 'package:launcher/screens/home.dart';
import 'package:launcher/screens/splash.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(Launcher());
}

class Launcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<Logger>(
      create: (context) =>
          Logger(level: kDebugMode ? Level.debug : Level.nothing),
      builder: (BuildContext context, Widget child) {
        return MaterialApp(
          title: 'Launcher',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
          ),
          color: Colors.black,
          themeMode: ThemeMode.dark,
          home: child,
        );
      },
      child: SplashScreen(
        future: getHomeWithInstalledApps(),
      ),
    );
  }

  Future<Widget> getHomeWithInstalledApps() async {
    List<Application> listOfApps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: true,
      includeAppIcons: true,
    );

    // TODO: Need to implement sort by.
    listOfApps.sort(
      (app1, app2) {
        return app1.appName.compareTo(app2.appName);
      },
    );

    final preferenceBox = await getPreferencesBox();

    return MultiProvider(
      providers: [
        Provider<List<Application>>.value(
          value: listOfApps,
        ),
        ChangeNotifierProvider<Preferences>(
          create: (context) => Preferences(
            preferenceBox: preferenceBox,
          ),
        )
      ],
      child: Home(),
    );
  }
}

Future<Box<dynamic>> getPreferencesBox() async {
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  final preferenceBox = await Hive.openBox(Preferences.preferencesBoxName);
  return preferenceBox;
}
