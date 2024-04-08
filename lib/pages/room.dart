import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:lafda/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMessage {
  final String id;
  final String message;
  final String sender;
  final Timestamp timestamp;

  const FirestoreMessage(this.id, this.message, this.sender, this.timestamp);

  factory FirestoreMessage.fromMap(Map<String, dynamic> dict) {
    var id = dict["id"] as String;
    var message = dict["message"] as String;
    var sender = dict["sender"] as String;
    var timestamp = dict["timestamp"] as Timestamp;
    return FirestoreMessage(id, message, sender, timestamp);
  }
}

var db = DatabaseService();

List<types.TextMessage> getMessagesAsTypes(DocumentSnapshot snapshot) {
  var rawMessages = snapshot.get("messages") as List<dynamic>;
  List<FirestoreMessage> messages = rawMessages.map((e) => FirestoreMessage.fromMap(e)).toList();
  return messages.map((message) {
    return types.TextMessage(author: types.User(id: message.sender), id: message.id, text: message.message);
  }).toList();

}

Widget getRoomBody(Stream<DocumentSnapshot>? stream, String roomID) {
  if (stream != null) {

    return StreamBuilder(stream: stream, builder: (context, asyncAnapshot) {
      if (asyncAnapshot.hasData) {
        return 
        Chat(messages: getMessagesAsTypes(asyncAnapshot.data!),
        onSendPressed: (text) => db.sendMessage(roomID, text.text),
        user: types.User(id: FirebaseAuth.instance.currentUser!.uid,),
        bubbleRtlAlignment: BubbleRtlAlignment.right,);
        
      } else {
        return const CircularProgressIndicator.adaptive();
      }
    });

  } else {
    return const CircularProgressIndicator.adaptive();
  }
}

class RoomPage extends StatefulWidget {
  final String roomID;
  const RoomPage(this.roomID);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  Stream<DocumentSnapshot>? stream;

  Future<void> putStream() async {
    Stream<DocumentSnapshot> localStream = await db.getRoomStream(widget.roomID);
    setState(() {
      stream = localStream;
    });
  }

  @override
  void initState() {
    putStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getRoomBody(stream, widget.roomID)
    );
  }
}