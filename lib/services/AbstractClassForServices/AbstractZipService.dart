import 'dart:io';

abstract class AbstractZipService {
  Future<File> createZip(List<File> files, String zipPath);
}