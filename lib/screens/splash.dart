import 'package:flutter/material.dart';

/// This widgets displays a splash screen till give [future] completes.
/// Future is expected to return a widget to navigate to.
class SplashScreen extends StatefulWidget {
  final Future<Widget> future;

  const SplashScreen({
    Key key,
    @required this.future,
  })  : assert(future != null),
        super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    widget.future.then((nextWidget) {
      if (nextWidget != null) {
        navigateToNextWidget(nextWidget);
      }
    });
  }

  void navigateToNextWidget(Widget child) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return child;
      }, transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        var curve = Curves.ease;

        var tween =
            Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: curve));
        var opacityAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: opacityAnimation,
          child: child,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Launcher',
          style: TextStyle(fontSize: 25.0),
        ),
      ),
    );
  }
}
