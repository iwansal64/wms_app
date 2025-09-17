import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wms_app/utils/model.dart';
import 'package:wms_app/utils/types.dart';

class AppState {
  //? Telling us which page is currently should shows up
  static ValueNotifier<PageStateType> pageState = ValueNotifier(PageStateType.login);
  
  //? Telling us the data of each sensors of each devices
  static ValueNotifier<Map<String, List<double>>> allWaterFlowsState = ValueNotifier({});

  //? Telling us current water leakage status for each devices
  static ValueNotifier<Map<String, Uint8List>> waterLeakageState = ValueNotifier({});

  //? Telling us the average of water flow for all sensors of each device
  static ValueNotifier<Map<String, double>> averageWaterFlowState = ValueNotifier({});

  //? Telling us the current device id, that user choose
  static ValueNotifier<String?> deviceIdState = ValueNotifier(null);
  
  //? Telling us the current device id, that user choose
  static ValueNotifier<List<Device>> devicesState = ValueNotifier([]);

  //? Telling us the current bluetooth characteristic for WiFi SSID
  static ValueNotifier<BluetoothDevice?> configurationDevice = ValueNotifier(null);

  //? Telling us the current bluetooth characteristic for WiFi SSID
  static ValueNotifier<BluetoothCharacteristic?> wifiSsidCharacteristic = ValueNotifier(null);

  //? Telling us the current bluetooth characteristic for WiFi PASS
  static ValueNotifier<BluetoothCharacteristic?> wifiPassCharacteristic = ValueNotifier(null);

  //? Telling us the current bluetooth characteristic for WiFi LOG
  static ValueNotifier<BluetoothCharacteristic?> wifiLogCharacteristic = ValueNotifier(null);
}
