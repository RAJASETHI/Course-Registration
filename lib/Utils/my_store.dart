import 'package:flutter_application_1/course_availability_class.dart';
import 'package:velocity_x/velocity_x.dart';

import '../admin.dart';
import '../course.dart';
import '../student.dart';

class MyStore extends VxStore {
  List<Course>? courseList;
  List<Student>? studentListStore;
  List<CourseAvlb>? courseAvlbList;
  late Student student;
  late Admin admin;

  MyStore() {
    student = Student();
    admin = Admin();
  }
}
