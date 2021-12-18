import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

class StuHome extends StatelessWidget {
  final _formKey2 = GlobalKey<FormState>();

  Future<void> updatePassword() async {
    // if (_formKey2.currentState!.validate()) {
    //   try {
    //     final Dio _dio = Dio();
    //     Response response = await _dio.post(
    //       'https://course-registration-lnmiit.herokuapp.com/admin/register',
    //       data: {
    //         "userId": username.text,
    //         "passw": passw.text,
    //       },
    //     );

    //     print('Adding: ${response.data}');

    //     String success = response.data;
    //     if (success == "Success") {
    //       Fluttertoast.showToast(msg: "Admin Successfully Added");
    //     } else {
    //       Fluttertoast.showToast(msg: "Not able to add admin...");
    //     }
    //   } catch (e) {
    //     Fluttertoast.showToast(msg: 'Error creating user: $e');
    //     print('Error creating user: $e');
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    String passw = "";
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () =>
                      Navigator.popAndPushNamed(context, MyRoutes.loginPage),
                  icon: Icon(Icons.logout_outlined))
            ],
            title: Text("Student Panel"),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 100.0,
                      backgroundImage: NetworkImage(
                          "https://media.istockphoto.com/photos/smiling-indian-business-man-working-on-laptop-at-home-office-young-picture-id1307615661?b=1&k=20&m=1307615661&s=170667a&w=0&h=Zp9_27RVS_UdlIm2k8sa8PuutX9K3HTs8xdK0UfKmYk="),
                    ).p12(),
                    const Text(
                      'Rahul Gupta',
                      style: TextStyle(
                          fontFamily: 'Pacifico',
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const HeightBox(20),
                    const Text(
                      '19ucs001@lnmiit.ac.in',
                      style: TextStyle(
                          fontFamily: 'SourceSerifPro',
                          color: Colors.black,
                          fontSize: 22.0),
                    ),
                    const SizedBox(
                      height: 20.0,
                      width: 150.0,
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    HeightBox(20),
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          // icon: Icon(Icons.security),
                          hintText: 'New Password',
                          labelText: 'Change Password',
                        ),
                        onChanged: (String? value) => passw = value!,
                      ),
                    ),
                    HeightBox(20),
                    ElevatedButton(
                        onPressed: () => updatePassword(),
                        child: Text(
                          "Udpdate Info",
                          style: TextStyle(color: Colors.black),
                        )),
                    HeightBox(20),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, MyRoutes.addCoreCourse);
                        },
                        child: Text(
                          "Register Courses",
                        )),
                    HeightBox(20),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, MyRoutes.viewRegisteredCourse);
                        },
                        child: Text(
                          "View Registered Courses",
                        ))
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
