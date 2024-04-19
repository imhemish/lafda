import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:lafda/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var db = DatabaseService();

Widget getCommentsBody(Stream<DocumentSnapshot>? stream, String userID) {
  if (stream != null) {

    return StreamBuilder(stream: stream, builder: (context, asyncAnapshot) {
      if (asyncAnapshot.hasData) {
        return 
        Chat(messages: getCommentsAsTypes(asyncAnapshot.data!),

        
        customStatusBuilder: (message, {required context}) {
          if (message.author.id == userID) {
            return Icon(Icons.verified);
          } else {
            return SizedBox(height: 0.1);
          }
        },
        
        theme: DefaultChatTheme(backgroundColor: Theme.of(context).brightness != Brightness.dark ? Colors.white : Colors.black, userNameTextStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
        
        showUserNames: true,
        inputOptions: const InputOptions(sendButtonVisibilityMode: SendButtonVisibilityMode.always),
        onSendPressed: (text) => db.addComment(userID, text.text),
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

List<types.Message> getCommentsAsTypes(DocumentSnapshot snapshot) {
  var rawComments = snapshot.get("comments");
  print(rawComments);
  List<FirestoreMessage> comments = [];
  for (var comment in rawComments) {
    comments.add(FirestoreMessage.fromMap(comment));
  }
  return comments.map((message) => types.TextMessage(author: types.User(id: message.sender, firstName: message.senderName), id: message.id, text: message.message, createdAt: message.timestamp.millisecondsSinceEpoch)).toList();
  
  }



class PersonPage extends StatefulWidget {
  final String userID;
  final String userName;
  final String imageURI;
  const PersonPage(this.userID, this.userName, this.imageURI);

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.userName)),
        body: getCommentsBody(db.usersCollection.doc(widget.userID).snapshots(), widget.userID
            ));
  }
}
