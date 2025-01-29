import 'package:base_app/services/AbstractClassForServices/AbstractSmsService.dart';
import 'package:telephony/telephony.dart';

class SmsService implements AbstractSmsService{

  final Telephony telephony = Telephony.instance;


  bool isDataLoading = false;

  Future<List<SmsMessage>> getSmsMessages() async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;

    if (isDataLoading) return [];
    isDataLoading = true;

    if(permissionsGranted!){
      try {
        List<SmsMessage> messages = await telephony.getInboxSms();
        return messages;
      } catch (e) {
        return [];
      } finally {
        isDataLoading = false;
      }
    }else{
      return [];
    }

  }
}
