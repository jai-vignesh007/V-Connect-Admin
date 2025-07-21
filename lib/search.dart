// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_is_empty, prefer_adjacent_string_concatenation, unused_local_variable

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// QuerySnapshot snapshot = await _collectionRef
              //     .orderBy('eventname')
              //     .startAt(['M']).get();
late QuerySnapshot querySnapshot;
Future<void> get() async {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('events');
  querySnapshot = await _collectionRef.get();
}

class Tee extends StatefulWidget {
  const Tee({super.key});

  @override
  State<Tee> createState() => _TeeState();
}

class _TeeState extends State<Tee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          GestureDetector(
            child: const Center(child: Text("lmjjjl")),
            onTap: () async {
              QuerySnapshot snapshot =
                  await FirebaseFirestore.instance.collection('events')
              
              .where('eventname', isGreaterThanOrEqualTo: 'm')  .where("eventname", isLessThanOrEqualTo: 'n' + 'z')

              .get();
              var l = snapshot.docs.map((e) => e);
              for(var i  in l){
              }
            },
          )
        ],
      ),
    );
  }
}

class MySearch extends SearchDelegate {
  final String name;

  MySearch({required this.name});

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back),
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];
  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text(
          query,
          style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
        ),
      );
  @override
  Widget buildSuggestions(BuildContext context) {
    //  print(allData[0][1]["posted"].toString() );
    // querySnapshot = collectionRef.get()
    List<dynamic> sug = querySnapshot.docs.where((i) {
      final result = i.id.toString().toLowerCase();
      final input = query.toLowerCase();
      return result.startsWith(input);
    }).toList();

    return sug.length == 0
        ? const Center(
            child: Text("no content"),
          )
        : ListView.builder(
            itemCount: sug.length < 5 ? sug.length : 5,
            itemBuilder: (context, index) {
              final sugs = sug[index];
              var a = sugs.data()["posted"].toString();
              return ListTile(
                title: Text(sugs.id),
                subtitle: Text("posted on: $a"),
                leading: Container(
                    padding: const EdgeInsets.all(1),
                    child: Image.network(
                      "https://media-cdn.tripadvisor.com/media/photo-s/0c/bb/a3/97/predator-ride-in-the.jpg",
                      fit: BoxFit.contain,
                    )),
                onTap: () {
                  query = sugs.id;
                  showResults(context);
                },
              );
            });
  }
}
