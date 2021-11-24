import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';

class StuDet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            // backgroundColor: Colors.grey,
            centerTitle: true,
            title: Text(
              "Student",
              style: TextStyle(fontSize: 25),
            ),
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
              child: ListView(
            children: [
              10.heightBox,
              CupertinoSearchTextField(
                      // padding: EdgeInsets.all(16),
                      )
                  .p16(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      children: [
                        Text(
                          "Rahul Gupta-22UCS007",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, MyRoutes.editStudent);
                              },
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.lightBlue[200]),
                            ),
                            TextButton(
                              onPressed: null,
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.red),
                            )
                          ],
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ])),
              ),
            ],
          ))),
    );
  }
}
