import 'dart:io';
import 'package:archive/archive.dart';
import 'package:base_app/services/AbstractClassForServices/AbstractZipService.dart';

class ZipService  implements AbstractZipService{
  @override
  Future<File> createZip(List<File> files, String zipPath) async {

    final archive = Archive();

    for (var file in files) {
      try {
        final bytes = await file.readAsBytes();
        final fileName = file.uri.pathSegments.last;
        archive.addFile(ArchiveFile(fileName, bytes.length, bytes));
      } catch (e) {

      }
    }

    final zipFile = File(zipPath);
    final encoder = ZipEncoder();
    final zipData = encoder.encode(archive);

    await zipFile.writeAsBytes(zipData);

    return zipFile;
  }
}
