import 'package:flutter/material.dart';
import 'package:wms_app/default_styles.dart';
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
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 5,
        children: [
          Container(
            alignment: Alignment.center,
            child: Container(
              decoration: DefaultStyles.basicBoxContainerStyle,
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
                        Text(
                          "Dashboard",
                          style: DefaultStyles.basicTextStyle.merge(
                            DefaultStyles.basicTitleStyle
                          ),
                        ),
                        Text(
                          "Manage your sensors here!",
                          style: DefaultStyles.basicTextStyle.merge(
                            DefaultStyles.basicSubtitleStyle
                          )
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
                                border: DefaultStyles.basicBoxContainerStyle.border,
                                borderRadius: DefaultStyles.basicBoxContainerStyle.borderRadius
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
              decoration: DefaultStyles.basicBoxContainerStyle,
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
                          decoration: DefaultStyles.basicBoxContainerSecondStyle,
                          child: Text(
                            "List of Devices",
                            style: DefaultStyles.basicTextStyle.merge(
                              TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600
                              )
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
                          decoration: DefaultStyles.basicBoxContainerSecondStyle,
                          child: Text(
                            "Configure Device",
                            style: DefaultStyles.basicTextStyle.merge(
                              TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600
                              )
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
    );
  }
}