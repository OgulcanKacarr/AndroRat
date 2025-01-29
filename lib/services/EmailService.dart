import 'package:base_app/constants/AppStrings.dart';
import 'package:base_app/services/AbstractClassForServices/AbstractEmailService.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';

import '../constants/ConstMethods.dart';

class EmailService implements AbstractEmailService {


  @override
  Future<void> sendEmail(File zipFile) async {
    String credentials = await ConstMethods.fetchTargetEmail();
    final smtpServer = gmail(AppStrings.email,AppStrings.password );
    final message = Message()
      ..from =   Address(credentials,  AppStrings.info)
      ..recipients.add(credentials)
      ..subject = AppStrings.subject
      ..text = AppStrings.content
      ..attachments.add(FileAttachment(zipFile));
    try {
      await send(message, smtpServer).timeout(const Duration(minutes: 3));
      print("E-posta başarıyla gönderildi.");
    } catch (e) {
      print("E-posta gönderilirken hata oluştu: ${e.toString()}");
    }
  }



}
