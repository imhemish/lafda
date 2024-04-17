import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lafda/database.dart';
import 'package:lafda/pages/room.dart';


var db = DatabaseService();

const minID = 10000;
const maxID = 99999;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  final ownRoomController = TextEditingController();
  final _joinRoomController = TextEditingController();
  final _ownRoomNameController = TextEditingController();

  void putRandomRoomNumber() async {
    late int ownRoomID;

    while (true) {
      ownRoomID = minID + Random().nextInt((maxID + 1) - minID);
      var docs = (await FirebaseFirestore.instance.collection("rooms").get()).docs;
      var unique = docs.every((element) => element.id != ownRoomID.toString());
      if (unique) {
        break;
      }
    }

    ownRoomController.text = ownRoomID.toString();

  }

  void _joinRoom() {
    if (_joinRoomController.text.isNumericOnly && _joinRoomController.text.length == 5) {
      db.joinRoom(_joinRoomController.text).then((roomName) => (Get.to(RoomPage(_joinRoomController.text, roomName))));
    }
    else {
      Get.snackbar("Error", "Room ID should be 5 digit number");
    }
  }

  void _createRoom() {
    if (ownRoomController.text.isNumericOnly && ownRoomController.text.length == 5) {
      db.createRoom(ownRoomController.text, _ownRoomNameController.text).then((value) => (Get.to(RoomPage(ownRoomController.text, _ownRoomNameController.text))));
    }
    else {
      Get.snackbar("Error", "Room ID should be 5 digit number");
    }
  }



  @override
  initState() {
    super.initState();
    putRandomRoomNumber();
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
                TextField(keyboardType: TextInputType.number, controller: _joinRoomController, textAlign: TextAlign.center, decoration: const InputDecoration(filled: true, border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8))))),
                const SizedBox(height: 6,),
                ElevatedButton(onPressed: _joinRoom, child: const Text("Join Room"))
              ]),

              Column(children: [
                TextField(keyboardType: TextInputType.number, controller: ownRoomController, textAlign: TextAlign.center, decoration: const InputDecoration(filled: true, hintText: "5 digit room ID", border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8))))),
                const SizedBox(height: 6,),
                TextField(controller: _ownRoomNameController, textAlign: TextAlign.center, decoration: const InputDecoration(filled: true, hintText: "Room Name", border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8))))),
                const SizedBox(height: 6,),
                ElevatedButton(onPressed: _createRoom, child: const Text("Create your own room"))
              ])
            ],
          ),
        ),
      ),
    );
  }
}