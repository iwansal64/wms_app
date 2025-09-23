import 'package:flutter/material.dart';
import 'package:wms_app/default_styles.dart';
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
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          spacing: 15,
          children: [
            //? Title
            Container(
              alignment: Alignment.center,
              decoration: DefaultStyles.basicBoxContainerContentStyle,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    Text(
                      "Available Devices",
                      style: DefaultStyles.basicTitleStyle,
                    ),
                    Text(
                      "Monitor your devices here!",
                      style: DefaultStyles.basicSubtitleStyle,
                    )
                  ],
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
                decoration: DefaultStyles.basicBoxContainerContentStyle,
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                      "Back",
                      style: DefaultStyles.basicTextStyle.merge(
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                  ),
                ),
              ),
            ),
          ],
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
              logout();
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
        border: Border.all(width: 2, color: Colors.white),
        borderRadius: BorderRadius.circular(15)
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


class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String createdAt;
  final String deviceId;
  final String description;
  final bool status;
  
  const DeviceCard({ super.key, required this.deviceName, required this.createdAt, required this.deviceId, required this.description, required this.status });

  void chooseDevice() async {
    AppState.deviceIdState.value = deviceId;
    AppState.pageState.value = PageStateType.monitor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: chooseDevice,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          alignment: Alignment.topLeft,
          decoration: DefaultStyles.basicBoxContainerContentStyle,
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
                  description.isNotEmpty ? description : "-no description-",
                  style: DefaultStyles.basicTextStyle.merge(
                    TextStyle(
                      fontSize: 16,
                      fontWeight: description.isNotEmpty ? FontWeight.w500 : FontWeight.w300,
                    )
                  ),
                ),
                Spacer(),
                Text(
                  createdAt,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300
                  ),
                ),
                Text(
                  status ? "Active" : "Not Active",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: status ? Color.fromARGB(255, 0, 112, 0) : Colors.black
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