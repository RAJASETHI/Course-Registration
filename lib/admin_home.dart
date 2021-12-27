import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';
import 'Utils/my_store.dart';
import 'course_availability_class.dart';

bool showLoading = false;

class AdmHome extends StatefulWidget {
  @override
  State<AdmHome> createState() => _AdmHomeState();
}

class _AdmHomeState extends State<AdmHome> {
  TextEditingController oldPassw = TextEditingController();
  TextEditingController newPass = TextEditingController();
  List<String> sems = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  List<String> branches = ["CSE", "CCE", "ECE", "ME", "CSE Dual", "ECE Dual"];
  String semester = "";
  String branch = "";
  final MyStore store = VxState.store;

  @override
  void initState() {
    super.initState();
  }

  Future<void> updatePassword() async {
    try {
      final dio = Dio();
      Response response = await dio.post(
          'https://course-registration-lnmiit.herokuapp.com/admin/updatePassword',
          data: {
            "userId": store.admin.userId,
            "passw": oldPassw.text,
            "newpassw": newPass.text
          });
      if (response.data.toString() == "Success") {
        String msg = "Password successfully changed.";
        print(msg);
        Fluttertoast.showToast(msg: msg);
        oldPassw.clear();
        newPass.clear();
      } else {
        String msg = "Password not changed.";
        print(msg);
        Fluttertoast.showToast(msg: msg);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }

  Future<void> fetchCoursesFromSem() async {
    showLoading = true;
    setState(() {});
    try {
      final Dio _dio = Dio();
      Response response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/course/availableCoursesInSem',
          data: {"semester": semester});
      print(response.data);
      if (response.data.toString() != "[]") {
        print("Here");
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
    store.courseAvlbList?.clear();
    setState(() {});
  }

  Future<void> fetchCoursesFromBranch() async {
    showLoading = true;
    setState(() {});
    try {
      final Dio _dio = Dio();
      Response response = await _dio.post(
          'https://course-registration-lnmiit.herokuapp.com/course/availableCoursesForBranch',
          data: {"branch": branch});
      print("here");
      if (response.data.toString() != "[]") {
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
    store.courseAvlbList?.clear();
    setState(() {});
  }

  _showPickerSemester() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                "Semester".text.bold.xl2.make().p12().centered(),
                ListView.builder(
                  itemCount: sems.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                        // leading: Icon(CupertinoIcons.person_alt_circle),
                        title: Text(sems[index]).centered(),
                        onTap: () async {
                          semester = sems[index];
                          setState(() {});
                          Navigator.pop(context);
                          await fetchCoursesFromSem();
                        });
                  },
                )
              ],
            ),
          );
        });
  }

  _showPickerBranch() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
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
                        title: Text(branches[index]).centered(),
                        onTap: () async {
                          branch = branches[index];
                          setState(() {});
                          Navigator.pop(context);
                          await fetchCoursesFromBranch();
                        });
                  },
                )
              ],
            ),
          );
        });
  }

  _showPickerChangePassword() {
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
                    "Update Password".text.bold.xl2.make().p12().centered(),
                    CupertinoFormSection(children: [
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: oldPassw,
                          obscureText: true,
                          placeholder: "Old Password",
                          // prefix: "Email".text.make(),
                          padding: const EdgeInsets.only(left: 0),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Old Password can't be empty";
                            }
                            return null;
                          },
                          prefix: "Old Password ".text.caption(context).make(),
                        ),
                      ),
                      CupertinoFormRow(
                        //padding: EdgeInsets.only(left: 0),
                        child: CupertinoTextFormFieldRow(
                          controller: newPass,
                          obscureText: true,
                          placeholder: "New Password",
                          // prefix: "Email".text.make(),
                          padding: const EdgeInsets.only(left: 0),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "New Password can't be empty";
                            }
                            return null;
                          },
                          prefix: "New Password ".text.caption(context).make(),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            updatePassword();
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
        child: showLoading
            ? const CupertinoActivityIndicator(
                radius: 20,
              ).centered()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
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
                                "Admin Panel"
                                    .text
                                    .xl4
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
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed:
                                          _showPickerChangePassword, //_showDialog(context),
                                      icon: const Icon(
                                        CupertinoIcons.settings,
                                        color: Vx.white,
                                      ),
                                      iconSize: 30,
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          Navigator.popAndPushNamed(
                                              context, MyRoutes.loginPage),
                                      icon: const Icon(
                                        CupertinoIcons.power,
                                        color: Vx.white,
                                      ),
                                      iconSize: 30,
                                    ),
                                  ],
                                ),
                              ],
                            )).centered(),
                      ],
                    ),
                    Container(
                        width: 250,
                        height: 50,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(
                              CupertinoIcons.person_crop_square,
                              color: Colors.black,
                              size: 25,
                            ),
                            const VerticalDivider(
                              color: Vx.black,
                              thickness: 1,
                            ),
                            "Manage Admins".text.xl2.bold.center.black.make(),
                          ],
                        )).centered().p16(),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, MyRoutes.addAdmin),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
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
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.add_circled_solid),
                            20.widthBox,
                            "Add Admin".text.xl2.make()
                          ],
                        ).pOnly(left: 20),
                      ),
                    ).px16(),
                    Container(
                        width: 250,
                        height: 50,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(
                              CupertinoIcons.person_3,
                              color: Colors.black,
                              size: 25,
                            ),
                            const VerticalDivider(
                              color: Vx.black,
                              thickness: 1,
                            ),
                            "Manage Students".text.xl2.bold.center.black.make(),
                          ],
                        )).centered().p16(),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, MyRoutes.addStudent),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
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
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.add_circled_solid),
                            20.widthBox,
                            "Add Student".text.xl2.make()
                          ],
                        ).pOnly(left: 20),
                      ).pOnly(bottom: 20),
                    ).px16(),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, MyRoutes.listStudent),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
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
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.eyeglasses),
                            20.widthBox,
                            "View Student".text.xl2.make()
                          ],
                        ).pOnly(left: 20),
                      ),
                    ).px16(),
                    Container(
                        width: 250,
                        height: 50,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(
                              CupertinoIcons.book_circle,
                              color: Colors.black,
                              size: 25,
                            ),
                            const VerticalDivider(
                              color: Vx.black,
                              thickness: 1,
                            ),
                            "Manage Courses".text.xl2.bold.center.black.make(),
                          ],
                        )).centered().p16(),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, MyRoutes.addCourse),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
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
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.add_circled_solid),
                            20.widthBox,
                            "Add Course".text.xl2.make()
                          ],
                        ).pOnly(left: 20),
                      ).pOnly(bottom: 20),
                    ).px16(),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, MyRoutes.viewCourse),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
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
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.eyeglasses),
                            20.widthBox,
                            "View All Courses".text.xl2.make()
                          ],
                        ).pOnly(left: 20),
                      ).pOnly(bottom: 20),
                    ).px16(),
                    GestureDetector(
                      onTap: _showPickerBranch,
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
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
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.eyeglasses),
                            20.widthBox,
                            "Courses for Branch".text.xl2.make()
                          ],
                        ).pOnly(left: 20),
                      ).pOnly(bottom: 20),
                    ).px16(),
                    GestureDetector(
                      onTap: () async {
                        await _showPickerSemester();
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
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
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.eyeglasses),
                            20.widthBox,
                            "Courses for Semester".text.xl2.make()
                          ],
                        ).pOnly(left: 20),
                      ),
                    ).pOnly(left: 16, right: 16, bottom: 16)
                  ],
                ),
              ),
      ),
    );
  }
}
