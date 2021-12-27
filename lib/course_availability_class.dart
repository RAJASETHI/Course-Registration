import 'dart:convert';

class CourseAvlbList {
  static List<CourseAvlb>? courseAvlbList;
}

class CourseAvlb {
  String course_id = "";
  int semester = 0;
  String branch = "";
  int availableseats = 0;
  int totalseats = 0;
  String grp = "";

  CourseAvlb({
    required this.course_id,
    required this.semester,
    required this.branch,
    required this.availableseats,
    required this.totalseats,
    required this.grp,
  });

  CourseAvlb copyWith({
    String? course_id,
    int? semester,
    String? branch,
    int? availableseats,
    int? totalseats,
    String? grp,
  }) {
    return CourseAvlb(
      course_id: course_id ?? this.course_id,
      semester: semester ?? this.semester,
      branch: branch ?? this.branch,
      availableseats: availableseats ?? this.availableseats,
      totalseats: totalseats ?? this.totalseats,
      grp: grp ?? this.grp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'course_id': course_id,
      'semester': semester,
      'branch': branch,
      'availableseats': availableseats,
      'totalseats': totalseats,
      'grp': grp,
    };
  }

  factory CourseAvlb.fromMap(Map<String, dynamic> map) {
    return CourseAvlb(
      course_id: map['course_id'] ?? '',
      semester: map['semester']?.toInt() ?? 0,
      branch: map['branch'] ?? '',
      availableseats: map['availableseats']?.toInt() ?? 0,
      totalseats: map['totalseats']?.toInt() ?? 0,
      grp: map['grp'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseAvlb.fromJson(String source) =>
      CourseAvlb.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CourseAvlb(course_id: $course_id, semester: $semester, branch: $branch, availableseats: $availableseats, totalseats: $totalseats, grp: $grp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CourseAvlb &&
        other.course_id == course_id &&
        other.semester == semester &&
        other.branch == branch &&
        other.availableseats == availableseats &&
        other.totalseats == totalseats &&
        other.grp == grp;
  }

  @override
  int get hashCode {
    return course_id.hashCode ^
        semester.hashCode ^
        branch.hashCode ^
        availableseats.hashCode ^
        totalseats.hashCode ^
        grp.hashCode;
  }
}
