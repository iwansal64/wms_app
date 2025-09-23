import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wms_app/default_styles.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/ble.dart';
import 'package:wms_app/utils/toast.dart';
import 'package:wms_app/utils/types.dart';
import 'package:wms_app/env/env.dart' as env;

class DeviceScanPage extends StatelessWidget {
  const DeviceScanPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 15,
        children: [
          Container(
            decoration: DefaultStyles.basicBoxContainerContentStyle,
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  Text(
                    "Select Device",
                    style: DefaultStyles.basicTitleStyle,
                  ),
                  Text(
                    "Which one is the device you want to configure?",
                    style: DefaultStyles.basicSubtitleStyle,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: DeviceScanContainer(),
          )
        ],
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

  void startScan() {
    if(scanState) return;

    // Set scan state to true
    setState(() {
      scanState = true;
    });

    // Start BLE device scanning
    BLE.startScan();

    // Update device cards
    updateDeviceCardsIntervally();
  }

  void stopScan() {
    if(!scanState) return;

    // Set scan state to false
    setState(() {
      scanState = false;
    });

    // Stop BLE device scanning
    BLE.stopScan();

    // Update lastly
    updateDeviceCards();
  }

  void updateDeviceCards() async {
    setState(() {
      deviceCards = BLE.scanResults.values
                    .where((item) => item.device.platformName.isNotEmpty)
                    .map((item) => DiscoveredDeviceCard(
                      device: item.device, 
                      rssi: item.rssi,
                      onSelect: () {
                        stopScan();
                      },
                    ))
                    .toList();
    });
  }

  void updateDeviceCardsIntervally() async {
    // If currently not scanning
    if(!scanState) return;

    // Delay 2 seconds before update the device cards
    await Future.delayed(Duration(seconds: 2));
    
    // Update the device cards
    updateDeviceCards();

    // Recursively call this function to update until stop scanning
    updateDeviceCardsIntervally();
  }

  void onToggleScanTrigger() {
    // If currently not scanning
    if(!scanState) {
      // Start scanning
      startScan();
    }

    // If currently scanning
    else {
      // Stop scanning
      stopScan();
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
                    Text(
                      "Scanning..",
                      style: DefaultStyles.basicTextStyle.merge(
                        TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                        )
                      ),
                    )
                    :
                  // If currently not scanning
                    Column(
                      children: [
                        Text(
                          "There's no devices",
                          style: DefaultStyles.basicTextStyle.merge(
                            TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400
                            )
                          ),
                        ),
                        Text(
                          "Please scan to discover devices",
                          style: DefaultStyles.basicTextStyle.merge(
                            TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400
                            )
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
              decoration: DefaultStyles.basicBoxContainerContentStyle,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      scanState ? "Stop Scan" : "Start Scan",
                      style: DefaultStyles.basicTextStyle.merge(
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                        )
                      ),
                    ),
                    Text(
                      scanState ? "" : "Search for ESP32 device to configure",
                      style: DefaultStyles.basicTextStyle.merge(
                        TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                        )
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
                decoration: DefaultStyles.basicBoxContainerContentStyle,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    children: [
                      Text(
                        "Back",
                        style: DefaultStyles.basicTextStyle.merge(
                          TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700
                          )
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
      List<bool> characteristicsCheck = List.filled(4, false);
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

          // Set WiFi LOG Characteristics
          case env.wifiActCharacteristicUuid:
            AppState.wifiActCharacteristic.value = characteristic;
            characteristicsCheck[3] = true;
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

        Toast.showError(message: "Can't connect to a device that is not an ILDUP device");
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