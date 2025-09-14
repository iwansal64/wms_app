import 'package:flutter/material.dart';
import 'package:wms_app/pages/device_list.dart';
import 'package:wms_app/pages/login.dart';
import 'package:wms_app/pages/monitor.dart';
import 'package:wms_app/pages/page_not_found.dart';
import 'package:wms_app/pages/registeration/create_user.dart';
import 'package:wms_app/pages/registeration/email_registeration.dart';
import 'package:wms_app/pages/registeration/email_verification.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/types.dart';

class WrapperPage extends StatefulWidget {
  const WrapperPage({ super.key });  
  
  @override
  State<StatefulWidget> createState() => _WrapperState();
}

class _WrapperState extends State<WrapperPage> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
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
            return CreateUserPage();
          case PageStateType.deviceList:
            return DeviceListPage();
          case PageStateType.monitor:
            return MonitorPage();
          // ignore: unreachable_switch_default
          default:
            return NotFoundPage();
        }
      }
    );
  }
}
