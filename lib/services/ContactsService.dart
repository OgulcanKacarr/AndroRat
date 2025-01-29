import 'package:base_app/services/AbstractClassForServices/AbstractContactsService.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactsServices implements AbstractContactsService {
  @override
  Future<List<Contact>> getContactsFromDevice() async {
    return await ContactsService.getContacts();
  }

}


