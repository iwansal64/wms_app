import 'package:flutter/material.dart';
import 'package:wms_app/pages/configuration/device_configuration.dart';
import 'package:wms_app/pages/configuration/device_scan.dart';
import 'package:wms_app/pages/dashboard.dart';
import 'package:wms_app/pages/device_list.dart';
import 'package:wms_app/pages/login.dart';
import 'package:wms_app/pages/monitor.dart';
import 'package:wms_app/pages/page_not_found.dart';
import 'package:wms_app/pages/registeration/user_registration.dart';
import 'package:wms_app/pages/registeration/email_registeration.dart';
import 'package:wms_app/pages/registeration/email_verification.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/types.dart';
import 'package:wms_app/utils/websocket_handler.dart';

class WrapperPage extends StatefulWidget {
  const WrapperPage({ super.key });  
  
  @override
  State<StatefulWidget> createState() => _WrapperState();
}

class _WrapperState extends State<WrapperPage> {

  @override
  void dispose() {
    WebSocketHandler.close().whenComplete(() {
      super.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: AppState.pageState, 
        builder: (context, data, _) {
          switch(data) {
            case PageStateType.login:
              return LoginPage();
            case PageStateType.emailRegistration:
              return EmailRegistrationPage();
            case PageStateType.emailVerification:
              return EmailVerificationPage();
            case PageStateType.createUser:
              return UserRegistrationPage();
            case PageStateType.deviceList:
              return DeviceListPage();
            case PageStateType.monitor:
              return MonitorPage();
            case PageStateType.deviceConfiguration:
              return DeviceConfigurationPage();
            case PageStateType.deviceScanList:
              return DeviceScanPage();
            case PageStateType.dashboard:
              return DashboardPage();
            // ignore: unreachable_switch_default
            default:
              return NotFoundPage();
          }
        }
      )
    );
  }
}
