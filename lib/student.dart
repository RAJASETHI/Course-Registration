import 'dart:convert';

import 'package:velocity_x/velocity_x.dart';

import 'Utils/my_store.dart';

class StudentCatalog {
  static List<Student>? studentCatalog;
  Student getById(String id) =>
      // ignore: null_closures
      studentCatalog!.firstWhere((course) => course.userid == id, orElse: null);

  Student getByPos(int pos) => studentCatalog![pos];
}

class Student {
  String? userid;
  String? name;
  String? joining_year;
  String? branch;

  Student({
    this.userid,
    this.name,
    this.joining_year,
    this.branch,
  });

  Student copyWith({
    String? userid,
    String? name,
    String? joining_year,
    String? branch,
  }) {
    return Student(
      userid: userid ?? this.userid,
      name: name ?? this.name,
      joining_year: joining_year ?? this.joining_year,
      branch: branch ?? this.branch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'name': name,
      'joining_year': joining_year,
      'branch': branch,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      userid: map['userid'],
      name: map['name'],
      joining_year: map['joining_year'],
      branch: map['branch'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Student(userid: $userid, name: $name, joining_year: $joining_year, branch: $branch)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Student &&
        other.userid == userid &&
        other.name == name &&
        other.joining_year == joining_year &&
        other.branch == branch;
  }

  @override
  int get hashCode {
    return userid.hashCode ^
        name.hashCode ^
        joining_year.hashCode ^
        branch.hashCode;
  }
}

class SearchMutationStudent extends VxMutation<MyStore> {
  final String query;

  SearchMutationStudent(this.query);
  @override
  perform() {
    store!.studentListStore = query.length >= 1
        ? StudentCatalog.studentCatalog!
            .where((element) =>
                element.userid!.toLowerCase().contains(query.toLowerCase()) ||
                element.name!.toLowerCase().contains(query.toLowerCase()))
            .toList()
        : StudentCatalog.studentCatalog;
  }
}
