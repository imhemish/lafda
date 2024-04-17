import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lafda/pref_util.dart';
import '../database.dart';

var db = DatabaseService();

class InitialController extends GetxController {

  Future<void> initialiseChatUser(String name) async {
    FirebaseAuth.instance.signInAnonymously().then((credential) {
      var uid = credential.user?.uid;
      if (uid != null) {
        db.createChatUser(uid, name).then((value) => Get.offNamed("/main"));
        PrefUtil.setValue("anonName", name);
      } else {
        Get.snackbar("Error", "Could not connect to database");
      }
    });
  }
    
}

class InitialPage extends StatefulWidget  {

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  var controller = Get.put(InitialController());
  final _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
        ConstrainedBox(constraints: BoxConstraints.loose(const Size(230, double.infinity)), child: Align(alignment: Alignment.center, child: TextField(controller: _nameController, decoration: const InputDecoration(hintText: "Anonymous Name", filled: true),))),
          ElevatedButton(onPressed: () => controller.initialiseChatUser(_nameController.text), child: const Text("Continue"))
        ])),
    );
  }
}