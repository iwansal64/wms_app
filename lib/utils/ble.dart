import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/api.dart';


// flutterBlue.startScan(timeout: Duration(seconds: 4));

// var subscription = flutterBlue.scanResults.listen((results) {
//   for (ScanResult r in results) {
//     print('${r.device.name} found! rssi: ${r.rssi}');
//   }
// });

// flutterBlue.stopScan();

class BLE {
  static Future<List<ScanResult>> startScan() async {
    //? Starting BLE scan
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

    //? Prepare the variable to contain result
    List<ScanResult> result = [];

    //? Listen to updated device discoveries
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult scanData in results) {
        logger.i('${scanData.device.platformName} found! rssi: ${scanData.rssi}');
        result.add(scanData);
      }
    });

    //? Wait for 5 seconds to gather results
    await Future.delayed(Duration(seconds: 5));

    //? Return the result
    return result;
  }

  static Future<void> stopScan() async {
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