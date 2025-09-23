import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wms_app/default_styles.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/api.dart';
import 'package:wms_app/utils/ble.dart';
import 'package:wms_app/utils/types.dart';


class DeviceConfigurationPage extends StatelessWidget {
  const DeviceConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: 700
        ),
        child: FractionallySizedBox(
          heightFactor: 0.8,
          widthFactor: 0.8,
          child: Container(
            decoration: DefaultStyles.basicBoxContainerContentStyle,
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                spacing: 15,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        const Text(
                          "Configuration",
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                        ),
                        const Text(
                          "Configure your device",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ConfigurationForm()
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}

class ConfigurationForm extends StatefulWidget  {
  const ConfigurationForm({super.key});

  @override
  State<StatefulWidget> createState() => _ConfigurationFormState();
}

class _ConfigurationFormState extends State<ConfigurationForm> {
  String wifiSSID = "";
  String wifiPASS = "";

  String errorMessage = "";
  bool isError = false;
  
  bool busyState = false;

  void showErrorMessage(String message) {
    setState(() {
      isError = true;
      errorMessage = message;
    });
  }

  void showInfoMessage(String message) {
    setState(() {
      isError = false;
      errorMessage = message;
    });
  }
  
  
  void onSaveTrigger() async {
    logger.i("SAVING...");
    
    setState(() {
      busyState = true;
    });
    
    if(wifiSSID.isNotEmpty) {
      await BLE.setSsid(wifiSSID);
    }

    if(wifiPASS.isNotEmpty) {
      await BLE.setPass(wifiPASS);
    }

    // Wait for confirmation from ESP32
    String result = await BLE.getLog(timeout: Duration(seconds: 10));
    
    if(result.isNotEmpty) {
      setState(() {
        wifiSSID = "";
        wifiPASS = "";
      });
      
      showInfoMessage("Wifi credentials saved!");
    }
    else {
      showErrorMessage("There's error when saving..");
    }

    setState(() {
      busyState = false;
    });
  }

  void onCheckTrigger() async {
    logger.i("CHECKING...");
    
    setState(() {
      busyState = true;
    });
    
    showInfoMessage("Checking internet...");
    
    await BLE.sendAct(act: "wifi-check");
    String logValue = await BLE.getLog(timeout: Duration(seconds: 10)); // Wait 10 seconds to search for WiFi connection

    logger.i("Log Value: $logValue");

    if(logValue == "connected") {
      showInfoMessage("Internet connected!");
      
      await Future.delayed(Duration(seconds: 4));

      showInfoMessage("");
    }
    else {
      showErrorMessage("The WiFi is not connected");
    }

    setState(() {
      busyState = false;
    });
  }

  void onBackTrigger() async {
    if(AppState.configurationDevice.value != null) {
      if(await AppState.configurationDevice.value?.bondState.first == BluetoothBondState.bonded) {
        await AppState.configurationDevice.value?.disconnect();
      }
      
      AppState.configurationDevice.value = null;
      AppState.wifiLogCharacteristic.value = null;
      AppState.wifiPassCharacteristic.value = null;
      AppState.wifiSsidCharacteristic.value = null;
      AppState.configurationDevice.value = null;
    }
    AppState.pageState.value = PageStateType.dashboard;
  }

  @override
  void dispose() {
    if(AppState.configurationDevice.value != null) {
      AppState.configurationDevice.value?.disconnect().whenComplete(() {
        super.dispose();
      });
    }
    else {
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        //? Text Field for WiFi SSID
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 5),
              child: const Text(
                "WiFi SSID",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Your WiFi name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 0, 58, 112), width: 1.5),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  wifiSSID = value;
                  errorMessage = "";
                });
              },
            )
          ],
        ),
        //? Text Field for WiFi Password
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 5),
              child: const Text(
                "WiFi Password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password for your WiFi",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 0, 58, 112), width: 1.5),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  wifiPASS = value;
                  errorMessage = "";
                });
              },
            )
          ],
        ),
        Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isError ? Colors.red : Colors.blue
          )
        ),
        Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 15,
          children: [
            Row(
              spacing: 5,
              children: [
                //? Save Button
                Expanded(
                  child: Opacity(
                    opacity: busyState ? 0.2 : 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.black,
                        disabledForegroundColor: Colors.white,
                      ),
                      onPressed: busyState ? null : onSaveTrigger,
                      child: const Text("Save")
                    ),
                  ) 
                ),
                //? Check Connection Button
                Expanded(
                  child: Opacity(
                    opacity: busyState ? 0.2 : 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.black,
                        disabledForegroundColor: Colors.white,
                      ),
                      onPressed: busyState ? null : onCheckTrigger,
                      child: const Text("Check")
                    ),
                  ),
                ),
              ],
            ),
            //? Back Button
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              ),
              onPressed: onBackTrigger,
              child: const Text("Back")
            ),
          ],
        )
      ],
    );
  }
  
}