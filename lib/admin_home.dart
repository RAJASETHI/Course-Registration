import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/routes.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class AdmHome extends StatefulWidget {
  @override
  State<AdmHome> createState() => _AdmHomeState();
}

class _AdmHomeState extends State<AdmHome> {
  TextEditingController dateinput = TextEditingController();

  

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () =>
                    Navigator.popAndPushNamed(context, MyRoutes.loginPage),
                icon: Icon(Icons.logout_outlined))
          ],
          title: Text("Admin Panel"),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  "Admin Funtions",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
              "Manage Admins".text.xl3.bold.make().p12(),
              ListTile(
                // subtitle: "You can a".text.make(),
                title: "Add Admins".text.xl.make(),
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.addAdmin);
                },
              ),
              "Manage Students".text.xl3.bold.make().p12(),
              ListTile(
                // subtitle: "You can a".text.make(),
                title: "Add Students".text.xl.make(),
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.addStudent);
                },
              ),
              ListTile(
                // subtitle: "You can a".text.make(),
                title: "View Students".text.xl.make(),
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.viewStudent);
                },
              ),
              "Manage Courses".text.xl3.bold.make().p12(),
              ListTile(
                // subtitle: "You can a".text.make(),
                title: "Add Courses".text.xl.make(),
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.addCourse);
                },
              ),
              ListTile(
                // subtitle: "You can a".text.make(),
                title: "View Courses".text.xl.make(),
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.viewCourse);
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 100.0,
                    backgroundImage: NetworkImage(
                        "https://media.istockphoto.com/photos/learn-to-love-yourself-first-picture-id1291208214?b=1&k=20&m=1291208214&s=170667a&w=0&h=sAq9SonSuefj3d4WKy4KzJvUiLERXge9VgZO-oqKUOo="),
                  ).p12(),
                  const Text(
                    'Jenny Kendle',
                    style: TextStyle(
                        fontFamily: 'Pacifico',
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  ),
                  HeightBox(20),
                  Text(
                    'Jenny1992@lnmiit.ac.in',
                    style: TextStyle(
                        fontFamily: 'SourceSerifPro',
                        color: Colors.black,
                        fontSize: 22.0),
                  ),
                  SizedBox(
                    height: 20.0,
                    width: 150.0,
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                  HeightBox(20),
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        // icon: Icon(Icons.security),
                        hintText: 'New Password',
                        labelText: 'Change Password',
                      ),
                      onSaved: (String? value) {},
                    ),
                  ),
                  // SizedBox(
                  //   width: 250,
                  //   child: TextField(
                  //     controller:
                  //         dateinput, //editing controller of this TextField
                  //     decoration: InputDecoration(
                  //         icon: Icon(Icons.calendar_today), //icon of text field
                  //         labelText: "Change DOB" //label text of field
                  //         ),
                  //     readOnly:
                  //         true, //set it true, so that user will not able to edit text
                  //     onTap: () async {
                  //       DateTime? pickedDate = await showDatePicker(
                  //           context: context,
                  //           initialDate: DateTime.now(),
                  //           firstDate: DateTime(
                  //               2000), //DateTime.now() - not to allow to choose before today.
                  //           lastDate: DateTime(2101));

                  //       if (pickedDate != null) {
                  //         print(
                  //             pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  //         String formattedDate =
                  //             DateFormat('yyyy-MM-dd').format(pickedDate);
                  //         print(
                  //             formattedDate); //formatted date output using intl package =>  2021-03-16
                  //         //you can implement different kind of Date Format here according to your requirement

                  //         setState(() {
                  //           dateinput.text =
                  //               formattedDate; //set output date to TextField value.
                  //         });
                  //       } else {
                  //         print("Date is not selected");
                  //       }
                  //     },
                  //   ),
                  // ),
                  HeightBox(20),
                  ElevatedButton(
                      onPressed: null,
                      child: Text(
                        "Udpdate Info",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
