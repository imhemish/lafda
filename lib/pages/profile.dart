import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lafda/database.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  var loading = false;
  String? imageURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for verification'),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: InkWell(
              onTap: () {
                () async {
                  var image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    var data = await image.readAsBytes();
                    var url =
                        await DatabaseService().uploadImageToFirebase(data);
                    setState(() {
                      imageURL = url;
                    });
                  } else {
                    Get.snackbar("Error", "Could not pick image");
                    Get.back();
                  }
                }();
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    (imageURL != null) ? NetworkImage(imageURL!) : null,
                //backgroundImage: AssetImage('assets/avatar.jpg'),
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: TextField(
                        controller: _contactController,
                        decoration: InputDecoration(
                          labelText: "Contact Number",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: loading
                    ? CircularProgressIndicator.adaptive()
                    : FractionallySizedBox(
                        widthFactor: 0.3,
                        child: ElevatedButton(
                          onPressed: () {
                            if (imageURL != null &&
                                _nameController.text.isNotEmpty &&
                                _contactController.text.length == 10) {
                              setState(() {
                                loading = true;
                              });
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "realName": _nameController.text,
                                "image": imageURL,
                              }).then((_) {
                                FirebaseFirestore.instance
                                    .collection("verification")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .set({"contact": _contactController.text});
                              }).then((value) {
                                setState(() {
                                  loading = false;
                                });
                                Get.back();
                                Get.snackbar("Success",
                                    "Verification request has been made");
                              });
                            } else {
                              Get.snackbar("Not sent",
                                  "Ensure that photo has been uploaded, name is not empty and Contact number is 10 digit");
                            }
                          },
                          child: Text('Apply'),
                        ),
                      ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'You can upload your photo for verification to list you on the People section of our app. We will contact you to confirm if you applied, shortly. Getting verified here and uploading your photo will not affect your identity and will not show the photo to others on app and you can still chat anonymously with your anonymous name.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
