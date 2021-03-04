import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:launcher/models/preferences.dart';
import 'package:launcher/screens/app_drawer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<List<Application>>(
      builder: (BuildContext context, List<Application> apps, Widget child) {
        return Consumer<Preferences>(
          builder: (BuildContext context, Preferences pref, Widget child) {
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/wallpaper.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: GestureDetector(
                  onVerticalDragEnd: (DragEndDetails details) {
                    if (details.velocity.pixelsPerSecond.dy < -100) {
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        builder: (context) => BottomSheet(
                          builder: (BuildContext context) {
                            return MultiProvider(
                              providers: [
                                Provider<List<Application>>.value(
                                  value: apps,
                                ),
                                ChangeNotifierProvider<Preferences>.value(
                                  value: pref,
                                ),
                              ],
                              builder: (BuildContext context, Widget child) {
                                return AppDrawer();
                              },
                            );
                          },
                          onClosing: () {},
                        ),
                      );
                    }
                  },
                ),
              ),
              // bottomSheet: BottomSheet(
              //   enableDrag: true,
              //   builder: (BuildContext context) {
              //     return AppDrawer();
              //   },
              //   onClosing: () {},
              // ),
            );
          },
        );
      },
    );
  }
}
