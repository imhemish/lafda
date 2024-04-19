import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lafda/database.dart';
import 'package:lafda/pages/room.dart';

var db = DatabaseService();

Widget renderRooms(Map<String, String>? rooms, ScrollController scrollController) {
  if (rooms != null) {
    var entries = (rooms).entries.toList();
    return ListView.separated(itemCount: rooms.length, itemBuilder: (context, index) => ListTile(title: Text((entries[index]).value), subtitle: Text(entries[index].key), onTap: () => Get.to(RoomPage((entries[index]).key, entries[index].value)),), separatorBuilder: (context, index) => const Divider(),);
  }
  else {
    // Somehow i had to use both Center and Align to centrally align it on Web
    return const Center(child: Align(alignment: Alignment.center, child: CircularProgressIndicator.adaptive()));
  }
}
class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _scrollController = ScrollController();

  Map<String, String>? rooms;

  @override
  void initState() {
    setupRooms();
    super.initState();
  }

  void setupRooms() async {
      var tempRooms = await db.getRoomsListByUser(FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        rooms = tempRooms;
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderRooms(rooms, _scrollController)
    );
  }
}