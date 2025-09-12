import 'package:flutter/foundation.dart';
import 'package:wms_app/utils/types.dart';

class AppState {
  static ValueNotifier<PageStateType> pageState = ValueNotifier(PageStateType.login);
}
