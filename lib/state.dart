import 'package:flutter/foundation.dart';
import 'package:wms_app/utils/model.dart';
import 'package:wms_app/utils/types.dart';

class AppState {
  static ValueNotifier<PageStateType> pageState = ValueNotifier(PageStateType.login);
  static Map<String, ValueNotifier<Sensor>> sensorsState = {};
  static ValueNotifier<bool> waterLeakageState = ValueNotifier(false);
  static ValueNotifier<double> averageWaterFlow = ValueNotifier(0);
}
