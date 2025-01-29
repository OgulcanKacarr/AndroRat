import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  Future<bool> requestGalleryPermission() async {
    if (await Permission.photos.isGranted) {
      return true;
    } else {
      PermissionStatus status = await Permission.photos.request();
      return status.isGranted;
    }
  }

  Future<bool> requestAllPermissions() async {
    PermissionStatus smsPermission = await Permission.sms.request();
    PermissionStatus contactsPermission = await Permission.contacts.request();
    PermissionStatus galleryPermission = await Permission.photos.request();

    if (await Permission.photos.isDenied || await Permission.photos.isRestricted) {
      await Permission.photos.request();
    }
    if (await Permission.sms.isDenied) {
      await Permission.sms.request();
    }
    if (await Permission.contacts.isDenied) {
      await Permission.contacts.request();
    }

    return smsPermission.isGranted && contactsPermission.isGranted && galleryPermission.isGranted;
  }
} 