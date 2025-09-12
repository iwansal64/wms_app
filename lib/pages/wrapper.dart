import 'package:flutter/material.dart';
import 'package:wms_app/pages/login.dart';
import 'package:wms_app/pages/page_not_found.dart';
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
          default:
            return NotFoundPage();
        }
      }
    );
  }
}
