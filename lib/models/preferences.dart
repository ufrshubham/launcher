import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class Preferences extends ChangeNotifier {
  static const preferencesBoxName = 'Preferences';
  static const _layoutTypePrefKey = 'LayoutType';

  LayoutType _layoutType;
  bool _isFirstLaunch = false;

  final Box<dynamic> preferenceBox;

  Preferences({@required this.preferenceBox})
      : assert(preferenceBox != null),
        super() {
    var value = preferenceBox.get(_layoutTypePrefKey);
    if (value == null) {
      _isFirstLaunch = true;
      value = LayoutType.Horizontal.index;
      preferenceBox.put(_layoutTypePrefKey, value);
    }
    _layoutType = LayoutType.values.elementAt(value);
  }

  /// Returns the current [LayoutType] set by users.
  LayoutType get layoutType => _layoutType;

  /// Sets the given [layoutType].
  set layoutType(LayoutType layoutType) {
    if (layoutType != null) {
      _layoutType = layoutType;
      preferenceBox.put(_layoutTypePrefKey, _layoutType.index);
      notifyListeners();
    }
  }

  /// Returns true if this launcher is launched for the first time, false otherwise.
  bool get isFirstLaunch => _isFirstLaunch;
}

/// This enum indicates if app list should be scrollable horizontally or vertically.
enum LayoutType { Horizontal, Vertical }
