import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';

class ManageStudent extends StatelessWidget {
  const ManageStudent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "View Student",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Select Semester:",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                DropdownButton<String>(
                  hint: const Text(
                    "Tap to expand",
                  ),
                  borderRadius: BorderRadius.circular(30),
                  // isDense: true,
                  items: <String>[
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '10'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                )
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Select Branch:",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                DropdownButton<String>(
                  hint: const Text(
                    "Tap to expand",
                  ),
                  // elevation: 100,
                  borderRadius: BorderRadius.circular(30),
                  items: <String>[
                    'CSE',
                    'CSE - Dual Degree',
                    'ECE',
                    'ECE - Dual Degree',
                    'CCE',
                    'ME'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ]),
              HeightBox(20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MyRoutes.listStudent);
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(),
                  ))
            ],
          )),
    );
  }
}
