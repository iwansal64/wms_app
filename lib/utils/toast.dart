import 'package:wms_app/state.dart';
import 'package:wms_app/utils/api.dart';

class Toast {
  static void show({required String message, required ToastStatus status, Duration? duration}) async {
    AppState.toastState.value = ToastMessage.from(message, status);
    
    await Future.delayed(duration ?? Duration(seconds: 4));

    AppState.toastState.value = null;
  }
  
  static void showInfo({required String message, Duration? duration}) {
    show(
      message: message,
      status: ToastStatus.info,
      duration: duration
    );
  }

  static void showError({required String message, Duration? duration}) {
    show(
      message: message,
      status: ToastStatus.error,
      duration: duration
    );
  }

  static void showDebug({required String message, Duration? duration}) {
    show(
      message: message,
      status: ToastStatus.debug,
      duration: duration
    );
  }

  static void showSuccess({required String message, Duration? duration}) {
    show(
      message: message,
      status: ToastStatus.success,
      duration: duration
    );
  }

  static void showDefaultError(APIResponseCode responseCode) {
    switch(responseCode) {
      case APIResponseCode.ok:
        Toast.showSuccess(message: "Success!");
      case APIResponseCode.unauthorized:
        Toast.showError(message: "Unauthorized!");
      case APIResponseCode.rateLimited:
        Toast.showError(message: "Rate Limited!");
      case APIResponseCode.serverError:
        Toast.showError(message: "Sorry but, There's an error in the server :((");
      case APIResponseCode.conflict:
        Toast.showError(message: "Duplicate!");
      case APIResponseCode.timeout:
        Toast.showError(message: "Can't reach server :/");
      case APIResponseCode.socketError:
        Toast.showError(message: "Server doesn't want to response.");
      case APIResponseCode.error:
        Toast.showError(message: "Unexpected error has occured!");
    }
  }
}