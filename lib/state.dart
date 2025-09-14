import 'package:flutter/foundation.dart';
import 'package:wms_app/utils/model.dart';
import 'package:wms_app/utils/types.dart';

class AppState {
  static ValueNotifier<PageStateType> pageState = ValueNotifier(PageStateType.login);
  static Map<String, ValueNotifier<Sensor>> sensorsState = {};
  static ValueNotifier<Uint8List> waterLeakageState = ValueNotifier(Uint8List(1));
  static ValueNotifier<double> averageWaterFlow = ValueNotifier(0);
}
