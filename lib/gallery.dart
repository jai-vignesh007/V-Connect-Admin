// ignore_for_file: prefer_is_empty, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'galleryview.dart';
import 'postimage.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<String> alldata = [];
  TextEditingController control = TextEditingController();
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('gallery_imgs');

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    alldata = querySnapshot.docs.map((doc) => doc['name'].toString()).toList();
    setState(() {
      alldata;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe5e5e5),
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () {},
          child: const Icon(
            Icons.menu,
            size: 35,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "GALLERY",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Postimg()));
                },
                icon: const Icon(
                  Icons.remove_red_eye_outlined,
                  size: 35,
                  color: Colors.black,
                )),
          )
        ],
      ),
      body: alldata.length < 0
          ? const Center(child: CircularProgressIndicator())
          : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: control,
                  onChanged: (value)async {
                    QuerySnapshot querySnapshot = await _collectionRef.get();
                    alldata = [];
                    for(var i in querySnapshot.docs){
                      if(i["name"].toString().toLowerCase().startsWith(control.text.toLowerCase())){
                        alldata.add(i["name"]);
                      }
                    }

                    setState(() {
                          alldata;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      suffixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      labelText: "Search ",
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(child: BuildGridView()),
            ],
          ),
    );
  }

  Widget BuildGridView() => GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: alldata.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return buildNumber(alldata[index]);
        },
      );

  Widget buildNumber(String str) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GalleryView(str)));
          },
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black,
            ),
            child: GridTile(
              footer: Center(
                child: Text(
                  str.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              child: Center(
                child: Image.asset(
                  "assets/file.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      );
}
