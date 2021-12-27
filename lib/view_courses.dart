import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_available_course.dart';
import 'package:flutter_application_1/edit_courses.dart';
import 'package:flutter_application_1/view_avlb_courses.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter_application_1/Utils/my_store.dart';
import 'package:flutter_application_1/Utils/routes.dart';
import 'package:flutter_application_1/course.dart';

import 'course_availability_class.dart';

bool showLoading = false;

class ViewCourses extends StatefulWidget {
  @override
  State<ViewCourses> createState() => _ViewCoursesState();
}

class _ViewCoursesState extends State<ViewCourses> {
  final MyStore store = VxState.store;

  Future<void> fetchCoursesFromCourseID(String courseID) async {
    showLoading = true;
    setState(() {});
    try {
      final Dio _dio = Dio();
      Response response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/course/courseAvailibility',
          data: {"course_id": courseID});
      print("here");
      if (response.data.toString() != "No Data Available") {
        CourseAvlbList.courseAvlbList = List.from(response.data)
            .map((itemMap) => CourseAvlb.fromMap(itemMap))
            .toList();
        store.courseAvlbList = CourseAvlbList.courseAvlbList;
        await Navigator.pushNamed(context, MyRoutes.viewAvlbCourses);
      } else {
        print("No Data");
        Fluttertoast.showToast(msg: "No Availablability!");
      }
    } catch (e) {
      print("Error:" + e.toString());
    }
    showLoading = false;

    store.courseList?.clear;
    setState(() {});
  }

  Future<void> fetchCourses() async {
    try {
      store.courseList?.clear();
      setState(() {});
      final Dio _dio = Dio();
      Response response = await _dio.get(
        'https://course-registration-lnmiit.herokuapp.com/course/list',
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      CourseList.courseList = List.from(response.data)
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
      // setState(() {});
      Navigator.pop(context);
    }
  }

  Future<void> deleteCourse(String courseID) async {
    setState(() {});
    try {
      final Dio _dio = Dio();
      Response response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/course/deleteCourse',
          data: {"course_id": courseID});
      print('Deleting: ${response.data}');

      if (response.data.toString() == "success") {
        print("Course successfully deleted");
        Fluttertoast.showToast(msg: "Course successfully deleted");
        await fetchCourses();
      } else {
        print("Something went wrong");
        Fluttertoast.showToast(msg: "Something went wrong");
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
    showLoading = false;
    setState(() {});
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
      backgroundColor: Colors.white,
      body: SafeArea(
          child: (CourseList.courseList != null &&
                  CourseList.courseList!.length > 0)
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 65,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                bottomLeft: Radius.circular(30),
                                topRight: Radius.circular(0),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(CupertinoIcons.chevron_back),
                                  color: Vx.white,
                                  iconSize: 30,
                                ),
                                const VerticalDivider(
                                  color: Vx.white,
                                  thickness: 1,
                                ),
                                20.widthBox,
                                "Courses".text.xl5.bold.white.make().expand(),
                              ],
                            )).centered(),
                      ],
                    ),
                    CupertinoSearchTextField(
                      placeholder: "Search Course",
                      onChanged: (value) => SearchMutation(value),
                    ).pLTRB(20, 20, 20, 40),
                    showLoading
                        ? const CupertinoActivityIndicator(
                            radius: 20,
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
                                    child: Column(
                                      children: [
                                        "${store.courseList![index].coursename} (${store.courseList![index].course_id})"
                                            .text
                                            .bold
                                            .xl
                                            .center
                                            .make(),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditCourses(
                                                            course: store
                                                                    .courseList![
                                                                index]),
                                                  ),
                                                );
                                                setState(() {});
                                              },
                                              icon: const Icon(CupertinoIcons
                                                  .pencil_ellipsis_rectangle),
                                              iconSize: 30,
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddAvlbCourse(
                                                            course: store
                                                                    .courseList![
                                                                index]),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                  CupertinoIcons.add_circled),
                                              iconSize: 30,
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                await fetchCoursesFromCourseID(
                                                    store.courseList![index]
                                                        .course_id);
                                                store.courseAvlbList?.clear();
                                              },
                                              icon: const Icon(
                                                  CupertinoIcons.eye),
                                              iconSize: 30,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  showLoading = true;

                                                  deleteCourse(store
                                                      .courseList![index]
                                                      .course_id);
                                                },
                                                icon: const Icon(
                                                    CupertinoIcons.delete))
                                          ],
                                        )
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
                                  ).p12(),
                                );
                              },
                            ),
                          ).pOnly(left: 10, right: 10).expand(),
                  ],
                )
              : const CupertinoActivityIndicator(
                  radius: 25,
                ).centered().hFull(context)),
    );
  }
}
