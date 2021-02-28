import 'package:device_apps/device_apps.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:launcher/screens/home.dart';
import 'package:launcher/screens/splash.dart';
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
        Provider<Logger>(
          create: (context) =>
              Logger(level: kDebugMode ? Level.debug : Level.nothing),
        ),
      ],
      builder: (BuildContext context, Widget child) {
        return MaterialApp(
          title: 'Launcher',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
          ),
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

    return Provider<List<Application>>.value(
      value: listOfApps,
      child: Home(),
    );
  }
}
