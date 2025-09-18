import 'dart:typed_data';

import 'package:web_socket_channel/io.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/storage_handler.dart';
import 'package:wms_app/utils/api.dart';
import 'package:wms_app/env/env.dart' as env;


void handleData(dynamic rawData) {
  if(rawData.runtimeType == String) {
    final String message = (rawData as String).trim();

    //? Water leakage data updates
    if(message.startsWith("leak=")) {
      final List<String> data = message.split("leak=").last.split(",");
      final String deviceId = data.first;
      
      // Verify device ID
      if(!AppState.devicesState.value.any((deviceData) => deviceData.id == deviceId)) return;
      
      final int? leakValue = int.tryParse(data.last);

      // Verify leak value
      if(leakValue == null) return;

      // Save it to the app state      
      logger.d("[Web Socket] Changes in water leakage status!");
      AppState.waterLeakageState.value = {
        ...AppState.waterLeakageState.value,
        deviceId: Uint8List.fromList([leakValue])
      };
    }

    //? Average water flow data updates
    else if(message.startsWith("aflow=")) {
      final List<String> data = message.split("aflow=").last.split(",");
      final String deviceId = data.first;
      
      // Verify device ID
      if(!AppState.devicesState.value.any((deviceData) => deviceData.id == deviceId)) return;
      
      final double? averageWaterFlow = double.tryParse(data.last);

      // Verify average water flow
      if(averageWaterFlow == null) return;

      // Save it to the app state
      logger.d("[Web Socket] Changes in water flow value!");
      AppState.averageWaterFlowState.value = {
        ...AppState.averageWaterFlowState.value,
        deviceId: averageWaterFlow
      };
    }

    //? Device status updates
    else if(message.startsWith("status=")) {
      final List<String> data = message.split("status=").last.split(",");
      final String deviceId = data.first;
      
      // Verify device ID
      if(!AppState.devicesState.value.any((deviceData) => deviceData.id == deviceId)) return;
      
      final int? deviceStatus = int.tryParse(data.last);

      // Verify average water flow
      if(deviceStatus == null) return;

      // Save it to the app state
      logger.d("[Web Socket] Changes in device state!");
      AppState.devicesState.value = AppState.devicesState.value.map((device) {
        if(device.id != deviceId) return device;
        return device.copyWith(status: deviceStatus == 1 ? true : false);
      }).toList();
    }

    else {
      logger.d("[Web Socket] Unknown message has arrived: $message");
    }
  }
}


class WebSocketHandler {
  static Future<void> initialize() async {
    if(AppState.webSocketState.value == null) {
      String? cookies = await AppStorage.getString("cookies");
      
      AppState.webSocketState.value = IOWebSocketChannel.connect(
        Uri.parse(env.webSocketUrl),
        headers: {
          "Cookie": cookies
        }
      );

      if(AppState.webSocketState.value != null) {
        AppState.webSocketState.value!.stream.listen((data) {
          handleData(data);
        });
      }
    }
  }

  static Future<void> close() async {
    if(AppState.webSocketState.value != null) {
      await AppState.webSocketState.value!.sink.close();
    }
    
  }
}