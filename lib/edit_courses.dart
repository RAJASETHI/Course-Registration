import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/src/extensions/num_ext.dart';
import 'package:velocity_x/src/extensions/string_ext.dart';
import 'package:velocity_x/src/flutter/padding.dart';
import 'package:velocity_x/velocity_x.dart';

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.grey,
  //hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 16.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

class EditCourses extends StatefulWidget {
  const EditCourses({Key? key}) : super(key: key);

  @override
  State<EditCourses> createState() => _EditCoursesState();
}

class _EditCoursesState extends State<EditCourses> {
  @override
  Widget build(BuildContext context) {
    TextEditingController dateinput = TextEditingController();

    @override
    void initState() {
      dateinput.text = ""; //set the initial value of text field
      super.initState();
    }

    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(
          "Edit Course",
          style: TextStyle(
              // color: Colors.black,
              // fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        centerTitle: true,
        // backgroundColor: Colors.grey,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: null,
      //   child: Icon(Icons.add, size: 35),
      // ),
      body: SingleChildScrollView(
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Course Id",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: kTextFieldDecoration,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Course Name",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: kTextFieldDecoration,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Course Type",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: kTextFieldDecoration,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Course Credit",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: kTextFieldDecoration,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Branch",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: kTextFieldDecoration,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Semester",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: kTextFieldDecoration,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Seats",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: kTextFieldDecoration,
                    ),
                  )
                ],
              ),
            ),
            20.heightBox,
            ElevatedButton(
                onPressed: null,
                child: Text(
                  "Udpdate Info",
                  style: TextStyle(color: Colors.black),
                )).centered()
          ],
        ),
      ),
    );
  }
}
