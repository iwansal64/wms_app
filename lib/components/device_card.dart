import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String createdAt;
  
  const DeviceCard({ super.key, required this.deviceName, required this.createdAt });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: BoxBorder.all(width: 2),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                deviceName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400
                ),
              ),
              Text(
                "Created at: $createdAt",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w200
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}