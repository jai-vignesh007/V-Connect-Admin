
// ignore_for_file: prefer_final_fields, prefer_is_empty

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'report_docs.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {

  List<String> alldata = [];
  CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('events');

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    alldata = querySnapshot.docs.map((doc) => doc.id.toString()).toList();
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
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: (){

            },
            icon: const Icon(
              Icons.add_link_rounded,
              color: Colors.black,
              size: 30,
            ),
          )
        ],
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back,color: Colors.black),
        ),
        title: const Text("Report",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: alldata.length > 0
          ? ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Box(
              name: alldata[index],
          indx: index,);

        },
        itemCount: alldata.length,
        separatorBuilder: (context, index) {
          return const Divider(
            height: 4,
            thickness: 1,
          );
        },
      )
          : const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}


class Box extends StatelessWidget {
  final String name;
  final int indx;
  const Box({super.key, required this.name,required this.indx});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5,
        child: GestureDetector(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Report_docs(eventname: name,)));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xffe5e5e5),
            ),
            height: 60,
            width: double.infinity,
            child: Center(
              child: Text(
                name,
                style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}