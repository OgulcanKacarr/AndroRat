import 'dart:convert';
import 'package:base_app/constants/AppStrings.dart';
import 'package:base_app/services/AbstractClassForServices/AbstractGalleryService.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryService implements AbstractGalleryService{
  @override
  Future<bool> requestGalleryPermission() async {
    PermissionStatus status = await Permission.photos.request();
    return status.isGranted;
  }

  @override
  Future<List<AssetEntity>> getPhotos() async {
    bool isPermissionGranted = await requestGalleryPermission();
    if (!isPermissionGranted) {
      throw Exception(AppStrings.galleryPermissionWasNotGranted);
    }
    try {
      final assetPathList = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(),
      );
      if (assetPathList.isEmpty) {
        throw Exception(AppStrings.galleryAlbumNotFound);
      }

      final assets = await assetPathList[0].getAssetListPaged(
        page: 0,
        size: 5,
      );
      if (assets.isEmpty) {
        throw Exception(AppStrings.galleryPhotoNotFound);
      }
      return assets;
    } catch (e) {
      throw Exception('${AppStrings.errorRetrievingGalleryPhotos}: $e');
    }
  }


  @override
  Future<String> convertPhotoToBase64(AssetEntity asset) async {
    final file = await asset.file;
    if (file == null) {
      throw Exception(AppStrings.photoFileCouldNotBeRetrieved);
    }
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }
}