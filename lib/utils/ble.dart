import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/api.dart';


class BLE {
  static Map<String, ScanResult> scanResults = {};
  
  static void startScan({void Function()? onUpdate}) {
    //? Starting BLE scan
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

    //? Listen to updated device discoveries
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult scanData in results) {
        logger.i('${scanData.device.platformName} found! rssi: ${scanData.rssi}');
        scanResults[scanData.device.remoteId.str] = scanData;

        if(onUpdate != null) onUpdate();
      }
    });
  }

  static Future<void> stopScan() async {
    //? Stoping BLE scan
    await FlutterBluePlus.stopScan();
  }

  static Future<bool> connect(BluetoothDevice device) async {
    try {
      logger.i("[Bluetooth] Connecting to ${device.platformName}...");
      await device.connect(autoConnect: false); // establish connection
      logger.i("[Bluetooth] Connected to ${device.platformName}");
      return true;
    } catch (e) {
      logger.e("[Bluetooth] Error connecting to ${device.platformName}: $e");
      return false;
    }
  }

  static Future<List<BluetoothCharacteristic>> gatherCharacteristics(BluetoothDevice device) async {
    List<BluetoothCharacteristic> characteristics = [];

    List<BluetoothService> services = await device.discoverServices();
    for(var service in services) {
      for(var characteristic in service.characteristics) {
        characteristics.add(characteristic);
      }
    }

    return characteristics;
  }

  static Future<bool> writeToCharacteristic(BluetoothCharacteristic? characteristic, String data) async {
    if(characteristic == null) return false;

    try {
      await characteristic.write(data.codeUnits);
      return true;
    }
    catch(err) {
      logger.d("[Bluetooth] Error when sending data: ${err.toString()}");
      return false;
    }
  }

  static Future<String> readFromCharacterstics(BluetoothCharacteristic? characteristic) async {
    if(characteristic == null) return "";
    String data = (await characteristic.read()).toString();
    return data;
  }

  static Future<bool> setSsid(String ssid) async {
    return await writeToCharacteristic(AppState.wifiSsidCharacteristic.value, ssid);
  }

  static Future<bool> setPass(String pass) async {
    return await writeToCharacteristic(AppState.wifiPassCharacteristic.value, pass);
  }

  static Future<String> getLog() async {
    return await readFromCharacterstics(AppState.wifiLogCharacteristic.value);
  }
}