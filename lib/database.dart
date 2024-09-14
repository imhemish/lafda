import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lafda/pref_util.dart';
import 'package:uuid/uuid.dart';
import './banned_words.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Person {
  final String name;
  final String imageURL;
  final String userID;
  const Person(this.name, this.imageURL, this.userID);
}

class FirestoreMessage {
  final String id;
  final String message;
  final String sender;
  final String senderName;
  final Timestamp timestamp;

  const FirestoreMessage(this.id, this.message, this.sender, this.senderName, this.timestamp);

  factory FirestoreMessage.fromMap(Map<String, dynamic> dict) {
    var id = dict["id"] as String;
    var message = dict["message"] as String;
    var sender = dict["sender"] as String;
    var timestamp = dict["timestamp"] as Timestamp;
    var senderName = dict["senderName"] as String;
    return FirestoreMessage(id, message, sender, senderName, timestamp);
  }
}

class DatabaseService {
  var usersCollection = FirebaseFirestore.instance.collection("users");
  var roomsCollection = FirebaseFirestore.instance.collection("rooms");

  Future<void> createChatUser(String uid, String anonName,) async {
    await usersCollection.doc(uid).set({
      "rooms": <String>[],
      "anonName": anonName,
      "comments": [],
      "paused": false,
      "image": "",
      "realName": "",
      "verified": false
    });
  }

  Future<String> joinRoom(String roomID) async {
    var currentUserDoc = usersCollection.doc(FirebaseAuth.instance.currentUser!.uid);
    var currentRooms = (await currentUserDoc.get()).get("rooms") as List<dynamic>;
    await currentUserDoc.update({
      "rooms": currentRooms + [roomID]
    });
    return await getRoomName(roomID);
  }

  Future<void> createRoom(String roomID, String name) async {
    await roomsCollection.doc(roomID).set({
      "name": name,
      "messages": <Map<String, dynamic>>[],
      "paused": false,
    });
    joinRoom(roomID);
  }

  Future<void> sendMessage(String roomID, String message) async {
    for (var word in bannedWords) {
      if (message.toLowerCase().contains(word)) {
        Get.snackbar("Error", "This language is not allowed");
        return;
      }
    }
    var room = await roomsCollection.doc(roomID).get();
    if (room.get("paused") == true) {
      Get.snackbar("Can not add message", "Adding messages is paused by admins");
      return;
    }
    var currentMessages = room.get("messages");
    await roomsCollection.doc(roomID).update({
      "messages": <dynamic>[{"id": (const Uuid()).v4(), "message": message, "sender": FirebaseAuth.instance.currentUser!.uid, "senderName": PrefUtil.getValue("anonName", "Anonymous"), "timestamp": Timestamp.now()},] + currentMessages
    });
  }

  Future<Stream<DocumentSnapshot>> getRoomStream(String roomID) async {
    return roomsCollection.doc(roomID).snapshots();
  }

  Future<String> getRoomName(String roomID) async {
    return (await roomsCollection.doc(roomID).get()).get("name") as String;
  }

  Future<Map<String, String>> getRoomsListByUser(String uid) async {
    var roomsMap = <String, String> {};
    var roomsList = (await usersCollection.doc(uid).get()).get("rooms") as List<dynamic>;
    for (String roomID in roomsList) {
      var roomName = await getRoomName(roomID);
      roomsMap[roomID] = roomName;
    }
    return roomsMap;
  }

  Future<List<Person>> getPeopleList() async{
    var people = <Person>[];
    var docs = (await usersCollection.where("verified", isEqualTo: true).get()).docs;
    for (var doc in docs) {
      people.add(Person(doc.get("realName"), doc.get("image"), doc.id));
    }
    return people;
  }

  Future<void> leaveRoom(String roomID) async {
    var currentUserDoc = usersCollection.doc(FirebaseAuth.instance.currentUser!.uid);
    var currentRooms = (await currentUserDoc.get()).get("rooms") as List<dynamic>;
    currentRooms.remove(roomID);
    return await currentUserDoc.update({
      "rooms": currentRooms
    });
  }

  Future<void> addComment(String userid, String comment) async {
    for (var word in bannedWords) {
      if (comment.toLowerCase().contains(word)) {
        Get.snackbar("Error", "This language is not allowed");
        return;
      }
    }
    var user = await usersCollection.doc(userid).get();
    if (user.get("paused") == true) {
      Get.snackbar("Can not add comment", "Adding comments is paused by admins");
      return;
    }
    var currentComments = user.get("comments");
    await usersCollection.doc(userid).update({
      "comments": <dynamic>[{"id": (const Uuid()).v4(), "message": comment, "sender": FirebaseAuth.instance.currentUser!.uid, "senderName": PrefUtil.getValue("anonName", "Anonymous"), "timestamp": Timestamp.now()},] + currentComments
    });
  }

  Future<String?> uploadImageToFirebase(Uint8List data) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');

    UploadTask uploadTask = storageReference.putData(data);
    TaskSnapshot snapshot = await uploadTask;

    if (snapshot.state == TaskState.success) {
      final String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    }
    return null;
  }

}