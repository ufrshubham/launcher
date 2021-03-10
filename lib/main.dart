import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:launcher/models/preferences.dart';
import 'package:launcher/screens/home.dart';
import 'package:launcher/screens/splash.dart';
import 'package:launcher_helper/launcher_helper.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
    Uint8List wallpaperUint8List;
    if (await Permission.storage.request().isGranted) {
      wallpaperUint8List = await LauncherHelper.getWallpaper;
    }

    ApplicationCollection apps = await LauncherHelper.getApplications();

    // List<Application> listOfApps = await DeviceApps.getInstalledApplications(
    //   onlyAppsWithLaunchIntent: true,
    //   includeSystemApps: true,
    //   includeAppIcons: true,
    // );

    // TODO: Need to implement sort by.
    // listOfApps.sort(
    //   (app1, app2) {
    //     return app1.appName.compareTo(app2.appName);
    //   },
    // );

    final preferenceBox = await getPreferencesBox();

    return MultiProvider(
      providers: [
        Provider<ApplicationCollection>.value(
          value: apps,
        ),
        Provider<Uint8List>.value(value: wallpaperUint8List),
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
