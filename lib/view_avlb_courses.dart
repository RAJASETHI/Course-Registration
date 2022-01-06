import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_available_course.dart';
import 'package:flutter_application_1/edit_courses.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter_application_1/Utils/my_store.dart';
import 'package:flutter_application_1/Utils/routes.dart';
import 'package:flutter_application_1/course.dart';

import 'course_availability_class.dart';

bool showLoading = false;

class ViewAvlbCourses extends StatefulWidget {
  const ViewAvlbCourses({Key? key}) : super(key: key);
  @override
  State<ViewAvlbCourses> createState() => _ViewAvlbCoursesState();
}

class _ViewAvlbCoursesState extends State<ViewAvlbCourses> {
  final MyStore store = VxState.store;
  TextEditingController newSeats = TextEditingController();

  Future<void> updateSeats(CourseAvlb courseAvlb) async {
    // store.courseList?.clear();
    setState(() {
      showLoading = true;
    });
    try {
      final Dio _dio = Dio();
      Response response = await _dio.post(
        'https://course-registration-lnmiit.herokuapp.com/course/updateTotalSeats',
        data: {
          "branch": courseAvlb.branch,
          "semester": courseAvlb.semester,
          "course_id": courseAvlb.course_id,
          "totalSeats": newSeats.text
        },
      );
      if (response.data.toString() == "success")
        courseAvlb.totalseats = int.parse(newSeats.text);
      else {
        print("Not able to update");
        Fluttertoast.showToast(msg: "Not able to update");
      }
      setState(() {
        showLoading = false;
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Some error occurred");
      showLoading = false;
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _showPickerChangeSeats(CourseAvlb courseAvlb) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius:
                const BorderRadius.vertical(top: const Radius.circular(25.0))),
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    "Update Total Seats".text.bold.xl2.make().p12().centered(),
                    CupertinoFormSection(children: [
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: newSeats,
                          style: GoogleFonts.poppins(),
                          placeholder: "Enter total seats",
                          // prefix: "Email".text.make(),
                          padding: const EdgeInsets.only(left: 0),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Total seats can't be empty";
                            }
                            return null;
                          },
                          prefix: "Total Seats ".text.caption(context).make(),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            updateSeats(courseAvlb);
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
        child: (CourseAvlbList.courseAvlbList != null &&
                CourseAvlbList.courseAvlbList!.isNotEmpty)
            ? SingleChildScrollView(
                child: Column(
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
                                "Available Courses"
                                    .text
                                    .xl4
                                    .bold
                                    .white
                                    .make()
                                    .expand(),
                              ],
                            )).centered(),
                      ],
                    ),
                    20.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        "Course ID".text.bold.caption(context).make(),
                        "Semester".text.bold.caption(context).make(),
                        "Branch".text.bold.caption(context).make(),
                        "Group".text.bold.caption(context).make(),
                      ],
                    ).px12(),
                    showLoading
                        ? const CupertinoActivityIndicator(
                            radius: 20,
                          ).hHalf(context)
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: store.courseAvlbList!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          store.courseAvlbList![index].course_id.toString()
                                              .text
                                              .bold
                                              .center
                                              .make()
                                              .pOnly(left: 10),
                                          const VerticalDivider(
                                            thickness: 1,
                                          ),
                                          store.courseAvlbList![index].semester.toString()
                                              .text
                                              .bold
                                              .center
                                              .make(),
                                          const VerticalDivider(
                                            thickness: 1,
                                          ),
                                          store.courseAvlbList![index].branch.toString()
                                              .text
                                              .bold
                                              .center
                                              .make()
                                              .pOnly(right: 10),
                                          const VerticalDivider(
                                            thickness: 1,
                                          ),
                                          store.courseAvlbList![index].grp.toString()
                                              .text
                                              .bold
                                              .center
                                              .make()
                                              .pOnly(right: 10),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    Container(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(30),
                                      ),
                                      child:
                                          "Available Seats: ${store.courseAvlbList![index].availableseats.toString()}"
                                              .text
                                              .center
                                              .white
                                              .make(),
                                    ),
                                    const Divider(),
                                    GestureDetector(
                                      onTap: () => _showPickerChangeSeats(
                                          store.courseAvlbList![index]),
                                      child: Container(
                                        height: 30,
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            "Total Seats: ${store.courseAvlbList![index].totalseats.toString()}"
                                                .text
                                                .center
                                                .white
                                                .make(),
                                                VerticalDivider(),
                                            const Icon(
                                              CupertinoIcons.pencil_circle,
                                              color: Vx.white,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
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
                              ).p8();
                            },
                          ).pOnly(left: 10, right: 10),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }
}
