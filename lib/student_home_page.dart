import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/Utils/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';
import 'Utils/my_store.dart';
import 'course.dart';
import 'course_availability_class.dart';

bool showLoading = false;

class StuHome extends StatefulWidget {
  @override
  State<StuHome> createState() => _StuHomeState();
}

class _StuHomeState extends State<StuHome> {
  TextEditingController oldPassw = TextEditingController();
  TextEditingController newPass = TextEditingController();

  final MyStore store = VxState.store;

  Future<void> doEnrollment() async {
    if (store.courseList!.isNotEmpty) {
      try {
        showLoading = true;
        setState(() {});

        final Dio _dio = Dio();
        Response response;

        await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/course/isEnrolledInCourse',
          data: {
            "student_id": store.student.userid,
            "course_id": store.courseList![0].course_id
          },
        ).then((response_) {
          print("response is: " + response_.toString());
          if (!(response_.data)) {
            store.courseList?.forEach((course) async {
              response = await _dio.post(
                'https://course-registration-lnmiit.herokuapp.com/course/addEnrollment',
                data: {
                  "student_id": store.student.userid,
                  "course_id": course.course_id
                },
              );
              print(response.data);
              Fluttertoast.showToast(
                  msg: "Core Course Registered Successfully");
            });
          }
          setState(() {
            showLoading = false;
          });
        });
      } catch (e) {
        print(e);
        Fluttertoast.showToast(msg: e.toString());
        setState(() {
          showLoading = false;
        });
        Navigator.pop(context);
      }
    }
  }

  int getSemesterFromJoiningYear() {
    DateTime curDate = DateTime.now();
    return curDate.month > 6
        ? 1 +
            2 *
                (curDate.year -
                    int.parse(store.student.joining_year.toString()))
        : 2 * (curDate.year - int.parse(store.student.joining_year.toString()));
  }

  Future<void> fetchCourses() async {
    store.courseList?.clear();
    setState(() {
      showLoading = true;
    });
    try {
      final Dio _dio = Dio();
      Response response = await _dio.post(
        'https://course-registration-lnmiit.herokuapp.com/course/getCoreCourses',
        data: {
          "branch": store.student.branch,
          "semester": getSemesterFromJoiningYear()
        },
      );
      print(response.data);
      CourseList.courseList = List.from(response.data)
          .map((itemMap) => Course.fromMap(itemMap))
          .toList();
      store.courseList = CourseList.courseList;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> updatePassword() async {
    try {
      showLoading = true;
      setState(() {});
      final dio = Dio();
      Response response = await dio.post(
          'https://course-registration-lnmiit.herokuapp.com/student/updatePassword',
          data: {
            "userId": store.student.userid,
            "passw": oldPassw.text,
            "newpassw": newPass.text
          });
      print(response.data);
      if (response.data.toString() == "Success") {
        String msg = "Password successfully changed.";
        print(msg);
        Fluttertoast.showToast(msg: msg);
        oldPassw.clear();
        newPass.clear();
      } else {
        String msg = "Incorrect Password";
        print(msg);
        Fluttertoast.showToast(msg: msg);
      }
      setState(() {
        showLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        showLoading = false;
      });
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }

  _showPickerChangePassword() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    "Update Password".text.bold.xl2.make().p12().centered(),
                    CupertinoFormSection(children: [
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: oldPassw,
                          obscureText: true,
                          placeholder: "Old Password",
                          // prefix: "Email".text.make(),
                          padding: const EdgeInsets.only(left: 0),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Old Password can't be empty";
                            }
                            return null;
                          },
                          prefix: "Old Password ".text.caption(context).make(),
                        ),
                      ),
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: newPass,
                          obscureText: true,
                          placeholder: "New Password",
                          // prefix: "Email".text.make(),
                          padding: const EdgeInsets.only(left: 0),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "New Password can't be empty";
                            }
                            return null;
                          },
                          prefix: "New Password ".text.caption(context).make(),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            updatePassword();
                            // fetchStudentByYear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: showLoading
            ? const CupertinoActivityIndicator(
                radius: 20,
              ).centered()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            bottomLeft: Radius.circular(50),
                            topRight: Radius.circular(0),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.person_circle,
                              color: Colors.white,
                              size: 40,
                            ),
                            const VerticalDivider(
                              color: Vx.white,
                              thickness: 1,
                            ),
                            "Student Panel".text.xl5.bold.center.white.make(),
                          ],
                        )).centered(),
                    10.heightBox,
                    Container(
                        // height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
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
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        'https://codeforces.com/predownloaded/ed/50/ed50d0c4723b09010287a430cb35f7c83ceba911.jpg')),
                                color: Colors.white,
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
                            ).pOnly(left: 4),
                            20.widthBox,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Name:     ${store.student.name}"
                                    .text
                                    .xl
                                    .bold
                                    .make(),
                                "User Id:   ${store.student.userid}"
                                    .text
                                    .xl
                                    .make(),
                                "Branch:   ${store.student.branch}"
                                    .text
                                    .xl
                                    .make(),
                                "Batch:     ${store.student.joining_year}"
                                    .text
                                    .xl
                                    .make()
                              ],
                            ).p8().expand()
                          ],
                        )).p16(),
                    Container(
                        width: 180,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(
                              CupertinoIcons.option,
                              color: Colors.white,
                              size: 25,
                            ),
                            const VerticalDivider(
                              color: Vx.white,
                              thickness: 1,
                            ),
                            "Functions".text.xl2.bold.center.white.make(),
                          ],
                        )).centered().p16(),
                    GestureDetector(
                      onTap: () async {
                        await fetchCourses();
                        await doEnrollment();
                        print("changingPages");
                        Navigator.pushNamed(
                            context, MyRoutes.addElectiveCourse);
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                          children: [
                            const Icon(CupertinoIcons.add_circled),
                            20.widthBox,
                            "Register Courses".text.xl2.make()
                          ],
                        ).pOnly(left: 20),
                      ).pOnly(bottom: 20),
                    ).px16(),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, MyRoutes.viewRegisteredCourse),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                          children: [
                            const Icon(CupertinoIcons.eyeglasses),
                            20.widthBox,
                            "View Saved Courses".text.xl2.make()
                          ],
                        ).pOnly(left: 20),
                      ).pOnly(bottom: 20),
                    ).px16(),
                    GestureDetector(
                      onTap: () => _showPickerChangePassword(),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                          children: [
                            const Icon(CupertinoIcons.settings),
                            20.widthBox,
                            "Change Password".text.xl2.make()
                          ],
                        ).pOnly(left: 20),
                      ).pOnly(bottom: 20),
                    ).px16(),
                    GestureDetector(
                      onTap: () => Navigator.popAndPushNamed(
                          context, MyRoutes.loginPage),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                          children: [
                            const Icon(CupertinoIcons.power),
                            20.widthBox,
                            "Logout".text.xl2.make()
                          ],
                        ).pOnly(left: 20),
                      ),
                    ).px16(),
                  ],
                ),
              ),
      ),
    );
  }
}
