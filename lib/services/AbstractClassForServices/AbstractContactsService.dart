import 'package:contacts_service/contacts_service.dart';

abstract class AbstractContactsService {
  Future<List<Contact>> getContactsFromDevice();
}