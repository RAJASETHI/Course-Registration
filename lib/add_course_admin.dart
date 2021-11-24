import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

class AddCourseAdm extends StatelessWidget {
  const AddCourseAdm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(
          "Add Course",
          style: TextStyle(
              // color: Colors.black,
              // fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        centerTitle: true,
        // backgroundColor: Colors.grey,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add, size: 35),
      ),
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
            )
          ],
        ),
      ),
    );
  }
}
