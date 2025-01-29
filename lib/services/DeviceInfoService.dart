import 'dart:io';
import 'package:base_app/services/AbstractClassForServices/AbstractDeviceInfoService.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService implements AbstractDeviceInfoService{
  @override
  Future<List<String>> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    List<String> deviceInfoList = [];

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      deviceInfoList.add("Cihaz Modeli: ${androidInfo.model}");
      deviceInfoList.add("Cihaz Markası: ${androidInfo.brand}");
      deviceInfoList.add("Android Versiyonu: ${androidInfo.version.release}");
      deviceInfoList.add("Android Cihaz Numarası: ${androidInfo.device}");
      deviceInfoList.add("Cihazın Donanım ID'si: ${androidInfo.fingerprint}");
      deviceInfoList.add("Cihazın Üretici Bilgisi: ${androidInfo.hardware}");
    }

    return deviceInfoList;
  }
}
