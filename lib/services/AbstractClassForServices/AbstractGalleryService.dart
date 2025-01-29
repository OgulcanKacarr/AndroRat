import 'package:photo_manager/photo_manager.dart';

abstract class AbstractGalleryService {
  Future<bool> requestGalleryPermission();
  Future<List<AssetEntity>> getPhotos();
  Future<String> convertPhotoToBase64(AssetEntity asset);
}