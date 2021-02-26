import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// This widget will display the app icon and app name of the given [app].
/// It will also launch the given [app] on tap.
class App extends StatelessWidget {
  final ApplicationWithIcon app;
  const App({Key key, this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logger = Provider.of<Logger>(context, listen: false);
    return InkResponse(
      child: GridTile(
        child: Image.memory(
          app.icon,
        ),
        footer: Text(
          app.appName,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onTap: () async {
        if (await DeviceApps.openApp(app.packageName)) {
          logger.i('${app.appName} was opened');
        } else {
          logger.e('${app.appName} failed to open');
        }
      },
    );
  }
}
