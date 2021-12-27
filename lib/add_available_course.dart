import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter_application_1/course.dart';

import 'Utils/my_store.dart';

bool adding = false;

class AddAvlbCourse extends StatefulWidget {
  final Course course;
  const AddAvlbCourse({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  State<AddAvlbCourse> createState() => _AddAvlbCourseState();
}

class _AddAvlbCourseState extends State<AddAvlbCourse> {
  TextEditingController branch = TextEditingController();
  TextEditingController semester = TextEditingController();
  TextEditingController seats = TextEditingController();
  TextEditingController grp = TextEditingController();

  List<String> branches = ["CSE", "CCE", "ECE", "ME", "CSE Dual", "ECE Dual"];
  List<String> sems = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  _showPickerSemester() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                "Semester".text.bold.xl2.make().p12().centered(),
                ListView.builder(
                  itemCount: sems.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                        // leading: Icon(CupertinoIcons.person_alt_circle),
                        title: Text("${sems[index]}").centered(),
                        onTap: () async {
                          semester.text = "${sems[index]}";
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

  _showPickerBranch() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                "Branch".text.bold.xl2.make().p12().centered(),
                ListView.builder(
                  itemCount: branches.length,
                  physics: NeverScrollableScrollPhysics(),
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

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
    }

    final _formKey2 = GlobalKey<FormState>();

    Future<void> sendQuery() async {
      if (_formKey2.currentState!.validate()) {
        adding = true;
        print(adding);
        setState(() {});
        try {
          final Dio _dio = Dio();
          Response response = await _dio.post(
            'https://course-registration-lnmiit.herokuapp.com/course/addAvailableCourse',
            data: {
              "course_id": widget.course.course_id,
              "semester": semester.text,
              "branch": branch.text,
              "totalSeats": seats.text,
              "grp": grp.text
            },
          );
          print(widget.course.course_id);
          print(semester.text);
          print(branch.text);
          print(seats.text);
          print(grp.text);

          print('Adding: ${response.data}');

          if (response.data.toString() == "success") {
            Navigator.pop(context);
            setState(() {
              adding = false;
            });
            Fluttertoast.showToast(msg: "Availability Added.");
          } else {
            setState(() {
              adding = false;
            });
            print(response.data);
            Fluttertoast.showToast(msg: "Not able to Add.");
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Add Course Availability".text.bold.xl5.make().expand(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(CupertinoIcons.chevron_back),
                        iconSize: 40,
                      )
                    ],
                  ).pOnly(bottom: 20),
                  10.heightBox,
                  "${widget.course.coursename} (${widget.course.course_id})"
                      .text
                      .xl
                      .make(),
                  10.heightBox,
                  CupertinoFormSection(
                    backgroundColor: Colors.transparent,
                    header: "Course Properties".text.make(),
                    children: [
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
                          padding: EdgeInsets.only(left: 0),
                        ),
                      ),
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: semester,
                          onTap: _showPickerSemester,
                          placeholder: "Semester",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Semester can't be empty";
                            }
                            return null;
                          },
                          prefix: "Semester ".text.caption(context).make(),
                          decoration: const BoxDecoration(color: Colors.white),
                          readOnly: true,
                          padding: EdgeInsets.only(left: 0),
                        ),
                      ),
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: seats,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Seats can't be empty";
                            }
                            return null;
                          },
                          placeholder: "Seats",
                          prefix: "Seats ".text.caption(context).make(),
                          padding: EdgeInsets.only(left: 0),
                        ),
                      ),
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: grp,
                          validator: (value) {
                            if (widget.course.type == "Elective" &&
                                value!.isEmpty) {
                              return "Group for elevtive course can't be empty.";
                            }
                            return null;
                          },
                          placeholder: "Group",
                          keyboardType: TextInputType.number,
                          prefix: "Group ".text.caption(context).make(),
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
