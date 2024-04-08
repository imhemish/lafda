import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import './banned_words.dart';

class DatabaseService {
  var usersCollection = FirebaseFirestore.instance.collection("users");
  var roomsCollection = FirebaseFirestore.instance.collection("rooms");

  Future<void> createChatUser(String uid, String name, {String? imageURL}) async {
    await usersCollection.doc(uid).set({
      "rooms": <String>[]
    });
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
  }

  Future<void> joinRoom(String roomID) async {
    var currentUserDoc = usersCollection.doc(FirebaseAuth.instance.currentUser!.uid);
    var currentRooms = (await currentUserDoc.get()).get("rooms") as List<dynamic>;
    await currentUserDoc.update({
      "rooms": currentRooms + [roomID]
    });
  }

  Future<void> createRoom(String roomID, String name) async {
    await roomsCollection.doc(roomID).set({
      "name": name,
      "messages": <Map<String, dynamic>>[]
    });
  }

  Future<void> sendMessage(String roomID, String message) async {
    if (bannedWords.contains(message.toLowerCase())) {
      Get.snackbar("Error", "This language is not allowed");
      return;
    }
    var currentMessages = (await roomsCollection.doc(roomID).get()).get("messages") as List<Map<String, Object>>;
    await roomsCollection.doc(roomID).set({
      "messages": [{"id": (const Uuid()).v4(), "message": message, "sender": FirebaseAuth.instance.currentUser!.uid, "timestamp": Timestamp.now()},] + currentMessages
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

}