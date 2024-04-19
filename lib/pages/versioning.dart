import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

const version = "0.0";

class Versioning extends StatefulWidget {
  const Versioning({super.key});

  @override
  State<Versioning> createState() => _VersioningState();
}

class _VersioningState extends State<Versioning> {

  var checking = true;
  
  @override
  void initState() {
    checkVersion();
    super.initState();

  }

  Future<void> checkVersion() async {
    var onlineVersions = (await http.get(Uri.parse("https://hemish.net/lafdaversion.txt"))).body.split(" ").map((e) => e.removeAllWhitespace).toList();
    print(onlineVersions);
    print(onlineVersions.contains(version));
    if (onlineVersions.contains(version)) {
      Get.offNamed(FirebaseAuth.instance.currentUser != null ? "/main" : "/initial");
    } else {
      setState(() {
        checking = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: checking ? CircularProgressIndicator.adaptive() : Text("Please update the app to keep using it"))
    );
  }
}