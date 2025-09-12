import 'package:flutter/material.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/api.dart';
import 'package:wms_app/utils/types.dart';


class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

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
              maxHeight: 700,
              minHeight: 600
            ),
            child: FractionallySizedBox(
              heightFactor: 0.8,
              widthFactor: 0.8,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 600
                ),
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
                                "Enter token",
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
              )
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
  String token = "";
  String username = "";
  String password = "";
  
  String errorMessage = "";
  bool verifyProcess = false;

  void showErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }
  
  void handleVerify() async {
    if(token.isEmpty || username.isEmpty || password.isEmpty) {
      showErrorMessage("Fill all the fields please");
      return;
    }
    
    setState(() {
      verifyProcess = true;
    });
    
    APIResponseCode result = await verifyUser(token, username, password);
    switch(result) {
      case APIResponseCode.ok:
        AppState.pageState.value = PageStateType.login;
        break;
      case APIResponseCode.unauthorized:
        showErrorMessage("Well.. You got it wrong buddy.");
        break;
      default:
        break;
    }

    setState(() {
      verifyProcess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        //? Text Field for Token
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 5),
              child: const Text(
                "Token",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Have you ever see your email inbox? :)",
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
                  token = value;
                });
              },
            )
          ],
        ),
        //? Text Field for Username
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 5),
              child: const Text(
                "New Username",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Make sure it looks good on my DB",
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
                hintText: "Have you write it on a paper yet?",
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
                });
              },
            )
          ],
        ),
        Text(
          errorMessage,
          style: TextStyle(
            color: Colors.red
          ),
        ),
        //? Verify
        Opacity(
          opacity: verifyProcess ? 1 : 1,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
              disabledBackgroundColor: Colors.white,
              disabledForegroundColor: Colors.black
            ),
            onPressed: verifyProcess ? handleVerify : handleVerify,
            child: const Text("Verify")
          )
        ),
      ],
    );
  }
}