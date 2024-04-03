import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const minID = 10000;
const maxID = 99999;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  late int ownRoomID;
  late TextEditingController ownRoomController;

  @override
  initState() {
    super.initState();
    ownRoomID = minID + Random().nextInt((maxID + 1) - minID);
     ownRoomController = TextEditingController.fromValue(TextEditingValue(text: ownRoomID.toString()));
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size(200, double.infinity)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                TextField(keyboardType: TextInputType.number),
                SizedBox(height: 6,),
                ElevatedButton(onPressed: null, child: Text("Join Room"))
              ]),

              Column(children: [
                TextField(keyboardType: TextInputType.number, controller: ownRoomController,),
                SizedBox(height: 6,),
                ElevatedButton(onPressed: null, child: Text("Create your own room"))
              ])
            ],
          ),
        ),
      ),
    );
  }
}