import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/api.dart';
import 'package:wms_app/utils/ble.dart';
import 'package:wms_app/utils/types.dart';
import 'package:wms_app/env/env.dart' as env;

class DeviceScanPage extends StatelessWidget {
  const DeviceScanPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 58, 112)
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: DeviceScanContainer(),
      ),
    );
  }
}

class DeviceScanContainer extends StatefulWidget {
  const DeviceScanContainer({ super.key });

  @override
  State<StatefulWidget> createState() => _DeviceScanContainerState();
}

class _DeviceScanContainerState extends State<DeviceScanContainer> {
  bool scanState = false;

  List<DiscoveredDeviceCard> deviceCards = [];

  void onBackTrigger() {
    if(scanState) return;
    AppState.pageState.value = PageStateType.dashboard;
  }

  void onScanTrigger() async {
    // If currently not scanning
    if(!scanState) {
      setState(() {
        scanState = true;
      });
      
      List<ScanResult> result = await BLE.startScan();
      deviceCards = result.map((item) => DiscoveredDeviceCard(device: item.device, rssi: item.rssi)).toList();

      setState(() {
        scanState = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        spacing: 15,
        children: [
          Expanded(
            child: Container(
              alignment: (deviceCards.isNotEmpty && !scanState) ? Alignment.topCenter : Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(100, 255, 255, 255),
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(15)
              ),
              child: SingleChildScrollView(
                child: (
                  scanState ? 
                  const Text(
                    "Scanning...",
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontSize: 16,
                      fontWeight: FontWeight.w800
                    ),
                  ) : (
                    deviceCards.isNotEmpty ? 
                    // If there's a device
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        spacing: 15,
                        children: deviceCards
                      ),
                    ) : (
                    // If there's no devices
                      const Text(
                        "There's no devices",
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontSize: 16,
                          fontWeight: FontWeight.w800
                        ),
                      )
                    )
                  )
                ),
              ),
            )
          ),
          GestureDetector(
            onTap: () {
              onScanTrigger();
            },
            child: Opacity(
              opacity: scanState ? 0.2 : 1,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.fromARGB(100, 255, 255, 255),
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: const Text(
                    "Scan",
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontSize: 28,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onBackTrigger();
            },
            child: Opacity(
              opacity: scanState ? 0.2 : 1,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.fromARGB(100, 255, 255, 255),
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: const Text(
                    "Back",
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontSize: 28,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoveredDeviceCard extends StatelessWidget {
  final BluetoothDevice device;
  final int rssi;
  
  void onConnectTrigger() async {
    bool result = await BLE.connect(device);
    if(result) {
      List<BluetoothCharacteristic> characteristics = await BLE.gatherCharacteristics(device);
      
      // Update all of the characteristics in app state
      for(BluetoothCharacteristic characteristic in characteristics) {
        switch (characteristic.characteristicUuid.toString()) {
          // Set WiFi SSID Characteristics
          case env.wifiSsidCharacteristicUuid:
            AppState.wifiSsidCharacteristic.value = characteristic;
            break;

          // Set WiFi PASS Characteristics
          case env.wifiPassCharacteristicUuid:
            AppState.wifiPassCharacteristic.value = characteristic;
            break;

          // Set WiFi LOG Characteristics
          case env.wifiLogCharacteristicUuid:
            AppState.wifiLogCharacteristic.value = characteristic;
            break;

          default:
            break;
        }

        AppState.configurationDevice.value = device;
      }
      
      // Go to device configuration page
      AppState.pageState.value = PageStateType.deviceConfiguration;
    }
    else {
      // After global message implementation
    }
  }
  
  const DiscoveredDeviceCard({ super.key, required this.device, required this.rssi });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onConnectTrigger,
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device.platformName.isEmpty ? "No Device Name" : device.platformName,
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
              ),
              Text(
                device.advName,
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 16,
                  fontWeight: FontWeight.w200
                ),
              ),
              Text(
                "${rssi.toString()} dB",
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 16,
                  fontWeight: FontWeight.w200
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}