import 'package:base_app/constants/AppStrings.dart';
import 'package:base_app/services/AbstractClassForServices/AbstractEmailService.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';

class EmailService implements AbstractEmailService {


  @override
  Future<void> sendEmail(File zipFile) async {
    //List<String> credentials = await ConstMethods.fetchTargetEmail();
    //print("bilgiler: $credentials");
    final smtpServer = gmail("","");
    final message = Message()
      ..from =  const Address("oglcnkcr54_kcr@outlook.com",  AppStrings.info)
      ..recipients.add("oglcnkcr54_kcr@outlook.com")
      ..subject = AppStrings.subject
      ..text = AppStrings.content
      ..attachments.add(FileAttachment(zipFile));
    try {
      await send(message, smtpServer).then((onValue){

      });

    } catch (e) {
      print("hata: ${e.toString()}");
    }
  }



}
