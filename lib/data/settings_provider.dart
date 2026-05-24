import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTextSize { pequeno, normal, grande }

class SettingsProvider extends ChangeNotifier {
  AppTextSize _textSize = AppTextSize.normal;

  SettingsProvider() {
    _loadSettings();
  }

  AppTextSize get textSize => _textSize;

  double get textScaleFactor {
    switch (_textSize) {
      case AppTextSize.pequeno:
        return 0.85;
      case AppTextSize.normal:
        return 1.0;
      case AppTextSize.grande:
        return 1.25;
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final sizeIndex = prefs.getInt('textSize');
    if (sizeIndex != null) {
      _textSize = AppTextSize.values[sizeIndex];
      notifyListeners();
    }
  }

  Future<void> setTextSize(AppTextSize size) async {
    _textSize = size;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('textSize', size.index);
  }
}
