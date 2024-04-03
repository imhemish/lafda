import 'package:flutter/material.dart';
import 'package:get/get.dart';

class People {
  final String imageUrl;
  final String name;

  People(this.imageUrl, this.name);
}

class PeopleController extends GetxController {
  RxList<People> people = <People>[
    People("https://apiwp.thelocal.com/cdn-cgi/image/format=webp,width=850,quality=75/https://apiwp.thelocal.com/wp-content/uploads/2018/12/6d67730d16af04f3f956389d4cc244af808b8381c23b1e3d218ecd792de14fa8.jpg", "lsakdflksd"),
    People("https://apiwp.thelocal.com/cdn-cgi/image/format=webp,width=850,quality=75/https://apiwp.thelocal.com/wp-content/uploads/2018/12/6d67730d16af04f3f956389d4cc244af808b8381c23b1e3d218ecd792de14fa8.jpg", "lsakdflksd")
  ].obs;
}

class PeoplePage extends StatefulWidget {
  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final peopleController = Get.put(PeopleController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GridView.builder(padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
               mainAxisSpacing: 20, 
               crossAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              return SizedBox(height: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(peopleController.people[index].imageUrl)),
                    Text(
                      peopleController.people[index].name,
                      style: const TextStyle(
                        
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: peopleController.people.length,
          ),),
    );
  }
}