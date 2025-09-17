import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wms_app/state.dart';
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
        child: Column(
          spacing: 15,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(15)
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: const Text(
                  "Select Device",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none
                  ),
                ),
              ),
            ),
            Expanded(
              child: DeviceScanContainer(),
            )
          ],
        ),
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

  void updateDeviceCards() async {
    // If currently not scanning
    if(!scanState) return;

    // Delay 2 seconds before update the device cards
    await Future.delayed(Duration(seconds: 2));
    
    // Update the device cards
    setState(() {
      deviceCards = BLE.scanResults.values.map((item) => DiscoveredDeviceCard(device: item.device, rssi: item.rssi)).toList();
    });

    // Recursively call this function to update until stop scanning
    updateDeviceCards();
  }

  void onToggleScanTrigger() async {
    // If currently not scanning
    if(!scanState) {
      // Set scan state to true
      setState(() {
        scanState = true;
      });
      
      // Start BLE device scanning
      BLE.startScan();

      // Update device cards
      updateDeviceCards();
    }

    // If currently scanning
    else {
      // Set scan state to false
      setState(() {
        scanState = false;
      });
      
      // Stop BLE device scanning
      BLE.stopScan();

      // Update the device cards one more time
      setState(() {
        deviceCards = BLE.scanResults.values.map(
          (item) => DiscoveredDeviceCard(
            device: item.device,
            rssi: item.rssi
          )
        ).toList();
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
              alignment: (deviceCards.isNotEmpty) ? Alignment.topCenter : Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(100, 255, 255, 255),
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(15)
              ),
              child: SingleChildScrollView(
                child: (
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
                  // If current scanning
                  scanState ?
                    const Text(
                      "Scanning..",
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        fontWeight: FontWeight.w700
                      ),
                    )
                    :
                  // If currently not scanning
                    Column(
                      children: [
                        const Text(
                          "There's no devices",
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                        const Text(
                          "Please scan for devices to dicover",
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 12,
                            fontWeight: FontWeight.w400
                          ),
                        )
                      ],
                    )
                  )
                ),
              ),
            )
          ),
          GestureDetector(
            onTap: onToggleScanTrigger,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      scanState ? "Stop Scan" : "Start Scan",
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                      scanState ? "" : "Search for ESP32 device to configure",
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
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
                  color: Colors.white,
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    children: [
                      const Text(
                        "Back",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                        ),
                      )
                    ],
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

class DiscoveredDeviceCard extends StatefulWidget {
  final BluetoothDevice device;
  final int rssi;
  final void Function()? onSelect;

  const DiscoveredDeviceCard({ super.key, required this.device, required this.rssi, this.onSelect });

  @override
  State<StatefulWidget> createState() => _DiscoveredDeviceCardState();
}

class _DiscoveredDeviceCardState extends State<DiscoveredDeviceCard> {
  bool isConnectingProcess = false;
  
  void onConnectTrigger() async {
    (widget.onSelect != null) ? widget.onSelect!() : null;
    
    setState(() {
      isConnectingProcess = true;
    });

    bool result = await BLE.connect(widget.device);
    if(result) {
      List<BluetoothCharacteristic> characteristics = await BLE.gatherCharacteristics(widget.device);
      
      // Update all of the characteristics in app state
      List<bool> characteristicsCheck = [false, false, false];
      for(BluetoothCharacteristic characteristic in characteristics) {
        switch (characteristic.characteristicUuid.toString()) {
          // Set WiFi SSID Characteristics
          case env.wifiSsidCharacteristicUuid:
            AppState.wifiSsidCharacteristic.value = characteristic;
            characteristicsCheck[0] = true;
            break;

          // Set WiFi PASS Characteristics
          case env.wifiPassCharacteristicUuid:
            AppState.wifiPassCharacteristic.value = characteristic;
            characteristicsCheck[1] = true;
            break;

          // Set WiFi LOG Characteristics
          case env.wifiLogCharacteristicUuid:
            AppState.wifiLogCharacteristic.value = characteristic;
            characteristicsCheck[2] = true;
            break;

          default:
            break;
        }
      }
      if(characteristicsCheck.every((data) => data)) {
        // Update the current device configuration data
        AppState.configurationDevice.value = widget.device;
        
        // Go to device configuration page
        AppState.pageState.value = PageStateType.deviceConfiguration;
      }
      else {
        widget.device.disconnect();
      }
    
    }
    
    setState(() {
      isConnectingProcess = false;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onConnectTrigger,
      child: Opacity(
        opacity: isConnectingProcess ? 0.2 : 1,
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(15)
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.device.platformName.isEmpty ? "No Device Name" : widget.device.platformName,
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  widget.device.advName,
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    fontWeight: FontWeight.w200
                  ),
                ),
                Text(
                  "${widget.rssi.toString()} dB",
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
      ),
    );
  }
}