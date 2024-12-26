import 'dart:developer';

import 'package:no_screenshot/no_screenshot.dart';

class UseFullFunctions {
  final _noScreenshot = NoScreenshot.instance;

  Future<void> disableScreenshot() async {
    bool result = await _noScreenshot.screenshotOff();
    log('Screenshot Off: $result');
  }
}
