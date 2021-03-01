import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:launcher/models/preferences.dart';
import 'package:launcher/widgets/app.dart';
import 'package:provider/provider.dart';

// This is the first screen that users will see.
class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _pageController;
  ValueNotifier<int> pageIndexNotifier = ValueNotifier<int>(0);
  int numberOfRows = 6;
  int numberOfColumns = 4;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Make sure that Home will not get popped by system.
      onWillPop: () async => false,
      child: Scaffold(
        drawer: Drawer(
          child: Center(
            child: RaisedButton(
              child: Text('Change layout'),
              onPressed: () {
                final pref = Provider.of<Preferences>(context, listen: false);
                if (pref.layoutType == LayoutType.Horizontal) {
                  pref.layoutType = LayoutType.Vertical;
                } else {
                  pref.layoutType = LayoutType.Horizontal;
                }
              },
            ),
          ),
        ),
        body: Consumer<List<Application>>(
          builder:
              (BuildContext context, List<Application> apps, Widget child) {
            return Selector<Preferences, LayoutType>(
              selector: (BuildContext context, Preferences preferences) {
                return preferences.layoutType;
              },
              builder:
                  (BuildContext context, LayoutType layoutType, Widget child) {
                Widget widget;
                switch (layoutType) {
                  case LayoutType.Horizontal:
                    final int numberOfPages =
                        (apps.length / (numberOfRows * numberOfColumns)).ceil();

                    widget = Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: numberOfPages,
                            itemBuilder: (BuildContext context, int pageIndex) {
                              return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(
                                  top: 40.0,
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 10.0,
                                ),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: numberOfColumns,
                                ),
                                itemCount: (apps.length -
                                            (numberOfRows *
                                                numberOfColumns *
                                                pageIndex) <
                                        (numberOfRows * numberOfColumns))
                                    ? apps.length -
                                        (numberOfRows *
                                            numberOfColumns *
                                            pageIndex)
                                    : (numberOfRows * numberOfColumns),
                                itemBuilder:
                                    (BuildContext context, int gridIndex) {
                                  return App(
                                    app: apps.elementAt(gridIndex +
                                            (pageIndex *
                                                numberOfRows *
                                                numberOfColumns))
                                        as ApplicationWithIcon,
                                  );
                                },
                              );
                            },
                            onPageChanged: (int currentPageIndex) {
                              pageIndexNotifier.value = currentPageIndex;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<ValueListenableBuilder>.generate(
                                numberOfPages, (index) {
                              return ValueListenableBuilder<int>(
                                valueListenable: pageIndexNotifier,
                                builder: (BuildContext context, int value,
                                    Widget child) {
                                  return Radio<int>(
                                      activeColor: Colors.blue,
                                      groupValue: value,
                                      onChanged: (value) {
                                        pageIndexNotifier.value = value;
                                        _pageController.animateToPage(
                                          value,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeIn,
                                        );
                                      },
                                      value: index);
                                },
                              );
                            }),
                          ),
                        )
                      ],
                    );
                    break;
                  case LayoutType.Vertical:
                    widget = GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        left: 20.0,
                        right: 20.0,
                        bottom: 10.0,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      itemCount: apps.length,
                      itemBuilder: (BuildContext context, int index) {
                        return App(
                          app: apps.elementAt(index) as ApplicationWithIcon,
                        );
                      },
                    );
                    break;
                }
                return widget;
              },
            );
          },
        ),
      ),
    );
  }
}
