import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'eventsview.dart';

class ListOfEvents extends StatefulWidget {
  const ListOfEvents({Key? key}) : super(key: key);

  @override
  State<ListOfEvents> createState() => _ListOfEventsState();
}

class _ListOfEventsState extends State<ListOfEvents> {

  var alldata = [],allconst=[];
  // ignore: prefer_final_fields
  CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('events');

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.limit(100).get();
    // Get data from docs and convert map to List
    alldata = querySnapshot.docs;
    allconst = alldata;
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
      appBar: AppBar(
        toolbarHeight: 70,
        title: SizedBox(
          height: 50,
          width: double.infinity,
          child: TextField(
            onChanged: (i){
              alldata = allconst.where((element) {
                return element.id.startsWith(i);
              }).toList();
              setState(() {
                alldata;
              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: "Search",
                suffixIcon: const Icon(Icons.search_rounded),
                fillColor: const Color(0xffdadada),
                filled: true),
          ),
        ),
        backgroundColor: Colors.white,
       leading: IconButton(onPressed: (){},icon: const Icon(Icons.menu,color: Colors.black,size: 30,),),
      ),
      backgroundColor: const Color(0xffe5e5e5),
      body: Center(
        child: Column(
            children: [
              const SizedBox(height: 20,),
         Expanded(
           child: ListView.builder(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    itemCount: alldata.length,
    itemBuilder:(context,index){
      var i = alldata[index].id.toString();
      return    Padding(
        padding: const EdgeInsets.only(top:15,bottom: 10,left: 25,right: 25),
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.062,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Eventview(eventname: i)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
       children :[
         SizedBox(
           width: MediaQuery.of(context).size.width * 0.2,
         ),
         const Icon(

                Icons.event_available,
                color: Colors.black,
                size: 30.0,

              ),

               Container(
                 alignment: Alignment.center,
                 width: MediaQuery.of(context).size.width * 0.4 ,
                 child: Text(
                  i.toString(),
                  // textAlign: TextAlign.left,
                  style: const TextStyle(color: Colors.black),
              ),
               ),]),
            ),
        ),
      );
    }
           ),
         ),
        
         ]
    ,
    ),
      )
    ,

    );
  }
}
