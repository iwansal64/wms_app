import 'package:flutter/material.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/storage_handler.dart';
import 'package:wms_app/utils/types.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String createdAt;
  final String deviceId;
  final String description;
  
  const DeviceCard({ super.key, required this.deviceName, required this.createdAt, required this.deviceId, required this.description });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await AppStorage.saveString("device_id", deviceId);
        AppState.pageState.value = PageStateType.monitor;
      },
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            border: BoxBorder.all(width: 2),
            borderRadius: BorderRadius.circular(15)
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Spacer(),
                Text(
                  createdAt,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeviceCardDummy extends StatelessWidget {
  const DeviceCardDummy({ super.key });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            border: BoxBorder.all(width: 2),
            borderRadius: BorderRadius.circular(15)
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: const Text(
                "Loading Data...",
                style: TextStyle(
                  fontSize: 24
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}