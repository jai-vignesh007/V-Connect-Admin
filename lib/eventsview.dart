// ignore_for_file: prefer_interpolation_to_compose_strings

import 'galleryview.dart';
import 'report_docs.dart';
import 'volunteer_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Eventview extends StatefulWidget {
  final String eventname;
  const Eventview({super.key,  required this.eventname});

  @override
  State<Eventview> createState() => _EventviewState();
}

class _EventviewState extends State<Eventview> {
  @override
  Widget build(BuildContext context) {

    return Scaffold( backgroundColor: const Color(0xffe5e5e5),
      appBar: AppBar(title: const Text('Event Details',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){ Navigator.pop(context);  },icon: const Icon(Icons.arrow_back,color: Colors.black,),),
      ),
          body:Center(
              child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('events')
                    .doc(widget.eventname)  // 👈 Your document id change accordingly
                    .get(),
                builder: (_, snapshot) {
                  if (snapshot.hasError) return Text('Error = ${snapshot.error}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  Map<String, dynamic> data = snapshot.data!.data()!;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10),
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
                                              data["eventname"],
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )), //EVENT NAME
                                        const Spacer(),
                                        Column(
                                          children: [
                                            !data["mark"]
                                                ? const Icon(
                                              Icons.group,
                                              color: Colors.black,
                                            )
                                                : DateTime.parse(data["enddate"]).compareTo(
                                                DateTime.parse(DateFormat(
                                                    'yyyy-MM-dd')
                                                    .format(DateTime.now()))) <
                                                0 ?const Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ):DateTime.parse(data["startdate"])
                                                .compareTo(DateTime.parse(
                                                DateFormat('yyyy-MM-dd')
                                                    .format(DateTime
                                                    .now()))) <=
                                                0
                                                ? const Icon(
                                              Icons.change_circle_outlined,
                                              color: Colors.lightBlueAccent,)
                                                :const Icon(
                                                Icons.group
                                            ),
                                            !data['mark']?const Text("Volunteers Call")
                                                : DateTime.parse(data["enddate"])
                                                .compareTo(DateTime.parse(
                                                DateFormat('yyyy-MM-dd')
                                                    .format(DateTime
                                                    .now()))) <
                                                0
                                                ? const Text("Completed "):
                                            DateTime.parse(data["startdate"]).compareTo(
                                                DateTime.parse(DateFormat(
                                                    'yyyy-MM-dd')
                                                    .format(DateTime.now()))) <=
                                                0
                                                ? const Text("Ongoing")
                                                :const Text("Volunteer CallOver")

                                          ],
                                        ) //COMPLETED ICON
                                      ],
                                    ),
                                    //event name
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Image.network(
                                        data['poster']), //event photo
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        "Posted Date :" + data["posted"],
                                        textAlign: TextAlign.left,
                                      ),
                                    ), //POSTED DATE
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      data['description'].toString(),
                                      textAlign: TextAlign.left,
                                    ), //DESCRIPTION
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        "TO BE HELD: " + data['startdate'],
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => Report_docs(eventname: data["eventname"])));

                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              child: const Text("  EVENT REPORT  "),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryView(data["eventname"])));

                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.greenAccent),
                                              child: const Text(" EVENT GALLERY "),
                                            )
                                          ],
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => volunteerslist(id: data["eventname"], after: true)));
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue),
                                          child: const Text("VOLUNTEER DETAILS"),
                                        ),//CALL OFF EVENT MARK AS DONE
                                        const SizedBox(height: 15),

                                      ],
                                    )// MODIFY DETAILS MARK AS DONE
                                  ],
                                ),
                              ),
                            )],
                        ),
                        //postdetailcontainer
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ); //👈 Your valid data here
                },
              )),



        );
  }
}
