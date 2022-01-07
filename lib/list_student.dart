import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/edit_student.dart';
import 'package:flutter_application_1/student.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter_application_1/Utils/my_store.dart';
import 'package:google_fonts/google_fonts.dart';

import 'student.dart';

bool showLoading = false;

class StuDet extends StatefulWidget {
  @override
  State<StuDet> createState() => _StuDetState();
}

class _StuDetState extends State<StuDet> {
  final MyStore store = VxState.store;
  String branch = "CSE";
  List<String> branches = [
    "All",
    "CSE",
    "CCE",
    "ECE",
    "ME",
    "CSE Dual",
    "ECE Dual"
  ];
  TextEditingController joining_year = TextEditingController();

  _showPickerBranch() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                "Branch".text.bold.xl2.make().p12().centered(),
                ListView.builder(
                  itemCount: branches.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                        // leading: Icon(CupertinoIcons.person_alt_circle),
                        title: Text("${branches[index]}").centered(),
                        onTap: () async {
                          branch = "${branches[index]}";
                          setState(() {});
                          if (branch == "All")
                            fetchStudentList();
                          else
                            fetchStudentByBranch();
                          Navigator.pop(context);
                        });
                  },
                )
              ],
            ),
          );
        });
  }

  _showPickerSem() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    "Batch".text.bold.xl2.make().p12().centered(),
                    CupertinoFormSection(children: [
                      CupertinoTextFormFieldRow(
                        controller: joining_year,
                        placeholder: "Type Here",
                        textAlign: TextAlign.center,
                      ).centered(),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            fetchStudentByYear();
                          },
                          icon: const Icon(
                            CupertinoIcons.search,
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

  _showDialog(BuildContext context) {
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Filters'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 15.0),
            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _showPickerSem();
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      child: Text(
                        'Batch',
                        style: GoogleFonts.nunito(
                            fontSize: 20, color: Colors.blue),
                      ).centered(),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(50),
                        // border: Border.all(),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 7,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    // color: Colors.black,
                    thickness: 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _showPickerBranch();
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      child: Text(
                        'Branch',
                        style: GoogleFonts.nunito(
                            fontSize: 20, color: Colors.blue),
                      ).centered(),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(50),
                        // border: Border.all(),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 7,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text('Back'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> fetchStudentList() async {
    store.studentListStore?.clear();
    setState(() {});
    try {
      final Dio _dio = Dio();
      Response response = await _dio.get(
        'https://course-registration-lnmiit.herokuapp.com/student/list',
      );

      StudentCatalog.studentCatalog = List.from(response.data)
          .map((itemMap) => Student.fromMap(itemMap))
          .toList();

      store.studentListStore = StudentCatalog.studentCatalog;

      if (StudentCatalog.studentCatalog!.isEmpty) {
        Fluttertoast.showToast(msg: "No Student available.");
        Navigator.pop(context);
      }
      setState(() {});
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> fetchStudentByBranch() async {
    store.studentListStore!.clear();
    setState(() {});
    try {
      final Dio _dio = Dio();
      Response response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/student/getStudentsByBranch',
          data: {"Branch": branch});
      StudentCatalog.studentCatalog = List.from(response.data)
          .map((itemMap) => Student.fromMap(itemMap))
          .toList();

      store.studentListStore = StudentCatalog.studentCatalog;

      if (StudentCatalog.studentCatalog!.isEmpty) {
        Fluttertoast.showToast(msg: "No Student available.");
        Navigator.pop(context);
      }
      setState(() {});
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> fetchStudentByYear() async {
    store.studentListStore!.clear();
    setState(() {});
    try {
      final Dio _dio = Dio();
      Response response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/student/getStudentsByYear',
          data: {"joining_year": joining_year.text});
      StudentCatalog.studentCatalog = List.from(response.data)
          .map((itemMap) => Student.fromMap(itemMap))
          .toList();

      store.studentListStore = StudentCatalog.studentCatalog;

      if (StudentCatalog.studentCatalog!.isEmpty) {
        Fluttertoast.showToast(msg: "No course available.");
        Navigator.pop(context);
      }
      setState(() {});
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> deleteStudent(String userID) async {
    setState(() {});
    try {
      final Dio _dio = Dio();
      Response response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/student/delete',
          data: {"userId": userID});
      print('Deleting: ${response.data}');

      if (response.data.toString() == "success") {
        print("Student successfully deleted");
        Fluttertoast.showToast(msg: "Student successfully deleted");
        await fetchStudentList();
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
    fetchStudentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: (StudentCatalog.studentCatalog != null &&
                StudentCatalog.studentCatalog!.length > 0)
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(CupertinoIcons.chevron_back),
                                color: Vx.white,
                                iconSize: 30,
                              ),
                              10.widthBox,
                              const VerticalDivider(
                                color: Vx.white,
                                thickness: 1,
                              ),
                              "Students"
                                  .text
                                  .xl5
                                  .bold
                                  .center
                                  .white
                                  .make()
                                  .expand(),
                              10.widthBox,
                              const VerticalDivider(
                                color: Vx.white,
                                thickness: 1,
                              ),
                              IconButton(
                                onPressed: () => _showDialog(
                                    context), //_showDialog(context),
                                icon: const Icon(
                                  CupertinoIcons.option,
                                  color: Vx.white,
                                ),
                                iconSize: 30,
                              ),
                            ],
                          )).centered(),
                    ],
                  ),
                  CupertinoSearchTextField(
                    placeholder: "Search Student",
                    onChanged: (value) {
                      SearchMutationStudent(value);
                    },
                  ).pLTRB(20, 20, 20, 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      "User ID".text.bold.caption(context).make(),
                      "Student Name".text.bold.caption(context).make(),
                      "Branch".text.bold.caption(context).make(),
                    ],
                  ),
                  10.heightBox,
                  showLoading
                      ? const CupertinoActivityIndicator(radius: 20,).centered().pOnly(top: 200)
                      : VxBuilder(
                          mutations: {SearchMutationStudent},
                          builder: (context, _, __) => ListView.builder(
                            shrinkWrap: true,
                            itemCount: store.studentListStore!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            "${store.studentListStore?[index].userid}"
                                                .text
                                                .bold
                                                .size(12)
                                                .center
                                                .make()
                                                .pOnly(left: 10),
                                            const VerticalDivider(
                                              thickness: 1,
                                            ),
                                            "${store.studentListStore?[index].name}"
                                                .text
                                                .bold
                                                .size(15)
                                                .center
                                                .make(),
                                            const VerticalDivider(
                                              thickness: 1,
                                            ),
                                            "${store.studentListStore?[index].branch}"
                                                .text
                                                .bold
                                                .size(12)
                                                .center
                                                .make()
                                                .pOnly(right: 10),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return EditStudent(
                                                      student_: store
                                                              .studentListStore![
                                                          index]);
                                                }),
                                              );
                                              setState(() {});
                                            },
                                            icon: const Icon(CupertinoIcons
                                                .pencil_ellipsis_rectangle),
                                            iconSize: 30,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                showLoading = true;

                                                deleteStudent(store
                                                    .studentListStore![index]
                                                    .userid
                                                    .toString());
                                              },
                                              icon: const Icon(CupertinoIcons.delete))
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
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                ).p8(),
                              );
                            },
                          ),
                        ).pOnly(left: 10, right: 10).expand(),
                ],
              )
            : const Center(
                child: const CircularProgressIndicator(
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }
}
