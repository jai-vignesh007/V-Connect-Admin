// ignore_for_file: prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, empty_catches

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PastEvents extends StatefulWidget {
  const PastEvents({Key? key}) : super(key: key);

  @override
  State<PastEvents> createState() => _PastEventsState();
}

class _PastEventsState extends State<PastEvents> {
  GoogleFonts gf = GoogleFonts();
  List<String> items = [
    "Accept",
    "Decline",
    "Attended",
  ];

  int current = 0;

  var accept=[],load,decline=[],attend=[],list=[];

  Future<void> getData() async {
    setState(() {
      load=true;
    });

    await FirebaseFirestore.instance.collection("events").get().then((value){
      for(var i in value.docs){
        // print(i["accept"]);
        for(var j in i["accept"]){
          if(j["email"] == "sec20cb003@sairamtap.edu.in") {
            accept.add(i.data());
            break;
          }
        }
      }

    });

    await FirebaseFirestore.instance.collection("events").get().then((value){
      for(var i in value.docs){
        for(var j in i["decline"]){
          if(j["email"] == "sec20cb003@sairamtap.edu.in") {
            decline.add(i.data());
            break;
          }
        }
      }

    });
try {
  await FirebaseFirestore.instance.collection("users").doc("uid").get().then((
      value) async {
    for (var i in value["attend"]) {
      await FirebaseFirestore.instance.collection("events").doc(i).get().then((
          val) {
        attend.add(val.data());
      });
    }
  });
}catch(e){}
    setState(() {
      list = accept;
      load = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe5e5e5),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back,color: Colors.black,),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Past Events",
          style: GoogleFonts.laila(
              fontWeight: FontWeight.w500,
              color: Colors.black
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          current = 0;
                          list = accept;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.all(5),
                        width:  MediaQuery.of(context).size.width/3 - MediaQuery.of(context).size.width*0.05,
                        height: 45,
                        decoration: BoxDecoration(
                          color: current == 0
                              ? Colors.white70
                              : Colors.white54,
                          borderRadius: current == 0
                              ? BorderRadius.circular(15)
                              : BorderRadius.circular(10),
                          border: current == 0
                              ? Border.all(
                              color: Colors.black, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            items[0],
                            style: GoogleFonts.laila(
                                fontWeight: FontWeight.w500,
                                color: current == 0
                                    ? Colors.black
                                    : Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: current == 0,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle),
                        ))
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          current = 1;
                          list = decline;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.all(5),
                        width:   MediaQuery.of(context).size.width/3 - MediaQuery.of(context).size.width*0.05,
                        height: 45,
                        decoration: BoxDecoration(
                          color: current == 1
                              ? Colors.white70
                              : Colors.white54,
                          borderRadius: current == 1
                              ? BorderRadius.circular(15)
                              : BorderRadius.circular(10),
                          border: current == 1
                              ? Border.all(
                              color: Colors.black, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            items[1],
                            style: GoogleFonts.laila(
                                fontWeight: FontWeight.w500,
                                color: current == 1
                                    ? Colors.black
                                    : Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: current == 1,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle),
                        ))
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          current = 2;
                          list= attend;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.all(5),
                        width:  MediaQuery.of(context).size.width/3 - MediaQuery.of(context).size.width*0.05,
                        height: 45,
                        decoration: BoxDecoration(
                          color: current == 2
                              ? Colors.white70
                              : Colors.white54,
                          borderRadius: current == 2
                              ? BorderRadius.circular(15)
                              : BorderRadius.circular(10),
                          border: current == 2
                              ? Border.all(
                              color: Colors.black, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            items[2],
                            style: GoogleFonts.laila(
                                fontWeight: FontWeight.w500,
                                color: current == 2
                                    ? Colors.black
                                    : Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: current == 2,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle),
                        ))
                  ],
                ),
              ],
            ),

            load ? const CircularProgressIndicator()
                : Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {

                  return  Column(

                    children: [
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10,right: 10),
                            decoration: const BoxDecoration(
                              color: Colors.white,

                              borderRadius:  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width *
                                            0.45,
                                        child: Text(
                                          list[index]["eventname"],
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      "Posted Date :" +  list[index]["posted"],
                                      textAlign: TextAlign.left,
                                    ),
                                  ), //POSTED DATE
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                   list[index]['description'].toString(),
                                    textAlign: TextAlign.left,
                                    maxLines: 5,
                                  ), //DESCRIPTION
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        child: const Text(" VOLUNTEER "),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Navigator.push(context, MaterialPageRoute(
                                          //     builder: (context) => Knowmore( event_data: list[index],)));

                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.greenAccent),
                                        child: const Text(" Knowmore "),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}