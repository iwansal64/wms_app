import 'dart:typed_data';

import 'package:web_socket_channel/io.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/storage_handler.dart';

final String webSocketUrl = "ws://192.168.1.9:8040";


void handleData(dynamic rawData) {
  if(rawData.runtimeType == String) {
    final String message = (rawData as String).trim();
    if(message.startsWith("leak=")) {
      final int? leakValue = int.tryParse(message.split("leak=").last);
      if(leakValue != null) {
        AppState.waterLeakageState.value = Uint8List.fromList([leakValue]);
      }
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