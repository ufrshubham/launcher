import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launcher_helper/launcher_helper.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// This widget will display the app icon and app name of the given [app].
/// It will also launch the given [app] on tap.
class App extends StatelessWidget {
  final Application app;
  const App({Key key, this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logger = Provider.of<Logger>(context, listen: false);
    return InkResponse(
      child: GridTile(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: app.icon,
          ),
        ),
        footer: Text(
          app.label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onTap: () async {
        try {
          if (await LauncherHelper.launchApp(app.packageName)) {
            logger.i('${app.label} was opened');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Cannot open ${app.label}. It might be a system app.'),
              ),
            );
            logger.e('${app.label} failed to open');
          }
        } on PlatformException catch (exception) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Cannot open ${app.label}. It might be a system app.'),
            ),
          );
          logger.e(
            '${app.label} failed to open. Reason: ${exception.message}',
          );
        }
      },
    );
  }
}
