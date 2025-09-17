import 'package:flutter/material.dart';
import 'package:wms_app/components/device_card.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/api.dart';
import 'package:wms_app/utils/model.dart';
import 'package:wms_app/utils/types.dart';
import 'package:wms_app/utils/util.dart';

class DeviceListPage extends StatelessWidget {
  const DeviceListPage({ super.key });

  void onBackTrigger() {
    AppState.pageState.value = PageStateType.dashboard;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 58, 112)
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              spacing: 15,
              children: [
                //? Title
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: const Text(
                      "Available Devices",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ),
                ),
                //? Device List
                Expanded(
                  child: DeviceList(),
                ),
                //? Back to Homepage
                GestureDetector(
                  onTap: onBackTrigger,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: const Text(
                          "Back",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                      ),
                    ),
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

class DeviceList extends StatefulWidget {
  const DeviceList({ super.key });

  @override
  State<StatefulWidget> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  List<Device> deviceList = []; //? Used to store devices data

  void updateDeviceList() {
    setState(() {
      deviceList = AppState.devicesState.value;
    });
  }

  @override
  void initState() {
    super.initState();

    updateDeviceList();
    AppState.devicesState.addListener(updateDeviceList);
    
    getDevices().then((result) {
      switch(result) {
        case NoDeviceData(:var responseCode): {
          switch(responseCode) {
            case APIResponseCode.unauthorized:
              AppState.pageState.value = PageStateType.login;
            default:
              break;
          }
        }
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    AppState.devicesState.removeListener(updateDeviceList);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(100, 255, 255, 255),
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 30,
            children: deviceList
              .where((deviceData) => deviceData.isValid)
              .map((deviceData) => DeviceCard(
                deviceName: deviceData.deviceName, 
                createdAt: formatLongDate(deviceData.createdAt), 
                deviceId: deviceData.id,
                description: deviceData.description,
                status: deviceData.status,
              ))
              .toList(),
          ),
        ),
      ),
    );
  }
}

