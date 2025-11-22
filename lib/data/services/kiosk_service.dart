import 'package:flutter/services.dart';

class KioskService {
  static const MethodChannel _ch = MethodChannel('tv_apps_channel');

  static Future<bool> isDeviceOwner() async {
    try {
      final bool res = await _ch.invokeMethod('isDeviceOwner');
      return res;
    } catch (e) {
      return false;
    }
  }

  /// packages: list of package names allowed for lock task; odatda own package
  static Future<bool> setLockPackages(List<String> packages) async {
    try {
      final bool res = await _ch.invokeMethod('setLockPackages', {'packages': packages});
      return res;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> startLockTask() async {
    try {
      final bool res = await _ch.invokeMethod('startLockTask');
      return res;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> stopLockTask() async {
    try {
      final bool res = await _ch.invokeMethod('stopLockTask');
      return res;
    } catch (e) {
      return false;
    }
  }
}
