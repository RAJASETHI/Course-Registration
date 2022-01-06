import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'Utils/my_store.dart';
import 'course.dart';

bool adding = false;
bool adding2 = false;

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController username = TextEditingController();
  TextEditingController branch = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController passw = TextEditingController();
  TextEditingController year = TextEditingController();
  List<String> branches = ["CSE", "CCE", "ECE", "ME", "CSE Dual", "ECE Dual"];

  _showPickerBranch() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                "Branch".text.bold.xl2.make().p12().centered(),
                ListView.builder(
                  itemCount: branches.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                        // leading: Icon(CupertinoIcons.person_alt_circle),
                        title: Text("${branches[index]}").centered(),
                        onTap: () async {
                          branch.text = "${branches[index]}";
                          setState(() {});
                          Navigator.pop(context);
                        });
                  },
                )
              ],
            ),
          );
        });
  }

  final _formKey2 = GlobalKey<FormState>();

  Future<void> addNewStudent() async {
    if (_formKey2.currentState!.validate()) {
      try {
        adding = true;
        setState(() {});
        final Dio _dio = Dio();
        Response response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/student/register',
          data: {
            "userId": username.text,
            "passw": passw.text,
            "name": name.text,
            "joining_year": year.text,
            "Student_DOB": "2001-09-24",
            "Branch": branch.text
          },
        );

        print('Adding: ${response.data}');

        if (response.data.toString() == "Success") {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Student Successfully Added");
        } else {
          print(response.data);
          print("Not able to add student...");
          Fluttertoast.showToast(msg: "Not added. StudentID already exist.");
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error creating user: $e');
        print('Error creating user: $e');
      }
      adding = false;
      setState(() {});
    }
  }

  late File file;
  late String fileName = '';
  final MyStore store = VxState.store;

  selectAttachment() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["xlsx"]);
    if (result != null) {
      file = File(result.files.single.path.toString());
      fileName = result.files.first.name;
      print('${file.readAsBytesSync()}');
      print(fileName);
      try {
        FormData formData = FormData.fromMap({
          "file":
              await MultipartFile.fromFile(file.path, filename: "file.xlsx"),
        });

        final Dio _dio = Dio();
        Response response = await _dio.post(
            'https://course-registration-lnmiit.herokuapp.com/student/registerMultiple',
            data: formData);

        print('Adding: ${response.data}');
        if (response.data is List) {
          List<dynamic> res = response.data;

          Response response_ = await _dio.get(
            'https://course-registration-lnmiit.herokuapp.com/student/list',
          );
          CourseList.courseList = List.from(response_.data)
              .map((itemMap) => Course.fromMap(itemMap))
              .toList();
          store.courseList = CourseList.courseList;
          Navigator.pop(context);
          setState(() {
            adding = false;
            adding2 = false;
          });
          Fluttertoast.showToast(
              msg: "${res.length} Student successfully added");
        } else {
          print("Not Added");
          Fluttertoast.showToast(msg: "Please check your file and try again");
          setState(() {
            adding = false;
            adding2 = false;
          });
        }
      } catch (e) {
        print(e);
        Fluttertoast.showToast(msg: e.toString());
        setState(() {
          adding2 = false;
          adding2 = false;
        });
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                      "Add Student"
                          .text
                          .bold
                          .xl5
                          .make()
                          .pOnly(left: 20, top: 20),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(CupertinoIcons.chevron_back),
                        iconSize: 40,
                      ).pOnly(top: 20)
                    ],
                  ),
                  "Create new account".text.xl2.make().pOnly(left: 20),
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
                          prefix: "Name ".text.caption(context).make(),
                          padding: const EdgeInsets.only(left: 0),
                        ),
                      ),
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: branch,
                          onTap: _showPickerBranch,
                          placeholder: "Branch",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Branch can't be empty";
                            }
                            return null;
                          },
                          prefix: "Branch ".text.caption(context).make(),
                          decoration: const BoxDecoration(color: Colors.white),
                          readOnly: true,
                          padding: const EdgeInsets.only(left: 0),
                        ),
                      ),
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: year,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Batch can't be empty";
                            }
                            return null;
                          },
                          prefix: "Batch ".text.caption(context).make(),
                          placeholder: "Batch",

                          // prefix: "Username".text.make(),
                          padding: const EdgeInsets.only(left: 0),
                        ),
                      ),
                    ],
                  ).pOnly(left: 20, right: 20, top: 10),
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
                          prefix: "Student ID ".text.caption(context).make(),
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
                          prefix: "Password ".text.caption(context).make(),
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
                  ).pOnly(left: 20, right: 20),
                  30.heightBox,
                  adding
                      ? const CupertinoActivityIndicator(
                          radius: 20,
                        ).centered()
                      : GestureDetector(
                          onTap: () => addNewStudent(),
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
                  10.heightBox,
                  const Divider(
                    thickness: 2,
                  ).p12(),
                  10.heightBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      adding2
                          ? const CupertinoActivityIndicator(
                              radius: 20,
                            )
                          : Container(
                              width: 70,
                              height: 70,
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
                                onPressed: selectAttachment,
                                icon: const Icon(
                                  CupertinoIcons.cloud_upload,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                            ),
                      "Upload a .xlsx File".text.make().p12()
                    ],
                  ).centered()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
