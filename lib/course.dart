import 'dart:convert';

import 'package:velocity_x/velocity_x.dart';

import 'Utils/my_store.dart';

class CourseList {
  static List<Course>? courseList;
  Course getById(String id) =>
      // ignore: null_closures
      courseList!.firstWhere((course) => course.course_id == id, orElse: null);

  Course getByPos(int pos) => courseList![pos];
}

class Course {
  String course_id = "";
  String coursename = "";
  String type = "";
  int credits = 0;
  int availableseats = 0;
  String grp = "";
  Course({
    required this.course_id,
    required this.coursename,
    required this.type,
    required this.credits,
    required this.availableseats,
    required this.grp,
  });

  Course copyWith({
    String? course_id,
    String? coursename,
    String? type,
    int? credits,
    int? availableseats,
    String? grp,
  }) {
    return Course(
      course_id: course_id ?? this.course_id,
      coursename: coursename ?? this.coursename,
      type: type ?? this.type,
      credits: credits ?? this.credits,
      availableseats: availableseats ?? this.availableseats,
      grp: grp ?? this.grp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'course_id': course_id,
      'coursename': coursename,
      'type': type,
      'credits': credits,
      'availableseats': availableseats,
      'grp': grp,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      course_id: map['course_id'] ?? '',
      coursename: map['coursename'] ?? '',
      type: map['type'] ?? '',
      credits: map['credits']?.toInt() ?? 0,
      availableseats: map['availableseats']?.toInt() ?? 0,
      grp: map['grp'] ?? '',
    );
  }

  

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Course(course_id: $course_id, coursename: $coursename, type: $type, credits: $credits, availableseats: $availableseats, grp: $grp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Course &&
        other.course_id == course_id &&
        other.coursename == coursename &&
        other.type == type &&
        other.credits == credits &&
        other.availableseats == availableseats &&
        other.grp == grp;
  }

  @override
  int get hashCode {
    return course_id.hashCode ^
        coursename.hashCode ^
        type.hashCode ^
        credits.hashCode ^
        availableseats.hashCode ^
        grp.hashCode;
  }
}

class SearchMutation extends VxMutation<MyStore> {
  final String query;

  SearchMutation(this.query);
  @override
  perform() {
    store!.courseList = query.length >= 1
        ? CourseList.courseList!
            .where((element) =>
                element.course_id.toLowerCase().contains(query.toLowerCase()) ||
                element.coursename.toLowerCase().contains(query.toLowerCase()))
            .toList()
        : CourseList.courseList;
  }
}
