import 'package:flutter/material.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/api.dart';
import 'package:wms_app/utils/types.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                  color: Colors.white,
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
                            const Text(
                              "LOGIN",
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                            ),
                            const Text(
                              "Login to an existing email account",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
  String username = "";
  String password = "";

  String errorMessage = "";
  bool loginProcess = false;


  void showErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }
  
  
  void handleLogin() async {
    if(username.isEmpty || password.isEmpty) {
      showErrorMessage("Please fill the username and password! >:(");
      return;
    }
    
    setState(() {
      loginProcess = true;
    });
    
    APIResponseCode result = await loginUser(username, password);
    switch (result) {
      case APIResponseCode.ok:
        logger.i("Successfully login!");
        AppState.pageState.value = PageStateType.deviceList;
        break;
      case APIResponseCode.unauthorized:
        showErrorMessage("Username or password is wrong. :(");
        break;
      default:
        break;
    }

    setState(() {
      loginProcess = false;
    });
  }

  void handleRegister() {
    AppState.pageState.value = PageStateType.emailRegistration;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        //? Text Field for Username
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 5),
              child: const Text(
                "Username",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "You remember your username, right?",
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
                  username = value;
                  errorMessage = "";
                });
              },
            )
          ],
        ),
        //? Text Field for Password
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 5),
              child: const Text(
                "Password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password or hack this app >:)",
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
                  password = value;
                  errorMessage = "";
                });
              },
            )
          ],
        ),
        Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red
          )
        ),
        Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 15,
          children: [
            //? Login Button
            Opacity(
              opacity: loginProcess ? 0.2 : 1,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.black,
                  disabledForegroundColor: Colors.white,
                ),
                onPressed: loginProcess ? null : handleLogin,
                child: const Text("Login to Dashboard")
              ),
            ),
            //? Signup Button
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              ),
              onPressed: handleRegister,
              child: const Text("Registeration")
            ),
          ],
        )
      ],
    );
  }
}