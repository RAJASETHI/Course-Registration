import 'package:flutter/material.dart';
import 'package:flutter_application_1/student_home_page.dart';
import 'package:flutter_application_1/add_admin.dart';
import 'package:flutter_application_1/admin_home.dart';
import 'package:flutter_application_1/add_course_admin.dart';
import 'package:flutter_application_1/add_course_core.dart';
import 'package:flutter_application_1/add_course_elective.dart';
import 'package:flutter_application_1/add_student.dart';
import 'package:flutter_application_1/edit_courses.dart';
import 'package:flutter_application_1/edit_student.dart';
import 'package:flutter_application_1/list_student.dart';
import 'package:flutter_application_1/manage_student.dart';
import 'package:flutter_application_1/registered_course.dart';
import 'package:flutter_application_1/view_courses.dart';
import 'login.dart';
import 'package:flutter_application_1/Utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdmHome(),
      routes: {
        MyRoutes.loginPage: (context) => LoginPage(),
        MyRoutes.adminHomePage: (context) => AdmHome(),
        MyRoutes.addStudent: (context) => AddStudent(),
        MyRoutes.viewStudent: (context) => ManageStudent(),
        MyRoutes.listStudent: (context) => StuDet(),
        MyRoutes.editStudent: (context) => EditStudent(),
        MyRoutes.addCourse: (context) => AddCourseAdm(),
        MyRoutes.editCourse: (context) => EditCourses(),
        MyRoutes.viewCourse: (context) => ViewCourses(),
        MyRoutes.addAdmin: (context) => AddAdmin(),
        MyRoutes.studentHomePage: (context) => StuHome(),
        MyRoutes.addElectiveCourse: (context) => AddCourse(),
        MyRoutes.addCoreCourse: (context) => AddCourseCore(),
        MyRoutes.viewRegisteredCourse: (context) => RegisteredCourse(),
      },
    );
  }
}
