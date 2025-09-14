import 'dart:typed_data';

import 'package:web_socket_channel/io.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/storage_handler.dart';
import 'package:wms_app/utils/api.dart';

final String webSocketUrl = "ws://192.168.1.9:8040";


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
      logger.d("Changes in water leakage status!");
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
      AppState.averageWaterFlowState.value = {
        ...AppState.averageWaterFlowState.value,
        deviceId: averageWaterFlow
      };
    }
  }
}


class WebSocketHandler {
  static IOWebSocketChannel? wsChannel;
  
  static Future<void> initialize() async {
    String? cookies = await AppStorage.getString("cookies");
    
    WebSocketHandler.wsChannel = IOWebSocketChannel.connect(
      Uri.parse(webSocketUrl),
      headers: {
        "Cookie": cookies
      }
    );

    if(WebSocketHandler.wsChannel != null) {
      WebSocketHandler.wsChannel!.stream.listen((data) {
        handleData(data);
      });
    }
  }

  static Future<void> close() async {
    if(WebSocketHandler.wsChannel != null) {
      await WebSocketHandler.wsChannel!.sink.close();
    }
  }
}