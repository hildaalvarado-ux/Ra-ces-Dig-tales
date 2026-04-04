import 'package:flutter/material.dart';

enum AppTextSize { pequeno, normal, grande }

class SettingsProvider extends ChangeNotifier {
  AppTextSize _textSize = AppTextSize.normal;

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

  void setTextSize(AppTextSize size) {
    _textSize = size;
    notifyListeners();
  }
}
