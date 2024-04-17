import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lafda/database.dart';
import 'package:lafda/pages/person.dart';

class People {
  final String imageUrl;
  final String name;

  People(this.imageUrl, this.name);
}

var db = DatabaseService();

class PeoplePage extends StatefulWidget {
  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: db.getPeopleList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
          return GridView.builder(padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                 mainAxisSpacing: 20, 
                 crossAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Get.to(PersonPage(snapshot.data![index].userID, snapshot.data![index].name, snapshot.data![index].imageURL)),
                  child: SizedBox(height: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(snapshot.data![index].imageURL)),
                        Text(
                          snapshot.data![index].name,
                          style: const TextStyle(
                            
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: snapshot.data!.length,
            );
            }
            else {
              return CircularProgressIndicator.adaptive();
            }
          }
        ),),
    );
  }
}