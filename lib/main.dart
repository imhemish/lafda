import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:lafda/firebase_options.dart';
import 'package:lafda/pages/contact.dart';
import 'package:lafda/pages/home.dart';
import 'package:lafda/pages/chat.dart';
import 'package:lafda/pages/initial.dart';
import 'package:lafda/pages/people.dart';
import 'package:lafda/pages/profile.dart';
import 'package:get/get.dart';
import 'package:lafda/pref_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PrefUtil.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        getPages: [
          GetPage(name: "/initial", page: () => InitialPage()),
          GetPage(name: "/main", page: () => MainPage()),
          GetPage(name: "/contact", page: () => ContactUsPage()),
          GetPage(name: "/profile", page: () => ProfilePage())
        ],
        debugShowCheckedModeBanner: false,
        title: 'Lafda',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          
          useMaterial3: true,
          textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 17))
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark
        ),
        initialRoute: FirebaseAuth.instance.currentUser != null ? "/main" : "/initial",);
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
          backgroundColor: Colors.blue,
          actions: [
            ElevatedButton(onPressed: () => Navigator.of(context).pushNamed("/contact"), child: const Text("Contact")),
            const SizedBox(width: 7,),
            ElevatedButton(onPressed: () => Navigator.of(context).pushNamed("/profile"), child: const Icon(Icons.person), ),
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
}
