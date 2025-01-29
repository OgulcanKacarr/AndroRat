import 'package:telephony/telephony.dart';

abstract class AbstractSmsService {
  Future<List<SmsMessage>> getSmsMessages();
}