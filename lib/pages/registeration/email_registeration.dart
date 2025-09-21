import 'package:flutter/material.dart';
import 'package:wms_app/default_styles.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/api.dart';
import 'package:wms_app/utils/types.dart';


class EmailRegistrationPage extends StatelessWidget {
  const EmailRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 58, 112)
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: 700
            ),
            child: FractionallySizedBox(
              heightFactor: 0.8,
              widthFactor: 0.8,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(100, 255, 255, 255),
                ),
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    spacing: 15,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Text(
                              "REGISTER",
                              style: DefaultStyles.basicTextStyle.merge(
                                TextStyle(
                                  fontSize: 32, 
                                  fontWeight: FontWeight.w400
                                )
                              ),
                            ),
                            Text(
                              "Register a new email account",
                              textAlign: TextAlign.center,
                              style: DefaultStyles.basicTextStyle.merge(
                                TextStyle(
                                  fontSize: 14, 
                                  fontWeight: FontWeight.w400
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: FormFieldComponent()
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ),
      ),
    );
  }
}

class FormFieldComponent extends StatefulWidget  {
  const FormFieldComponent({super.key});

  @override
  State<StatefulWidget> createState() => _FormFieldState();
}

class _FormFieldState extends State<FormFieldComponent> {
  String email = "";

  String errorMessage = "";
  bool registrationProcess = false;
  
  void showErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }
  
  void handleLogin() {
    AppState.pageState.value = PageStateType.login;
  }

  void handleRegister() async {
    if (registrationProcess) return;
    if (email.isEmpty) {
      showErrorMessage("Welp.. the email is empty bruh");
      return;
    }

    setState(() {
      registrationProcess = true;
    });

    APIResponseCode result = await registerEmail(email);
    switch (result) {
      case APIResponseCode.ok:
        AppState.pageState.value = PageStateType.emailVerification;
        break;
      case APIResponseCode.conflict:
        logger.e("There's duplicates!");
        showErrorMessage("Email has been registered");
        break;
      case APIResponseCode.timeout:
        logger.e("Timeout!");
        showErrorMessage("Connection timeout. Please check your internet connection.");
      case APIResponseCode.socketError:
        logger.e("Server unresponsive!");
        showErrorMessage("Server doesn't response. Please try again later :(");
        break;
      default:
        break;
    }
    
    setState(() {
      registrationProcess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        //? Text Field for Email
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 5),
              child: const Text(
                "Email",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Email please? :)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 0, 58, 112), width: 1.5),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                  errorMessage = "";
                });
              },
            ),
            //? Error message
            Center(
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 15,
          children: [
            //? Login Button
            Opacity(
              opacity: registrationProcess ? 0.5 : 1,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.black,
                  disabledForegroundColor: Colors.white,
                ),
                onPressed: registrationProcess ? null : handleRegister,
                child: const Text("Register Email!"),
              ),
            ),
            //? Signup Button
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              ),
              onPressed: handleLogin,
              child: const Text("Back to Login")
            ),
          ],
        )
      ],
    );
  }
}