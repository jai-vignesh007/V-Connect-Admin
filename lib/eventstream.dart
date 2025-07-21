// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'modifydetails.dart';
import 'volunteer_list.dart';
class EventStream extends StatefulWidget {

  final Map<String, dynamic> datas;
  final String id;
  const EventStream({super.key, required this.datas, required this.id});

  @override
  State<EventStream> createState() => _EventStreamState();
}

class _EventStreamState extends State<EventStream> {
  Map<String, dynamic> data = {};
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.datas;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
              children: [
                const SizedBox(height: 10),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              left: BorderSide(
                                  width: 4.0,
                                  color: !data["mark"]
                                      ? Colors.red
                                      : DateTime.parse(data["enddate"])
                                                  .compareTo(DateTime.parse(
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(DateTime
                                                              .now()))) ==
                                              0
                                          ? Colors.blueAccent
                                          : Colors.greenAccent))),
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
                                        : DateTime.parse(data["enddate"])
                                                    .compareTo(DateTime.parse(
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(DateTime
                                                                .now()))) ==
                                                0
                                            ? const Icon(
                                                Icons.change_circle_outlined,
                                                color: Colors.greenAccent,
                                              )
                                            : const Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                              ),
                                    DateTime.parse(data["enddate"]).compareTo(
                                                DateTime.parse(DateFormat(
                                                        'yyyy-MM-dd')
                                                    .format(DateTime.now()))) <
                                            0
                                        ? const Text("Completed ")
                                        : DateTime.parse(data["enddate"])
                                                    .compareTo(DateTime.parse(
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(DateTime
                                                                .now()))) ==
                                                0
                                            ? const Text("Ongoing")
                                            : const Text("Volunteers Call")
                                  ],
                                ) //COMPLETED ICON
                              ],
                            ),
                            //event name
                            const SizedBox(
                              height: 10,
                            ),
                            FadeInImage.assetNetwork(
                              placeholder: "assets/loading.gif",
                              image: data["poster"],
                            ), //event photo

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
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis
                              ,// chrck
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
                            !data['call_off']
                                ? Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red),
                                            child: const Text("CALL OFF EVENT"),
                                          ),
                                          ElevatedButton(
                                            onPressed: ()async {
                                              await FirebaseFirestore.instance.collection("events").doc(data["eventname"]).update({"mark":true});
                                              setState(() {

                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.greenAccent),
                                            child: const Text(" MARK AS DONE "),
                                          )
                                        ],
                                      ), //CALL OFF EVENT MARK AS DONE
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Modifyevents(id:widget.id,data:data)));
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.brown),
                                            child: const Text("MODIFY DETAILS"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          volunteerslist(id: widget.id,after:false)));
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blueGrey),
                                            child: const Text("VOLUNTEERS"),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        volunteerslist(id: widget.id,after:true)));
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blueGrey),
                                          child: const Text("VOLUNTEERS"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.brown),
                                          child: const Text("DETAIILS"),
                                        )
                                      ],
                                    ),
                                  ), // MODIFY DETAILS MARK AS DONE
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //postdetailcontainer
                const SizedBox(
                  height: 10,
                ),
              ],
            );
  }
}