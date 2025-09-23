import 'dart:math';

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
      await device.connect(autoConnect: false, mtu: 512); // establish connection
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
    String data = String.fromCharCodes(await characteristic.read());
    return data;
  }

  static Future<bool> setSsid(String ssid) async {
    bool result = true;

    if(ssid.length <= 8) {
      result = result && await writeToCharacteristic(AppState.wifiSsidCharacteristic.value, "[");
      result = result && await writeToCharacteristic(AppState.wifiSsidCharacteristic.value, ssid);
      result = result && await writeToCharacteristic(AppState.wifiSsidCharacteristic.value, "]");
    }
    else {
      result = result && await writeToCharacteristic(AppState.wifiSsidCharacteristic.value, "[");

      for(int i = 0; i < (ssid.length / 8).ceil(); i++) {
        final String ssidPart = ssid.substring(i*8, min((i+1)*8, ssid.length));
        result = result && await writeToCharacteristic(AppState.wifiSsidCharacteristic.value, ssidPart);
      }

      result = result && await writeToCharacteristic(AppState.wifiSsidCharacteristic.value, "]");
    }
    
    return result;
  }

  static Future<bool> setPass(String pass) async {
    bool result = true;
    
    if(pass.length <= 8) {
      result = result && await writeToCharacteristic(AppState.wifiPassCharacteristic.value, "[");
      result = result && await writeToCharacteristic(AppState.wifiPassCharacteristic.value, pass);
      result = result && await writeToCharacteristic(AppState.wifiPassCharacteristic.value, "]");
    }
    else {
      result = result && await writeToCharacteristic(AppState.wifiPassCharacteristic.value, "[");

      for(int i = 0; i < (pass.length / 8).ceil(); i++) {
        final String passPart = pass.substring(i*8, min((i+1)*8, pass.length));
        result = result && await writeToCharacteristic(AppState.wifiPassCharacteristic.value, passPart);
      }

      result = result && await writeToCharacteristic(AppState.wifiPassCharacteristic.value, "]");
    }
    
    return result;
  }

  static Future<bool> sendAct({required String act}) async {
    bool result = true;
    
    if(act.length <= 8) {
      result = result && await writeToCharacteristic(AppState.wifiActCharacteristic.value, "[");
      result = result && await writeToCharacteristic(AppState.wifiActCharacteristic.value, act);
      result = result && await writeToCharacteristic(AppState.wifiActCharacteristic.value, "]");
    }
    else {
      result = result && await writeToCharacteristic(AppState.wifiActCharacteristic.value, "[");

      for(int i = 0; i < (act.length / 8).ceil(); i++) {
        final String actPart = act.substring(i*8, min((i+1)*8, act.length));
        result = result && await writeToCharacteristic(AppState.wifiActCharacteristic.value, actPart);
      }

      result = result && await writeToCharacteristic(AppState.wifiActCharacteristic.value, "]");
    }
    
    return result;
  }

  static Future<String> getLog({Duration? timeout}) async {
    if(timeout == null) {
      return await readFromCharacterstics(AppState.wifiLogCharacteristic.value);
    }

    
    // Wait for confirmation from ESP32
    bool success = false;
    String data = "";
    for (var i = 0; i < (timeout.inSeconds * 2); i++) {
      data = await BLE.getLog();
      if(data.isNotEmpty) {
        success = true;
        break;
      }

      await Future.delayed(Duration(milliseconds: 500)); // Wait for 0.5 seconds
    }

    if(success) {
      return data;
    }

    return "";
  }
}