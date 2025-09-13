import 'package:flutter/material.dart';
import 'package:wms_app/state.dart';
import 'package:wms_app/utils/api.dart';
import 'package:wms_app/utils/types.dart';


class CreateUserPage extends StatelessWidget {
  const CreateUserPage({super.key});

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
                                "Create User",
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                              ),
                              const Text(
                                "Fill the form please :)",
                                textAlign: TextAlign.center,
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
  String username = "";
  String password = "";
  String confrimationPassword = "";
  
  String errorMessage = "";
  bool createUserProcess = false;

  void showErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }
  
  void handleCreateUser() async {    
    if(username.isEmpty || password.isEmpty) {
      showErrorMessage("Fill all the fields please");
      return;
    }
    
    if(password != confrimationPassword) {
      showErrorMessage("Password is not matching");
      return;
    }

    setState(() {
      createUserProcess = true;
    });
    
    APIResponseCode result = await createUser(username, password);
    switch(result) {
      case APIResponseCode.ok:
        AppState.pageState.value = PageStateType.login;
        break;
      case APIResponseCode.unauthorized:
        showErrorMessage("Umm... Are you a hacker?");
        break;
      case APIResponseCode.socketError:
        showErrorMessage("Server doesn't response. Please try again later :(");
        break;
      default:
        break;
    }

    setState(() {
      createUserProcess = false;
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
                "Username",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Make sure it looks good on my DB!",
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
                "Create Password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Have you write it on paper yet?",
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
        //? Text Field for Password Confirmation
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 5),
              child: const Text(
                "Confirm Password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Have you write it on paper yet?",
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
                  confrimationPassword = value;
                  errorMessage = "";
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
        Spacer(),
        //? Verify Button
        Opacity(
          opacity: createUserProcess ? 0.2 : 1,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              disabledBackgroundColor: Colors.white,
              disabledForegroundColor: Colors.black
            ),
            onPressed: createUserProcess ? null : handleCreateUser,
            child: const Text("Create User!")
          )
        ),
      ],
    );
  }
}