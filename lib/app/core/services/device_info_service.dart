// ignore_for_file: dead_code

import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class DeviceInfoService {
  static final DeviceInfoService _instance = DeviceInfoService._internal();
  final _deviceInfoPlugin = DeviceInfoPlugin();

  DeviceInfoService._internal();

  factory DeviceInfoService() {
    return _instance;
  }

  /// Obtém informações do dispositivo
  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        return await _getAndroidInfo();
      } else if (Platform.isIOS) {
        return await _getIosInfo();
      } else if (Platform.isWindows) {
        return await _getWindowsInfo();
      } else if (Platform.isLinux) {
        return await _getLinuxInfo();
      } else if (Platform.isMacOS) {
        return await _getMacOsInfo();
      }
    } catch (e) {
      return _getDefaultDeviceInfo();
    }
    return _getDefaultDeviceInfo();
  }

  Future<Map<String, dynamic>> _getAndroidInfo() async {
    final info = await _deviceInfoPlugin.androidInfo;
    return {
  
      "deviceBrand": info.brand,
      "deviceModel": info.model,
      "deviceOs": "Android",
      "deviceOsVersion": info.version.release,
    };
  }

  Future<Map<String, dynamic>> _getIosInfo() async {
    final info = await _deviceInfoPlugin.iosInfo;
    return {
      "deviceBrand": "Apple",
      "deviceModel": info.model,
      "deviceOs": "iOS",
      "deviceOsVersion": info.systemVersion,
    };
  }

  Future<Map<String, dynamic>> _getWindowsInfo() async {
    final info = await _deviceInfoPlugin.windowsInfo;
    return {
      "deviceBrand": "Windows",
      "deviceModel": info.computerName,
      "deviceOs": "Windows",
      "deviceOsVersion": info.displayVersion,
    };
  }

  Future<Map<String, dynamic>> _getLinuxInfo() async {
    final info = await _deviceInfoPlugin.linuxInfo;
    return {
      "deviceBrand": info.id,
      "deviceModel": info.prettyName,
      "deviceOs": "Linux",
      "deviceOsVersion": info.version ?? "Unknown",
    };
  }

  Future<Map<String, dynamic>> _getMacOsInfo() async {
    final info = await _deviceInfoPlugin.macOsInfo;
    return {
      "deviceBrand": "Apple",
      "deviceModel": info.model,
      "deviceOs": "macOS",
      "deviceOsVersion": info.osRelease,
    };
  }

  Map<String, dynamic> _getDefaultDeviceInfo() {
    return {
      "deviceBrand": "Unknown",
      "deviceModel": "Unknown",
      "deviceOs": "Unknown",
      "deviceOsVersion": "Unknown",
    };
  }
}
