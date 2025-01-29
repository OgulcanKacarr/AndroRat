import 'package:flutter/cupertino.dart';
import 'AppStrings.dart';
import 'ConstMethods.dart';

class ErrorHandler {

  static String handleError(BuildContext context,Object error) {
    String errorMessage = '';

   if (error is Exception) {
      errorMessage = _handleGeneralError(error);
    } else {
      errorMessage = AppStrings.error;
    }

    ConstMethods.showSnackBar(context,errorMessage);

    return errorMessage;
  }

  static String _handleGeneralError(Exception error) {
    if (error.toString().contains('NetworkError')) {
      return 'Ağ hatası, lütfen bağlantınızı kontrol edin.';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Sunucuya bağlanılamadı. Lütfen tekrar deneyin.';
    } else {
      return AppStrings.error;
    }
  }
}
