import 'dart:io';


abstract class AbstractEmailService {
  Future<void> sendEmail(File zipFile);
}