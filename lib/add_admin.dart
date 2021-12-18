import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/src/extensions/num_ext.dart';
import 'package:velocity_x/src/extensions/string_ext.dart';
import 'package:velocity_x/src/flutter/padding.dart';
import 'package:velocity_x/velocity_x.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({Key? key}) : super(key: key);

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController passw = TextEditingController();
    TextEditingController username = TextEditingController();

    @override
    void initState() {
      super.initState();
    }

    final _formKey2 = GlobalKey<FormState>();

    Future<void> addNewAdmin() async {
      if (_formKey2.currentState!.validate()) {
        try {
          print(username.text);
          print(passw.text);
          print(name.text);
          final Dio _dio = Dio();
          Response response = await _dio.post(
            'https://course-registration-lnmiit.herokuapp.com/admin/register',
            data: {
              "userId": username.text,
              "passw": passw.text,
              "name": name.text,
              "DOB": "2001-09-24"
            },
          );

          print('Adding: ${response.data}');

          String success = response.data;
          if (success == "Success") {
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "Admin Successfully Added");
          } else {
            Fluttertoast.showToast(msg: "Not able to add admin...");
          }
        } catch (e) {
          Fluttertoast.showToast(msg: 'Error creating user: $e');
          print('Error creating user: $e');
        }
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => addNewAdmin(),
        child: Icon(Icons.add, size: 35),
      ),
      body: SafeArea(
        child: Container(
          padding: Vx.m32,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Add Admin".text.xl5.bold.make(),
                  "Create new account".text.xl2.make(),
                  CupertinoFormSection(
                    backgroundColor: Colors.transparent,
                    header: "Personal Details".text.make(),
                    children: [
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Name can't be empty";
                            }
                            return null;
                          },
                          placeholder: "Name",
                          // prefix: "Name".text.make(),
                          padding: EdgeInsets.only(left: 0),
                        ),
                      ),
                    ],
                  ),
                  20.heightBox,
                  CupertinoFormSection(
                    backgroundColor: Colors.transparent,
                    header: "Login Details".text.make(),
                    children: [
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: username,
                          placeholder: "Username",
                          // prefix: "Email".text.make(),
                          padding: const EdgeInsets.only(left: 0),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Username can't be empty";
                            }
                            return null;
                          },
                        ),
                      ),
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password can't be empty";
                            } else if (value.length < 6) {
                              return "Password length should be atleast 6.";
                            }
                            return null;
                          },
                          controller: passw,
                          placeholder: "Password",
                          obscureText: true,
                          // prefix: "Password".text.make(),
                          padding: const EdgeInsets.only(left: 0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
