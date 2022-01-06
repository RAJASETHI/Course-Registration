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
bool saved = false;
bool adding = false;

class RegisteredCourse extends StatefulWidget {
  const RegisteredCourse({Key? key}) : super(key: key);

  @override
  State<RegisteredCourse> createState() => _RegisteredCourseState();
}

class _RegisteredCourseState extends State<RegisteredCourse> {
  final MyStore store = VxState.store;

  Future<void> fetchCourses() async {
    store.courseList?.clear();
    setState(() {});
    try {
      final Dio _dio = Dio();
      Response response = await _dio.post(
        'https://course-registration-lnmiit.herokuapp.com/course/getEnrolledCourses',
        data: {"student_id": store.student.userid},
      );
      CourseList.courseList = List.from(response.data)
          .map((itemMap) => Course.fromMap(itemMap))
          .toList();
      store.courseList = CourseList.courseList;
      if (CourseList.courseList!.isEmpty) {
        Fluttertoast.showToast(msg: "No course available.");
        Navigator.pop(context);
      }
      setState(() {});
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

      body: SafeArea(
        child: SingleChildScrollView(
          child: (CourseList.courseList != null &&
                  CourseList.courseList!.isNotEmpty)
              ? Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
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
                              CupertinoIcons.eyeglasses,
                              color: Colors.white,
                              size: 40,
                            ),
                            const VerticalDivider(
                              color: Vx.white,
                              thickness: 1,
                            ),
                            "Registered Courses"
                                .text
                                .xl4
                                .bold
                                .center
                                .white
                                .make()
                                .expand(),
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
                        ? const CupertinoActivityIndicator(
                            radius: 20,
                          ).centered().pOnly(top: 200)
                        : VxBuilder(
                            mutations: {SearchMutation},
                            builder: (context, _, __) => ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
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
                                          height: 70,
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
                                                        .xl
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
                                      ],
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
                    GestureDetector(
                      onTap: () => Navigator.popUntil(context,
                          ModalRoute.withName(MyRoutes.studentHomePage)),
                      child: Container(
                          width: 200,
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
                                CupertinoIcons.home,
                                color: Colors.white,
                                size: 30,
                              ),
                              const VerticalDivider(
                                color: Vx.white,
                                thickness: 1,
                              ),
                              "Go To Home".text.xl2.bold.center.white.make(),
                            ],
                          )),
                    ).p16(),
                  ],
                )
              : const CupertinoActivityIndicator(
                  radius: 20,
                ).centered().hFull(context),
        ),
      ),
    );
  }
}
