import 'package:flutter/material.dart';
import 'package:wms_app/default_styles.dart' as default_styles;

class SensorCard extends StatelessWidget {
  final String sensorNumber;
  final String sensorId;
  
  const SensorCard({ super.key, required this.sensorNumber, required this.sensorId });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 180
        ),
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(15)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Water Flow Sensor #$sensorNumber",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SensorValue(sensorId: sensorId)
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class SensorValue extends StatefulWidget {
  final String sensorId;
  
  const SensorValue({ super.key, required this.sensorId });

  @override
  State<StatefulWidget> createState() => _SensorValueState();
}


class _SensorValueState extends State<SensorValue> {
  @override
  Widget build(BuildContext context) {
    
    return Text(
      "--",
      style: default_styles.sensorValueStyle,
    );
  }
}
