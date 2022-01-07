import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/src/extensions/num_ext.dart';
import 'package:velocity_x/src/extensions/string_ext.dart';
import 'package:velocity_x/src/flutter/padding.dart';
import 'package:velocity_x/velocity_x.dart';

bool adding = false;

class AddAdmin extends StatefulWidget {
  const AddAdmin({Key? key}) : super(key: key);

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
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
        setState(() {
          adding = true;
        });
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
        Fluttertoast.showToast(msg: 'Error creating user');
        print('Error creating user: $e');
      }
      setState(() {
        adding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // padding: Vx.m32,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Add Admin".text.bold.xl5.make().pOnly(left: 16, top: 20),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(CupertinoIcons.chevron_back),
                        iconSize: 40,
                      ).pOnly(top: 20)
                    ],
                  ),
                  "Create new account".text.xl2.make().px16(),
                  20.heightBox,
                  CupertinoFormSection(
                      backgroundColor: Colors.transparent,
                      header: "Details".text.make(),
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
                            prefix:
                                "Name         ".text.caption(context).make(),
                            padding: const EdgeInsets.only(left: 0),
                          ),
                        ),
                        CupertinoFormRow(
                          //padding: EdgeInsets.only(left: 0),
                          child: CupertinoTextFormFieldRow(
                            controller: username,
                            placeholder: "Username",
                            prefix: "Username".text.caption(context).make(),
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
                            prefix: "Password ".text.caption(context).make(),
                            padding: const EdgeInsets.only(left: 0),
                          ),
                        ),
                      ]).p16(),
                  40.heightBox,
                  adding
                      ? const CupertinoActivityIndicator(
                          radius: 20,
                        ).centered()
                      : GestureDetector(
                          onTap: () => addNewAdmin(),
                          child: Container(
                              width: 110,
                              height: 50,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Icon(
                                    CupertinoIcons.add,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  const VerticalDivider(
                                    color: Vx.white,
                                    thickness: 1,
                                  ),
                                  "Add".text.xl2.bold.center.white.make(),
                                ],
                              )),
                        ).centered(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
