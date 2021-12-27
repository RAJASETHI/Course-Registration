import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import 'Utils/my_store.dart';
import 'course.dart';

bool showLoading = false;
bool registered = false;
bool adding = false;

class AddCourseCore extends StatefulWidget {
  const AddCourseCore({Key? key}) : super(key: key);

  @override
  State<AddCourseCore> createState() => _AddCourseCoreState();
}

class _AddCourseCoreState extends State<AddCourseCore> {
  final MyStore store = VxState.store;

  Future<void> doEnrollment() async {
    try {
      adding = true;
      setState(() {});
      final Dio _dio = Dio();
      Response response;
      store.courseList?.forEach((course) async {
        response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/course/addEnrollment',
          data: {
            "student_id": store.student.userid,
            "course_id": course.course_id
          },
        );
        print(response.data);
      });

      Response response_ = await _dio.post(
        'https://course-registration-lnmiit.herokuapp.com/course/isEnrolledInCourse',
        data: {
          "student_id": store.student.userid,
          "course_id": store.courseList![0].course_id
        },
      );
      print(response_.data);
      registered = true;
      Fluttertoast.showToast(msg: "Core Coure Registered Successfully");
      setState(() {
        adding = false;
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
      setState(() {
        adding = false;
      });
      Navigator.pop(context);
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
    setState(() {});
    try {
      final Dio _dio = Dio();
      Response response = await _dio.post(
        'https://course-registration-lnmiit.herokuapp.com/course/getCompulsoryCourses',
        data: {
          "branch": store.student.branch,
          "semester": getSemesterFromJoiningYear()
        },
      );
      CourseList.courseList = List.from(response.data)
          .map((itemMap) => Course.fromMap(itemMap))
          .toList();
      store.courseList = CourseList.courseList;
      if (CourseList.courseList!.isNotEmpty) {
        response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/course/isEnrolledInCourse',
          data: {
            "student_id": store.student.userid,
            "course_id": CourseList.courseList![0]
          },
        );
      }
      print(response.data);
      registered = response.data;
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
            child: (CourseList.courseList != null &&
                    CourseList.courseList!.isNotEmpty)
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
                              "Core Courses".text.xl5.bold.center.white.make(),
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
                      showLoading
                          ? const CircularProgressIndicator(
                              color: Colors.grey,
                            ).centered().pOnly(top: 200)
                          : VxBuilder(
                              mutations: {SearchMutation},
                              builder: (context, _, __) => ListView.builder(
                                shrinkWrap: true,
                                itemCount: store.courseList!.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Container(
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            "${store.courseList![index].course_id}"
                                                .text
                                                .bold
                                                .xl
                                                .center
                                                .make()
                                                .pOnly(left: 10),
                                            const VerticalDivider(
                                              thickness: 1,
                                            ),
                                            Container(
                                              width: 150,
                                              child:
                                                  "${store.courseList![index].coursename}"
                                                      .text
                                                      .bold
                                                      .xl
                                                      .center
                                                      .make(),
                                            ),
                                            const VerticalDivider(
                                              thickness: 1,
                                            ),
                                            "${store.courseList![index].credits}"
                                                .text
                                                .bold
                                                .xl
                                                .center
                                                .make()
                                                .pOnly(right: 10),
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            blurRadius: 7,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                    ).pOnly(left: 8, right: 8, bottom: 12),
                                  );
                                },
                              ),
                            ).pOnly(left: 10, right: 10),
                      20.heightBox,
                      adding
                          ? CupertinoActivityIndicator()
                          : registered
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.popAndPushNamed(
                                        context, MyRoutes.addElectiveCourse);
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
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
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
                                          "Next"
                                              .text
                                              .xl2
                                              .bold
                                              .center
                                              .white
                                              .make(),
                                        ],
                                      )),
                                ).p16()
                              : GestureDetector(
                                  onTap: () {
                                    doEnrollment();
                                  },
                                  child: Container(
                                      width: 250,
                                      height: 50,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            blurRadius: 7,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.lock_circle,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          const VerticalDivider(
                                            color: Vx.white,
                                            thickness: 1,
                                          ),
                                          "Lock"
                                              .text
                                              .xl2
                                              .bold
                                              .center
                                              .white
                                              .make(),
                                        ],
                                      )),
                                ).p16(),
                    ],
                  )
                : const CupertinoActivityIndicator(
                    radius: 20,
                  ).centered().hFull(context)),
      ),
    );
  }
}
