import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  List<String> type = ["Student", "Admin"];
  int index = 1;
  String password = "";
  bool forAnimation = false;
  final _formKey = GlobalKey<FormState>();

  void moveToHome() async {

    // TODO: After Backend
    if (_formKey.currentState!.validate()) {
      if (index == 1) {
        try {
          final Dio _dio = Dio();
          Response response = await _dio.post(
            'https://course-registration-lnmiit.herokuapp.com/student/verify',
            data: {"userId": name, "passw": password},
          );

          print('Login: ${response.data}');

          bool success = response.data;
          if (success) {
            Fluttertoast.showToast(msg: "Login Success as Student");
            await Navigator.pushReplacementNamed(
                context, MyRoutes.studentHomePage);
          } else {
            Fluttertoast.showToast(msg: "Login Failed");
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Oops! Something went wrong. Try Again...");
          print('Error creating user: $e');
        }
      } else {
        try {
          final Dio _dio = Dio();
          Response response = await _dio.post(
            'https://course-registration-lnmiit.herokuapp.com/admin/verify',
            data: {"userId": name, "passw": password},
          );

          print('Login: ${response.data}');

          bool success = response.data;
          if (success) {
            Fluttertoast.showToast(msg: "Login Success as Admin");
            await Navigator.pushReplacementNamed(
                context, MyRoutes.adminHomePage);
          } else {
            Fluttertoast.showToast(msg: "Login Failed");
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Oops! Something went wrong. Try Again...");
          print('Error creating user: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.canvasColor,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  VxArc(
                    height: 50,
                    child: Image.asset(
                      "assets/images/welcomeImage.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16, left: 32.0, right: 32),
                    child: Text(
                      name == "" ? "Welcome" : "Welcome, $name",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Enter Username",
                            labelText: "Username",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Username can't be empty";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                        ),
                        TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: "Enter Password",
                                labelText: "Password"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password can't be empty";
                              } else if (value.length < 4) {
                                return "Password should consist of atleast 6 characters";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "Role".text.xl.make(),
                            Container(
                              padding: const EdgeInsets.all(20),
                              child: DropdownButton(
                                borderRadius: BorderRadius.circular(20),
                                value: index,
                                items: [
                                  DropdownMenuItem(
                                    child: Text(type[0]),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text(type[1]),
                                    value: 2,
                                  )
                                ],
                                onChanged: (int? value) {
                                  print(value);
                                  index = value!;
                                  setState(() {});
                                },
                                icon: const Icon(Icons.arrow_drop_down_circle),
                                // hint: const Text("Select item")
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10.0,
                  // ),
                  Material(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(forAnimation ? 40 : 8),
                    child: InkWell(
                      onTap: () => moveToHome(),
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        alignment: Alignment.center,
                        child: forAnimation
                            ? const Icon(
                                Icons.done,
                                color: Colors.white,
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                        width: forAnimation ? 40 : 80,
                        height: 40,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
