import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/src/extensions/num_ext.dart';
import 'package:velocity_x/src/extensions/string_ext.dart';
import 'package:velocity_x/src/flutter/padding.dart';
import 'package:velocity_x/velocity_x.dart';

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.grey,
  //hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 16.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

class AddAdmin extends StatefulWidget {
  const AddAdmin({Key? key}) : super(key: key);

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  @override
  Widget build(BuildContext context) {
    TextEditingController dateinput = TextEditingController();

    @override
    void initState() {
      dateinput.text = ""; //set the initial value of text field
      super.initState();
    }

    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      // appBar: AppBar(
      //   title: const Text(
      //     "Add Student",
      //     style: TextStyle(fontSize: 25),
      //   ),
      //   centerTitle: true,
      //   // backgroundColor: Colors.grey,
      // ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add, size: 35),
      ),
      body: SafeArea(
        child: Container(
          padding: Vx.m32,
          child: SingleChildScrollView(
            child: Form(
              // key: _formKey2,
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
                          // controller: nameController,
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
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          // controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email can't be empty";
                            }
                            return null;
                          },
                          placeholder: "Email",
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
                          // controller: emailInputController,
                          placeholder: "Username",
                          // prefix: "Email".text.make(),
                          padding: EdgeInsets.only(left: 0),
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
                          // controller: pwdInputController,
                          placeholder: "Password",
                          obscureText: true,
                          // prefix: "Password".text.make(),
                          padding: EdgeInsets.only(left: 0),
                        ),
                      ),
                      CupertinoFormRow(
                          //padding: EdgeInsets.only(left: 0),
                          child: CupertinoTextFormFieldRow(
                              // controller: cnfpwdController,
                              //   validator: (value) {
                              //     if (value!.isEmpty) {
                              //       return "Required";
                              //     } else if (value.length < 6) {
                              //       return "Password length should be atleast 6.";
                              //     } else if (pwdInputController.text !=
                              //         cnfpwdController.text) {
                              //       return "Confirm password should be same as password";
                              //     }
                              //     return null;
                              //   },
                              //   placeholder: "Confirm Password",
                              //   //placeholderStyle: TextStyle(fontSize: 12),
                              //   obscureText: true,
                              //   // prefix: "Confirm Password".text.make(),
                              //   padding: EdgeInsets.only(left: 0),
                              // ),
                              ))
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
