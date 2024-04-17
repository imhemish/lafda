import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:lafda/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


var db = DatabaseService();

List<types.TextMessage> getMessagesAsTypes(DocumentSnapshot snapshot) {
  var rawMessages = snapshot.get("messages") as List<dynamic>;
  List<FirestoreMessage> messages = rawMessages.map((e) => FirestoreMessage.fromMap(e)).toList();
  return messages.map((message) {
    return types.TextMessage(author: types.User(id: message.sender, firstName: message.senderName), id: message.id, text: message.message, createdAt: message.timestamp.millisecondsSinceEpoch);
  }).toList();

}

Widget getRoomBody(Stream<DocumentSnapshot>? stream, String roomID) {
  if (stream != null) {

    return StreamBuilder(stream: stream, builder: (context, asyncAnapshot) {
      if (asyncAnapshot.hasData) {
        return 
        Chat(messages: getMessagesAsTypes(asyncAnapshot.data!),
        
        theme: DefaultChatTheme(backgroundColor: Theme.of(context).brightness != Brightness.dark ? Colors.white : Colors.black),
        nameBuilder: (p0) => Text(p0.firstName ?? ""),
        showUserNames: true,
        inputOptions: const InputOptions(sendButtonVisibilityMode: SendButtonVisibilityMode.always),
        onSendPressed: (text) => db.sendMessage(roomID, text.text),
        user: types.User(id: FirebaseAuth.instance.currentUser!.uid,),
        bubbleRtlAlignment: BubbleRtlAlignment.right,
        );
        
      } else {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
    });

  } else {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}

class RoomPage extends StatefulWidget {
  final String roomID;
  final String roomName;
  const RoomPage(this.roomID, this.roomName);

  @override
  State<RoomPage> createState() => _RoomPageState();

}

class _RoomPageState extends State<RoomPage> {
  Stream<DocumentSnapshot>? stream;

  String? roomNameState;

  @override
  initState() {
    putStream();
    super.initState();
  }


  Future<void> putStream() async {
    Stream<DocumentSnapshot> localStream = await db.getRoomStream(widget.roomID);
    setState(() {
      stream = localStream;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.roomName), actions: [IconButton(tooltip: "Leave Room", onPressed: () => db.leaveRoom(widget.roomID).then((value) => Navigator.of(context).pop()), icon: const Icon(Icons.delete), color: Colors.red,)],),
      body: getRoomBody(stream, widget.roomID)
    );
  }
}