import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter_application_1/course.dart';

import 'Utils/my_store.dart';

bool adding = false;
bool adding2 = false;
bool haveAttachment = false;

class AddCourseAdm extends StatefulWidget {
  const AddCourseAdm({
    Key? key,
  }) : super(key: key);

  @override
  State<AddCourseAdm> createState() => _AddCourseAdmState();
}

class _AddCourseAdmState extends State<AddCourseAdm> {
  TextEditingController courseID = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController credits = TextEditingController();
  TextEditingController type = TextEditingController();
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
    }

    final MyStore store = VxState.store;
    final _formKey2 = GlobalKey<FormState>();
    late File file;
    late String fileName = '';

    selectAttachment() async {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ["xlsx"]);
      if (result != null) {
        adding2 = true;
        setState(() {});
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
              'https://course-registration-lnmiit.herokuapp.com/course/addMultipleNewCourse',
              data: formData);

          print('Adding: ${response.data}');
          if (response.data is List) {
            List<dynamic> res = response.data;

            Response response_ = await _dio.get(
              'https://course-registration-lnmiit.herokuapp.com/course/list',
            );
            CourseList.courseList = List.from(response_.data)
                .map((itemMap) => Course.fromMap(itemMap))
                .toList();
            store.courseList = CourseList.courseList;
            Navigator.pop(context);
            setState(() {
              adding2 = false;
            });
            Fluttertoast.showToast(
                msg: "${res.length} courses successfully added");
          } else {
            print("Not Added");
            Fluttertoast.showToast(msg: "Please check your file and try again");
            setState(() {
              adding2 = false;
            });
          }
        } catch (e) {
          print(e);
          Fluttertoast.showToast(msg: e.toString());
          setState(() {
            adding = false;
          });
          Navigator.pop(context);
        }
      }
    }

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
                    "Type of Course".text.bold.xl2.make().p12().centered(),
                    ListTile(
                        // leading: Icon(CupertinoIcons.fir),
                        title: const Text('COMPULSORY').centered(),
                        onTap: () {
                          type.text = "COMPULSORY";
                          setState(() {});
                        }),
                    ListTile(
                        // leading: Icon(Icons.contacts_outlined),
                        title: const Text('ELECTIVE').centered(),
                        onTap: () {
                          type.text = "ELECTIVE";
                          setState(() {});
                        })
                  ],
                ),
              ),
            );
          });
    }

    Future<void> sendQuery() async {
      if (_formKey2.currentState!.validate()) {
        adding = true;
        print(adding);
        print(name.text);
        setState(() {});
        try {
          final Dio _dio = Dio();
          Response response = await _dio.post(
            'https://course-registration-lnmiit.herokuapp.com/course/addNewCourse',
            data: {
              "course_id": courseID.text,
              "coursename": name.text,
              "type": type.text,
              "credits": credits.text
            },
          );

          print('Adding: ${response.data}');

          if (response.data.toString() == "success") {
            Response response_ = await _dio.get(
              'https://course-registration-lnmiit.herokuapp.com/course/list',
            );
            CourseList.courseList = List.from(response_.data)
                .map((itemMap) => Course.fromMap(itemMap))
                .toList();
            store.courseList = CourseList.courseList;
            Navigator.pop(context);
            setState(() {
              adding = false;
            });
            Fluttertoast.showToast(msg: "Course successfully added");
          } else {
            setState(() {
              adding = false;
            });
            print(response.data);
            Fluttertoast.showToast(msg: "Not able to add");
          }
        } catch (e) {
          setState(() {
            adding = false;
          });
          Fluttertoast.showToast(msg: 'Some error occured');
          print('Error: $e');
        }
      }
    }

    return Scaffold(
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
                  Row(
                    children: [
                      "Add Course Details".text.xl5.bold.make().expand(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(CupertinoIcons.chevron_back),
                        iconSize: 40,
                      )
                    ],
                  ),
                  30.heightBox,
                  // "Edit account".text.xl2.make(),
                  CupertinoFormSection(
                    backgroundColor: Colors.transparent,
                    header: "Course Info".text.make(),
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
                          prefix: "Name".text.caption(context).make(),
                          padding: const EdgeInsets.only(left: 0),
                        ),
                      ),
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: courseID,
                          textCapitalization: TextCapitalization.characters,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "ID can't be empty";
                            }
                            return null;
                          },
                          placeholder: "Course ID",
                          prefix: "Course ID".text.caption(context).make(),
                          padding: const EdgeInsets.only(left: 0),
                        ),
                      ),
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: type,
                          onTap: _showPicker,
                          placeholder: "Type",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Type can't be empty";
                            }
                            return null;
                          },
                          decoration: const BoxDecoration(color: Colors.white),
                          readOnly: true,
                          prefix: "Type".text.caption(context).make(),
                          padding: const EdgeInsets.only(left: 0),
                        ),
                      ),
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: credits,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Credits can't be empty";
                            }
                            return null;
                          },
                          placeholder: "Credits",
                          keyboardType: TextInputType.number,
                          prefix: "Credits".text.caption(context).make(),
                          padding: const EdgeInsets.only(left: 0),
                        ),
                      ),
                    ],
                  ),

                  20.heightBox,
                  adding
                      ? const CupertinoActivityIndicator(
                          radius: 20,
                        ).centered()
                      : GestureDetector(
                          onTap: () => sendQuery(),
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
                  20.heightBox,
                  const Divider(
                    thickness: 4,
                  ),
                  20.heightBox,
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
                  // Container(child: ,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
