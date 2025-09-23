import 'package:flutter/material.dart';
import 'package:wms_app/state.dart';

class ToastCard extends StatelessWidget {
  const ToastCard({ super.key });
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppState.toastState,
      builder: (BuildContext context, value, _) {
        if(value == null) {
          return const Text("");
        }

        return Positioned(
          top: 20,
          right: 20,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 200,
              minHeight: 100,
              maxWidth: MediaQuery.of(context).size.width - 100
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Text(
                      value.status.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: value.statusColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      value.message,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
              ),
            )
          )
        );
      },
    );
  }
}


