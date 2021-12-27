import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter_application_1/course.dart';

import 'Utils/my_store.dart';

bool adding = false;

class EditCourses extends StatefulWidget {
  final Course course;
  const EditCourses({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  State<EditCourses> createState() => _EditCoursesState();
}

class _EditCoursesState extends State<EditCourses> {
  TextEditingController courseID = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController credits = TextEditingController();
  TextEditingController type = TextEditingController();

  @override
  void initState() {
    adding = false;
    courseID.text = widget.course.course_id;
    name.text = widget.course.coursename;
    credits.text = widget.course.credits.toString();
    type.text = widget.course.type;
    super.initState();
  }

  final MyStore store = VxState.store;
  final _formKey2 = GlobalKey<FormState>();

  List<String> cType = ["COMPULSORY", "ELECTIVE"];

  _showPickerCType() {
    showModalBottomSheet(
        context: context,
         shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                "Course Type".text.bold.xl2.make().p12().centered(),
                ListView.builder(
                  itemCount: cType.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                        // leading: Icon(CupertinoIcons.person_alt_circle),
                        title: Text("${cType[index]}").centered(),
                        onTap: () async {
                          type.text = "${cType[index]}";
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

  Future<void> sendQuery() async {
    if (_formKey2.currentState!.validate()) {
      adding = true;
      print(adding);
      setState(() {});
      try {
        final Dio _dio = Dio();
        Response response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/course/updateCourse',
          data: {
            "course_id": courseID.text,
            "coursename": name.text,
            "type": type.text,
            "credits": credits.text
          },
        );

        print('Updating: ${response.data}');

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
          Fluttertoast.showToast(msg: "Course successfully updated");
        } else {
          setState(() {
            adding = false;
          });
          print(response.data);
          Fluttertoast.showToast(msg: "Not able to update.");
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

  @override
  Widget build(BuildContext context) {
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
                      "Edit Course Details".text.xl5.bold.make().expand(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(CupertinoIcons.chevron_back),
                        iconSize: 40,
                      )
                    ],
                  ),

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
                          padding: EdgeInsets.only(left: 0),
                        ),
                      ),
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: courseID,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "ID can't be empty";
                            }
                            return null;
                          },
                          placeholder: "ID",
                          prefix: "ID".text.caption(context).make(),
                          padding: EdgeInsets.only(left: 0),
                        ),
                      ),
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: type,
                          onTap: _showPickerCType,
                          placeholder: "Type",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Type can't be empty";
                            }
                            return null;
                          },
                          prefix: "Type ".text.caption(context).make(),
                          decoration: const BoxDecoration(color: Colors.white),
                          readOnly: true,
                          padding: EdgeInsets.only(left: 0),
                        ),
                      ),
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          // initialValue: widget.course.credits.toString(),
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
                          padding: EdgeInsets.only(left: 0),
                        ),
                      ),
                    ],
                  ),

                  50.heightBox,
                  Container(
                    width: 70,
                    height: 70,

                    // color: Colors.white,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: adding
                        ? CircularProgressIndicator(
                            color: Colors.grey,
                          )
                        : IconButton(
                            onPressed: () {
                              sendQuery();
                            },
                            icon: Icon(CupertinoIcons.checkmark_seal_fill),
                            iconSize: 60,
                            color: Colors.grey,
                          ).centered(),
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
