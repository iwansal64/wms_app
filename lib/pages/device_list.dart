import 'package:flutter/material.dart';
import 'package:wms_app/components/device_card.dart';

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
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 30,
                                children: [
                                  //? List of device widget is in here
                                  DeviceCard(deviceName: "Plant 1", createdAt: "29-09-2025"),
                                  DeviceCard(deviceName: "House", createdAt: "22-08-2025"),
                                ],
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
          ),
        ),
      ),
    );
  }
}

