import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactUsPage extends StatefulWidget {
  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _messageController = TextEditingController();

  var loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Team Members',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage("https://sanju-vashist.github.io/lafda/image/hemish.jpg"),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Hemish',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Implemented Home Page, Chat Page, Rooms and backend database',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage("https://sanju-vashist.github.io/lafda/image/sanju.jpg"),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Sanju',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Created app design, website, implemented Contact Page UI and Profile Page UI, deals with users, promotor',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: _numberController,
                      decoration: InputDecoration(
                        
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.length != 10) {
                          return "Enter 10 digit number";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                      
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 20.0),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: loading ? CircularProgressIndicator.adaptive() : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            FirebaseFirestore.instance.collection("contact").doc().set({
                              "name": _nameController.text,
                              "number": _numberController.text,
                              "message": _messageController.text
                            }).then((value) => setState(() {
                              loading = false;
                              Get.snackbar("Sent", "Your message was sent successfully");
                            }));
                          }
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(vertical: 12.0),
                          ),
                        ),
                        child: Text('Submit', style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Things to remember :',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    _buildBulletPoint('The app is created just for fun, please don’t take anything presonal.'),
                    _buildBulletPoint('We are not indulged in any activity and not responsible for any harm.'),
                    _buildBulletPoint('We don’t store your precious chats longer than some time. Please take screenshot if needed.'),
                    _buildBulletPoint('We don’t have any of your contact info or any other personal data.'),
                    _buildBulletPoint('We will maintain your privacy as we also do not know who are you.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('• ', style: TextStyle(fontSize: 16.0)),
        Expanded(child: Text(text, style: TextStyle(fontSize: 16.0))),
      ],
    );
  }
}