import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:get/get.dart';
import 'package:lafda/pages/home.dart';
import 'package:lafda/pages/chat.dart';
import 'package:lafda/pages/people.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lafda',
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(filled: true, border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8)))),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          
          useMaterial3: true,
          textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 17))
        ),
        home: MainPage());
  }
}

const _kPages = <String, IconData>{
  'People': Icons.person_rounded,
  'Home': Icons.home,
  'Chat': Icons.chat
};

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _kPages.length,
      initialIndex: 1,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [PeoplePage(), HomePage(), ChatPage()],
              ),
            ),
          ],
        ),
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size(0, 15),
            child: 
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("No ONE", style: Theme.of(context).textTheme.bodyMedium,), Text("KNOWS YOU", style: Theme.of(context).textTheme.bodyMedium)])),),
          title: Image.asset("images/logo.png", height: 42,),
          actions: [
            ElevatedButton(onPressed: () => {}, child: const Text("Contact")),
            const SizedBox(width: 7,),
            IconButton.filled(onPressed: () => {}, icon: const Icon(Icons.person, color: Colors.white,), padding: const EdgeInsets.all(5), color: Theme.of(context).primaryColor,),
            const SizedBox(width: 7,),
          ],
        ),
        bottomNavigationBar: ConvexAppBar.badge(
          const <int, dynamic>{},
          style: TabStyle.reactCircle,
          items: <TabItem>[
            for (final entry in _kPages.entries)
              TabItem(icon: entry.value, title: entry.key),
          ],
        ),
      ),
    );
  }

  // Select style enum from dropdown menu:
}
