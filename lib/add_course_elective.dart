import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Utils/routes.dart';
import 'package:flutter_application_1/student.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:velocity_x/velocity_x.dart';

import 'Utils/my_store.dart';
import 'course.dart';

bool showLoading = false;
bool saved = false;
List<bool> adding = [];
List<bool> registered = [];

class AddCourseElective extends StatefulWidget {
  const AddCourseElective({Key? key}) : super(key: key);

  @override
  State<AddCourseElective> createState() => _AddCourseElectiveState();
}

class _AddCourseElectiveState extends State<AddCourseElective> {
  final MyStore store = VxState.store;

  int getSemesterFromJoiningYear() {
    DateTime curDate = DateTime.now();
    return curDate.month > 6
        ? 1 +
            2 *
                (curDate.year -
                    int.parse(store.student.joining_year.toString()))
        : 2 * (curDate.year - int.parse(store.student.joining_year.toString()));
  }

  Future<void> doEnrollment(Course course, int index) async {
    try {
      adding[index] = true;
      setState(() {});
      final Dio _dio = Dio();
      Response response;

      response = await _dio.post(
        'https://course-registration-lnmiit.herokuapp.com/course/decreaseAvailableSeats',
        data: {
          "branch": store.student.branch,
          "course_id": course.course_id,
          "semester": getSemesterFromJoiningYear().toString()
        },
      );
      if (response.data.toString() != "Seats Not Available") {
        store.courseList![index].availableseats = response.data;
        response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/course/addEnrollment',
          data: {
            "student_id": store.student.userid,
            "course_id": course.course_id
          },
        );
        if (response.data.toString() == "success") {
          registered[index] = !registered[index];
          print(registered[index]);
          setState(() {
            adding[index] = false;
          });
        }
      }

      setState(() {
        adding[index] = false;
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
      setState(() {
        adding[index] = false;
      });
      Navigator.pop(context);
    }
  }

  Future<void> refreshButton(Course course, int index) async {
    try {
      adding[index] = true;
      setState(() {});
      final Dio _dio = Dio();
      Response response;

      response = await _dio.post(
        'https://course-registration-lnmiit.herokuapp.com/course/getAvailableSeats',
        data: {
          "branch": store.student.branch,
          "course_id": course.course_id,
          "semester": getSemesterFromJoiningYear().toString()
        },
      );
      // Fluttertoast.showToast(msg: response.data.toString());
      if (response.data is int) {
        store.courseList![index].availableseats = response.data;

        setState(() {
          adding[index] = false;
        });
      } else {
        print("Doesn't return a number");
        Fluttertoast.showToast(msg: "Not able to refresh!");
        setState(() {
          adding[index] = false;
        });
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Not able to refresh!");
      setState(() {
        adding[index] = false;
      });
    }
  }

  Future<void> cancelEnrollment(Course course, int index) async {
    try {
      adding[index] = true;
      setState(() {});
      final Dio _dio = Dio();
      Response response;

      response = await _dio.post(
        'https://course-registration-lnmiit.herokuapp.com/course/increaseAvailableSeats',
        data: {
          "branch": store.student.branch,
          "course_id": course.course_id,
          "semester": getSemesterFromJoiningYear().toString()
        },
      );
      if (response.data.toString() != "Not Allowed") {
        store.courseList![index].availableseats = response.data;
        response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/course/deleteEnrollment',
          data: {
            "student_id": store.student.userid,
            "course_id": course.course_id
          },
        );
        if (response.data.toString() == "success") {
          registered[index] = !registered[index];
          setState(() {
            adding[index] = false;
          });
        }
      }

      setState(() {
        adding[index] = false;
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
      setState(() {
        adding[index] = false;
      });
      Navigator.pop(context);
    }
  }

  Future<void> checkRegistered() async {
    try {
      final Dio _dio = Dio();
      Response response;
      CourseList.courseList?.forEach((element) async {
        response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/course/isEnrolledInCourse',
          data: {
            "student_id": store.student.userid,
            "course_id": element.course_id
          },
        );
        print(response.data);
        registered.add(response.data);
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
      setState(() {});
      Navigator.pop(context);
    }
  }

  Future<void> fetchCourses() async {
    registered.clear();
    store.courseList?.clear();
    setState(() {});
    try {
      final Dio _dio = Dio();
      Response response = await _dio.post(
        'https://course-registration-lnmiit.herokuapp.com/course/getElectiveCourses',
        data: {
          "branch": store.student.branch,
          "semester": getSemesterFromJoiningYear()
        },
      );
      print("Elective response: " + response.data.toString());
      Response temp = response;
      List.from(temp.data)
          .map((itemMap) => Course.fromMap(itemMap))
          .toList()
          .forEach((element) async {
        response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/course/isEnrolledInCourse',
          data: {
            "student_id": store.student.userid,
            "course_id": element.course_id
          },
        );
        print(response.data);
        registered.add(response.data);
        adding.add(false);
        if (registered.length == CourseList.courseList!.length) setState(() {});
      });
      CourseList.courseList = await List.from(temp.data)
          .map((itemMap) => Course.fromMap(itemMap))
          .toList();
      store.courseList = CourseList.courseList;

      setState(() {});
      if (CourseList.courseList!.isEmpty) {
        Fluttertoast.showToast(msg: "No course available.");
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
      setState(() {});
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey,

      body: SingleChildScrollView(
        child: SafeArea(
            child: (store.courseList != null &&
                    store.courseList!.isNotEmpty &&
                    registered.length >= CourseList.courseList!.length)
                ? Column(
                    children: [
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
                                CupertinoIcons.add_circled,
                                color: Colors.white,
                                size: 40,
                              ),
                              const VerticalDivider(
                                color: Vx.white,
                                thickness: 1,
                              ),
                              "Elective Courses"
                                  .text
                                  .xl4
                                  .bold
                                  .center
                                  .white
                                  .make(),
                            ],
                          )).centered(),
                      CupertinoSearchTextField(
                        prefixInsets: const EdgeInsets.all(8),
                        style: GoogleFonts.poppins(),
                        placeholder: "Search Course",
                        onChanged: (value) => SearchMutation(value),
                        borderRadius: BorderRadius.circular(10),
                      ).pLTRB(20, 20, 20, 20),
                      Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            "Course ID".text.bold.caption(context).make(),
                            "Course Name".text.bold.caption(context).make(),
                            "Credits".text.bold.caption(context).make(),
                          ],
                        ),
                      ),
                      VxBuilder(
                        mutations: const {SearchMutation},
                        builder: (context, _, __) => ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: store.courseList!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Container(
                                // height: 200,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      // height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            width: 50,
                                            child:
                                                "${store.courseList![index].course_id}"
                                                    .text
                                                    .xl
                                                    .center
                                                    .make()
                                                    .pOnly(left: 10),
                                          ),
                                          const VerticalDivider(
                                            thickness: 1,
                                          ),
                                          Container(
                                            width: 150,
                                            child:
                                                "${store.courseList![index].coursename}"
                                                    .text
                                                    .xl.bold
                                                    .center
                                                    .make(),
                                          ),
                                          const VerticalDivider(
                                            thickness: 1,
                                          ),
                                          Container(
                                            width: 40,
                                            child:
                                                "${store.courseList![index].credits}"
                                                    .text
                                                    .xl
                                                    .center
                                                    .make()
                                                    .pOnly(right: 10),
                                          ),
                                        ],
                                      ),
                                    ).pOnly(bottom: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child:
                                                "Group: ${store.courseList![index].grp}"
                                                    .text
                                                    .center
                                                    .white
                                                    .make()),
                                        Container(
                                          // width: 70,
                                          // height: 80,
                                          decoration: BoxDecoration(
                                            color: store.courseList![index]
                                                        .availableseats >
                                                    0
                                                ? Colors.black
                                                : Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                blurRadius: 7,
                                                // offset: const Offset(0,
                                                // 3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            // width: 200,
                                            height: 40,
                                            child: adding[index]
                                                ? const CupertinoActivityIndicator(
                                                    radius: 15,
                                                  ).backgroundColor(
                                                    Colors.white)
                                                // .darkTheme()
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      registered[index]
                                                          ? InkWell(
                                                              child: "   UNSAVE"
                                                                  .text
                                                                  .bold
                                                                  .white
                                                                  .make(),
                                                              onTap: () =>
                                                                  cancelEnrollment(
                                                                      store.courseList![
                                                                          index],
                                                                      index),
                                                            )
                                                          : InkWell(
                                                              child: "    SAVE"
                                                                  .text
                                                                  .bold
                                                                  .white
                                                                  .make(),
                                                              onTap: () =>
                                                                  doEnrollment(
                                                                      store.courseList![
                                                                          index],
                                                                      index),
                                                            ),
                                                      const VerticalDivider(
                                                        color: Colors.white,
                                                        thickness: 1,
                                                      ),
                                                      Container(
                                                          width: 60,
                                                          child: "${store.courseList![index].availableseats}"
                                                              .text
                                                              .bold
                                                              .xl
                                                              .white
                                                              .makeCentered()),
                                                      const VerticalDivider(
                                                        color: Colors.white,
                                                        thickness: 1,
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          refreshButton(
                                                              store.courseList![
                                                                  index],
                                                              index);
                                                        },
                                                        icon: const Icon(
                                                            CupertinoIcons
                                                                .refresh_thick),
                                                        iconSize: 25,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
                              ).pOnly(left: 8, right: 8, bottom: 12),
                            );
                          },
                        ),
                      ).pOnly(left: 10, right: 10),
                      20.heightBox,
                      GestureDetector(
                        onTap: () {
                          Navigator.popAndPushNamed(
                              context, MyRoutes.viewRegisteredCourse);
                        },
                        child: Container(
                            width: 120,
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
                                  CupertinoIcons.chevron_forward,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                const VerticalDivider(
                                  color: Vx.white,
                                  thickness: 1,
                                ),
                                "Next".text.xl2.bold.center.white.make(),
                              ],
                            )),
                      ).p16()
                    ],
                  )
                : const CupertinoActivityIndicator(
                    radius: 20,
                  ).centered().hFull(context)),
      ),
    );
  }
}
