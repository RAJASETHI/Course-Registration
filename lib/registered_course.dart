import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/routes.dart';

class RegisteredCourse extends StatelessWidget {
  const RegisteredCourse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(
          "Registered Course",
          style: TextStyle(
              // color: Colors.black,
              // fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        centerTitle: true,
        // backgroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          SizedBox(width: double.infinity),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "View Course",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text(
                    "Return to Home Page",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
