import 'package:flutter/material.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/types.dart';

class DashboardPage extends StatelessWidget{
  const DashboardPage({ super.key });

  void onGotoDeviceListTrigger() {
    AppState.pageState.value = PageStateType.deviceList;
  }

  void onGotoDeviceConfigureTrigger() {
    AppState.pageState.value = PageStateType.deviceScanList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 58, 112)
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          spacing: 5,
          children: [
            SizedBox(
              width: double.infinity,
              height: 100,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(100, 255, 255, 255),
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 20,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Dashboard",
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 28,
                              fontWeight: FontWeight.w800
                            ),
                          ),
                          const Text(
                            "Manage your sensors here!",
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 14,
                              fontWeight: FontWeight.w800
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: Icon(Icons.logout),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(100, 255, 255, 255),
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    spacing: 15,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onGotoDeviceListTrigger,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              "List of Devices",
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: 28,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                          ),
                        )
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: onGotoDeviceConfigureTrigger,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              "Configure Device",
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: 28,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                          ),
                        )
                      ),
                    ],
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}