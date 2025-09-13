import 'package:flutter/material.dart';

class DeviceListPage extends StatelessWidget {
  const DeviceListPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 58, 112)
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                children: [
                  //? Title
                  const Text(
                    "Available Devices",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36
                    ),
                  ),

                  //? Device List
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.red),
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.blue),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 15,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: BoxBorder.all(width: 2),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Device 1",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400
                                        ),
                                      ),
                                      const Text(
                                        "Last seen: now",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: BoxBorder.all(width: 2),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Device 1",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400
                                        ),
                                      ),
                                      const Text(
                                        "Last seen: now",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ),
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
    );
  }
}