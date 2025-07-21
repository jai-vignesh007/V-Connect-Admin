import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nssadmin/drawer.dart';
import 'Utils.dart';
import 'postevent.dart';
import 'modifydetails.dart';
import 'volunteer_list.dart';
import 'package:page_transition/page_transition.dart';
import 'eventsview.dart';
import 'package:cached_network_image/cached_network_image.dart';
class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);
  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  // ignore: prefer_typing_uninitialized_variables
  var querySnapshot;
  Future<void> get() async {
    setState(()  {
      querySnapshot = FirebaseFirestore.instance.collection('events').orderBy('Timestamp',descending: true).limit(7).snapshots();
    });
  }
  var search="";
  TextEditingController control = TextEditingController();
  @override
  void initState() {
    get();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },),

        centerTitle: true,
        title: const Text(
          "EVENTS",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      backgroundColor: const Color(0xffe5e5e5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: control,
                    onChanged: (value) {
                      setState(() {
                        if(value !="") {
                          querySnapshot =
                           FirebaseFirestore.instance.collection('events')
                              .where('eventname', isGreaterThanOrEqualTo: value)
                              .where('eventname', isLessThan: '${value}z').limit(7)
                              .snapshots();
                        }
                          else{
                          querySnapshot =  FirebaseFirestore.instance.collection('events').orderBy('Timestamp',descending: true).limit(7).snapshots();


                        }
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
                ), //search bar
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        PageTransition(child: const PostEvent(), type:PageTransitionType.rightToLeftWithFade,duration:const Duration(milliseconds: 400))
                    );
                  },
                  child:const Icon(
                    CupertinoIcons.plus,
                    // Icons.add,
                    color: Colors.black,
                    size: 140,
                  ),
                ), //add photo
              const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration:  const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 4.0, color: Colors.black))),
                  child:const Text(
                    "POSTED EVENTS",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                NewBuild(context),
              ],
            ),
          ],
        ),
      ),
      drawer:const Draw(),
    );
  }

  // ignore: non_constant_identifier_names
  Widget NewBuild(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: querySnapshot,

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        return Column(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            String id = document.id;
            return  Column(
              children: [
                const SizedBox(height: 10),
                Column(
                  children: [
                    Container(
                      // color: Colors.red,
                      margin: const EdgeInsets.only(left: 10,right: 10),
                      decoration: BoxDecoration(

                          color: Colors.white,

                        gradient:  LinearGradient(
                            stops: const [0.02, 0.02],
                            colors: !data["mark"]
                                      ? [Colors.red,Colors.white]
                                      : DateTime.parse(data["enddate"])
                                      .compareTo(DateTime.parse(
                                      DateFormat('yyyy-MM-dd')
                                          .format(DateTime
                                          .now()))) <
                                      0
                                      ? [Colors.greenAccent,Colors.white]:
                                  DateTime.parse(data["startdate"]).compareTo(
                                      DateTime.parse(DateFormat(
                                          'yyyy-MM-dd')
                                          .format(DateTime.now()))) <=
                                      0?[ Colors.lightBlue,Colors.white]:
                                 [ Colors.black,Colors.white]
                        ),
            borderRadius: const BorderRadius.all( Radius.circular(10)),
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
                                      data["eventname"],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )), //EVENT NAME
                                const  Spacer(),
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
                                        0 ? const Icon(
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
                                   : const Icon(
                                      Icons.group
                                    ),
                                    !data['mark']? const Text("Volunteers Call")
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
                                        : const Text("Volunteer CallOver")

                                  ],
                                ) //COMPLETED ICON
                              ],
                            ),
                            //event name
                            const SizedBox(
                              height: 10,
                            ),

                             // FadeInImage.assetNetwork(
                             //   placeholder: "assets/loading.gif",
                             //   image: data["poster"],
                             // ), //event photo
                            CachedNetworkImage(
                              imageUrl: data["poster"],
                              placeholder: (context, url) => Image(image: AssetImage("assets/loading.gif")),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                // ignore: prefer_interpolation_to_compose_strings
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
                               ,
                               textAlign: TextAlign.left,
                             ), //DESCRIPTION
                            const  SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "TO BE HELD: ${data['startdate']}",
                                textAlign: TextAlign.left,
                              ),
                            ),
                            DateTime.parse(data["enddate"])
                                .compareTo(DateTime.parse(
                                DateFormat('yyyy-MM-dd')
                                    .format(DateTime
                                    .now()))) >=
                                0
                                ? Column(
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: ()async {
                                        Alert_box().showAlertDialog(context, "Are you Confirm to Call off?", () {Navigator.pop(context); }, () async {
                                          await FirebaseFirestore.instance.collection("events").doc(data["eventname"]).delete();
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        });

                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child:const Text("CALL OFF EVENT"),
                                    ),
                                 data["mark"]?
                                 ElevatedButton(
                                   onPressed: ()async {

                                     Alert_box().showAlertDialog(context, "Are you Confirm?", () {Navigator.pop(context); }, () async {

                                       await FirebaseFirestore.instance.collection("events").doc(data["eventname"]).update({"mark":false});
                                       // ignore: use_build_context_synchronously
                                       Navigator.pop(context);
                                     });
                                   },
                                   style: ElevatedButton.styleFrom(
                                       backgroundColor: Colors.redAccent),
                                   child:const Text(" REMOVE MARK "),
                                 )
                                     :   ElevatedButton(
                                      onPressed: ()async {

                                        Alert_box().showAlertDialog(context, "Are you Confirm?", () {Navigator.pop(context); }, () async {
                                          await FirebaseFirestore.instance.collection("events").doc(data["eventname"]).update({"mark":true});

                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        });
                                        // Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.greenAccent),
                                      child:const Text(" MARK AS DONE "),
                                    )
                                  ],
                                ), //CALL OFF EVENT MARK AS DONE
                                const  SizedBox(height: 15),
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
                                                    Modifyevents(id:id,data:data)));
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
                                                    volunteerslist(id: id,after:false)));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueGrey),
                                      child: const Text("   VOLUNTEERS   "  ),
                                    )
                                  ],
                                ),
                              ],
                            )
                                : Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  volunteerslist(id: id,after:true)));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueGrey),
                                    child:const Text("VOLUNTEERS "),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Eventview(eventname: id)));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.brown),
                                    child:const Text("DETAIILS"),
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

                const SizedBox(
                  height: 10,
                ),
              ],
            );

             }).toList(),
        );
        },

    );
  }
}






