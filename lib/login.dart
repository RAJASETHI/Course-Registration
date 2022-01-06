import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/my_store.dart';
import 'package:flutter_application_1/Utils/routes.dart';
import 'package:flutter_application_1/admin.dart';
import 'package:flutter_application_1/student.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_fonts/google_fonts.dart';

bool adding = false;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController role = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _showPicker() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  "Roles".text.bold.xl2.make().p12().centered(),
                  ListTile(
                      leading: const Icon(CupertinoIcons.person_alt_circle),
                      title: const Text('Student'),
                      onTap: () {
                        role.text = "Student";
                        setState(() {});
                        Navigator.pop(context);
                      }),
                  ListTile(
                      leading: const Icon(Icons.contacts_outlined),
                      title: const Text('Admin'),
                      onTap: () {
                        role.text = "Admin";
                        setState(() {});
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          );
        });
  }

  Future<void> forgetPassword() async {
    try {
      final dio = Dio();
      Response response = await dio.post(
          'https://course-registration-lnmiit.herokuapp.com/student/resetPassword',
          data: {
            "userId": username.text,
          });
      if (response.data.toString() == "success") {
        String msg = "Password successfully sent.";
        print(msg);
        Fluttertoast.showToast(msg: msg);
      } else {
        print(response.data);
        String msg = "User not found";
        print(msg);
        Fluttertoast.showToast(msg: msg);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }

  _showPickerForgotPassword() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius:
                const BorderRadius.vertical(top: const Radius.circular(25.0))),
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    "Forgot Password".text.bold.xl2.make().p12().centered(),
                    CupertinoFormSection(children: [
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: username,
                          style: GoogleFonts.poppins(),
                          placeholder: "User ID",
                          // prefix: "Email".text.make(),
                          padding: const EdgeInsets.only(left: 0),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "User ID can't be empty";
                            }
                            return null;
                          },
                          prefix: "User ID ".text.caption(context).make(),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            forgetPassword();
                          },
                          icon: const Icon(
                            CupertinoIcons.right_chevron,
                            size: 30,
                          ))
                    ])
                  ],
                ),
              ),
            ),
          );
        });
  }

  void moveToHome() async {
    if (_formKey.currentState!.validate()) {
      adding = true;
      setState(() {});
      if (role.text == "Student") {
        try {
          final Dio _dio = Dio();
          Response response = await _dio.post(
            'https://course-registration-lnmiit.herokuapp.com/student/verify',
            data: {"userId": username.text, "passw": password.text},
            options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
            ),
          );

          print('Login: ${response.data}');

          if (response.data.toString() == "User Not Found" ||
              response.data.toString() == "Incorrect Password") {
            Fluttertoast.showToast(msg: "Username or Password is wrong");
            setState(() {
              adding = false;
            });
          } else {
            Fluttertoast.showToast(msg: "Login Success as Student");
            final MyStore store = VxState.store;
            store.student = Student.fromMap(response.data);
            print(store.student.name);
            print(store.student.userid);

            await Navigator.pushReplacementNamed(
                context, MyRoutes.studentHomePage);
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Oops! Something went wrong. Try Again...");
          print('Error creating user: $e');
          setState(() {
            adding = false;
          });
        }
        adding = false;
      } else if (role.text == "Admin") {
        try {
          final Dio _dio = Dio();
          Response response = await _dio.post(
            'https://course-registration-lnmiit.herokuapp.com/admin/verify',
            data: {"userId": username.text, "passw": password.text},
          );
          print(response.data);
          print('Login: ${response.data}');

          if (response.data.toString() == "Incorrect Password" ||
              response.data.toString() == "User Not Found") {
            Fluttertoast.showToast(msg: "Username or Password is wrong");
            setState(() {
              adding = false;
            });
          } else {
            Fluttertoast.showToast(msg: "Login Success as Admin");
            final MyStore store = VxState.store;
            store.admin = Admin.fromMap(response.data);
            print(store.admin.name);
            print(store.admin.userId);

            await Navigator.pushReplacementNamed(
                context, MyRoutes.adminHomePage);
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Oops! Something went wrong. Try Again...");
          print('Error creating user: $e');
          setState(() {
            adding = false;
          });
        }
        adding = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.canvasColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Text(
                  "Sign-In",
                  style: GoogleFonts.lato(
                      fontSize: 50, fontWeight: FontWeight.bold),
                ).centered(),
                CupertinoFormSection(
                  backgroundColor: Colors.transparent,
                  children: [
                    CupertinoFormRow(
                      //padding: EdgeInsets.only(left: 0),
                      child: CupertinoTextFormFieldRow(
                        style: GoogleFonts.poppins(),
                        controller: username,
                        placeholder: "Enter your ID",
                        prefix: "User ID      ".text.caption(context).make(),
                        padding: const EdgeInsets.only(left: 0),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "User ID can't be empty";
                          }
                          return null;
                        },
                      ),
                    ),
                    CupertinoFormRow(
                      //padding: EdgeInsets.only(left: 0),
                      child: CupertinoTextFormFieldRow(
                        style: GoogleFonts.poppins(),
                        obscureText: true,
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password can't be empty";
                          }
                          return null;
                        },
                        placeholder: "Enter your Password ",
                        prefix: "Password  ".text.caption(context).make(),
                        padding: const EdgeInsets.only(left: 0),
                      ),
                    ),
                    CupertinoTextFormFieldRow(
                      style: GoogleFonts.poppins(),
                      controller: role,
                      onTap: _showPicker,
                      placeholder: "Tap to Show Roles",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Role can't be empty";
                        }
                        return null;
                      },
                      decoration: const BoxDecoration(color: Colors.white),
                      prefix: "Role            ".text.caption(context).make(),
                      readOnly: true,
                    ),
                  ],
                ).pLTRB(32, 32, 32, 5),
                GestureDetector(
                        onTap: _showPickerForgotPassword,
                        child: "Forgot Password?".text.caption(context).make())
                    .centered(),
                adding
                    ? const CupertinoActivityIndicator(
                        radius: 20,
                      ).centered().pOnly(top: 40)
                    : Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => moveToHome(),
                          icon: const Icon(Icons.send_outlined),
                          iconSize: 40,
                          color: Colors.white,
                        ).pOnly(left: 4),
                      ).pOnly(top: 40).centered()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
