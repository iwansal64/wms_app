import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/types.dart';

class MonitorPage extends StatelessWidget {
  const MonitorPage({ super.key });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 58, 112)
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 5,
          children: [
            // Basic Statistics Info
            WaterLeakageData(),
            WaterFlowData(),
            // Sensor List Page Button
            SensorButton(),
            Spacer(),
            BackToDashboard(),
          ],
        ),
      ),
    );
  }
}


//? SENSOR PAGE BUTTON
class SensorButton extends StatelessWidget {
  const SensorButton({ super.key });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Go to sensor list page
        AppState.pageState.value = PageStateType.deviceScanList;
      },
      child: SizedBox(
        height: 200,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromARGB(100, 255, 255, 255),
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(15)
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4,
                  children: [
                    const Text(
                      "Sensor",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Icon(
                      Icons.north_east,
                      size: 20,
                      color: Colors.black,
                    )
                  ],
                ),
                const Text(
                  "Monitor sensor values here!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//? STATISTICS SECTION
class WaterLeakageData extends StatefulWidget {
  const WaterLeakageData({ super.key });

  @override
  State<StatefulWidget> createState() => _WaterLeakageDataState();
}

class _WaterLeakageDataState extends State<WaterLeakageData> {
  int waterLeaked = 0;

  void updateWaterLeaked() {
    // Get required data
    String? deviceId = AppState.deviceIdState.value;
    Map<String, Uint8List> waterLeakageState = AppState.waterLeakageState.value;
    
    // If the data is not valid
    if(deviceId == null || waterLeakageState[deviceId] == null) return;
    
    setState(() {
      waterLeaked = waterLeakageState[deviceId]!.first;
    });
  }

  @override
  void initState() {
    super.initState();
    
    updateWaterLeaked();
    AppState.waterLeakageState.addListener(updateWaterLeaked);
  }

  @override
  void dispose() {
    AppState.waterLeakageState.removeListener(updateWaterLeaked);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container( 
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color.fromARGB(100, 255, 255, 255),
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              "Water Leakage Status",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5,
              children: [
                Text(
                  waterLeaked != 0 ? "Leak in Sensor: $waterLeaked!" : "Stable",
                  style: TextStyle(
                    fontSize: 24,
                    color: waterLeaked != 0 ? const Color.fromARGB(255, 126, 0, 0) : const Color.fromARGB(255, 0, 50, 136),
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Icon(
                  waterLeaked != 0 ? Icons.warning : Icons.circle_outlined,
                  color: waterLeaked != 0 ? const Color.fromARGB(255, 126, 0, 0) : const Color.fromARGB(255, 0, 50, 136),
                  size: 16,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WaterFlowData extends StatefulWidget {
  const WaterFlowData({ super.key });

  @override
  State<StatefulWidget> createState() => _WaterFlowDataState();
}

class _WaterFlowDataState extends State<WaterFlowData> {
  double waterFlow = 0;

  void updateWaterFlow() {
    // Get required data
    String? deviceId = AppState.deviceIdState.value;
    Map<String, double> averageWaterFlowState = AppState.averageWaterFlowState.value;
    
    // If the data is not valid
    if(deviceId == null || averageWaterFlowState[deviceId] == null) return;
    
    setState(() {
      waterFlow = averageWaterFlowState[deviceId]!;
    });
  }

  @override void initState() {
    super.initState();

    updateWaterFlow();
    AppState.averageWaterFlowState.addListener(updateWaterFlow);
  }
  
  @override
  void dispose() {
    AppState.averageWaterFlowState.removeListener(updateWaterFlow);
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color.fromARGB(100, 255, 255, 255),
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              "Average Water Flow",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5,
              children: [
                Text(
                  "$waterFlow",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const Text(
                  "liter/s",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w400
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BackToDashboard extends StatelessWidget {
  const BackToDashboard({ super.key });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppState.pageState.value = PageStateType.deviceList;
      },
      child: Container( 
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.fromARGB(100, 255, 255, 255),
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Center(
            child: const Text(
              "Back",
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w500
              ),
            )
          ),
        ),
      ),
    );
  }
}