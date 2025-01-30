

import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import '../constants/AppStrings.dart';
import 'AbstractClassForServices/AbstractGalleryService.dart';

class GalleryService implements AbstractGalleryService {
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
        size: 30,
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

    // List<int> → Uint8List dönüşümü
    Uint8List uint8ImageBytes = Uint8List.fromList(imageBytes);

    var compressedImage = await FlutterImageCompress.compressWithList(
      uint8ImageBytes,
      quality: 50,
    );

    return base64Encode(Uint8List.fromList(compressedImage));
  }


}
