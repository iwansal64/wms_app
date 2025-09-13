import 'package:flutter/material.dart';
import 'package:wms_app/components/device_card.dart';
import 'package:wms_app/utils/api.dart';
import 'package:wms_app/utils/model.dart';
import 'package:wms_app/utils/util.dart';

class DeviceListPage extends StatelessWidget {
  const DeviceListPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 58, 112)
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 500
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                  child: Column(
                    children: [
                      //? Title
                      const Text(
                        "Available Devices",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w700
                        ),
                      ),

                      //? Device List
                      Expanded(
                        child: DeviceList()
                      ),
                    ],
                  ),
                ),
              ),
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
  bool isDevicesFetched = false; //? Used to check if currently waiting for device data or not

  @override
  void initState() {
    super.initState();

    logger.d("Sending device data..");
    getDevices().then((result) {
      switch (result) {
        case DevicesData(:var devices):
          setState(() {
            deviceList = devices;
          });
        case NoDeviceData(:var responseCode):
          logger.e("There's an error. Error: $responseCode");
      }
      
      setState(() {
        isDevicesFetched = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 30,
            children: (
              isDevicesFetched ? 
              deviceList
              .where((deviceData) => deviceData.isValid)
              .map((deviceData) => DeviceCard(
                deviceName: deviceData.deviceName, 
                createdAt: formatLongDate(deviceData.createdAt), 
                deviceId: deviceData.id,
                description: deviceData.description,
              ))
              .toList()
              :
              List.filled(3, DeviceCardDummy())
            ),
          ),
        ),
      ),
    );
  }
}

