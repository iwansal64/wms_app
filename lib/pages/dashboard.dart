import 'package:flutter/material.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/api.dart';
import 'package:wms_app/utils/types.dart';

class DashboardPage extends StatelessWidget{
  const DashboardPage({ super.key });

  void onGotoDeviceListTriggered() {
    AppState.pageState.value = PageStateType.deviceList;
  }

  void onGotoDeviceConfigureTriggered() {
    AppState.pageState.value = PageStateType.deviceScanList;
  }

  void onLogoutTriggered() async {
    await logout();
    AppState.pageState.value = PageStateType.login;
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
            Container(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Dashboard",
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: 28,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                          const Text(
                            "Manage your sensors here!",
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: 14,
                              fontWeight: FontWeight.w400
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 70
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical:5),
                          child: GestureDetector(
                            onTap: onLogoutTriggered,
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
                  padding: EdgeInsets.all(30),
                  child: Column(
                    spacing: 30,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onGotoDeviceListTriggered,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              "List of Devices",
                              style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 24,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        )
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: onGotoDeviceConfigureTriggered,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              "Configure Device",
                              style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 24,
                                fontWeight: FontWeight.w600
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