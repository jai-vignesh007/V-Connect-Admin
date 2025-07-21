// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';

class EventReport extends StatefulWidget {
  const EventReport({super.key});

  @override
  State<EventReport> createState() => _EventReportState();
}

class _EventReportState extends State<EventReport> {
  String selectedValue = 'SELECT EVENT', dropdownvalue1 = "date";
  var i;
  TextEditingController date = TextEditingController();
  DateTime? start,end;
  var en = false;
  var event;
  DateFormat format = DateFormat('yyyy-MM-dd');
  var list_;
  // List of items in our dropdown menu
  var items = [
    "SELECT EVENT",
  ];
  var date_ = [];

  String id = "STUDENT ID";
  String attval = "MARK AS IN/OUT",
      attval1 = "MARK AS IN",
      attval2 = "MARK AS OUT";

  var attmark = 0;
  var defaults = 0xffB8B1B1, green = 0xff82CC76, red = 0xffEB787D;
  String dropdownvalue = 'SELECT EVENT';

  var accept=[];
  Future<void> getdata() async {
    await FirebaseFirestore.instance.collection("events").orderBy("Timestamp").get().then((value){
      for(var i in value.docs){
        if(DateTime.parse(i["startdate"])    .compareTo(DateTime.parse(
            DateFormat('yyyy-MM-dd')        .format(DateTime
                .now()))) >=0) {
          items.add(i["eventname"]);
          date_.add([i["startdate"], i["enddate"]]);
        }
      }
    });
    setState(() {
      items;
    });
  }

  Future<void> Vol_list() async {

    await FirebaseFirestore.instance.collection("events").doc(event).get().then((value){
      accept = value["accept"];
    });

    await FirebaseFirestore.instance.collection("events").doc(event).collection("attendance").doc(date.text.split(' ')[0]).get().then((value) {
      list_ = value.data()?.keys.toList();
    } );
    list_ ??= [];
setState(() {
  accept;
});

  }
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    date.text = "date";

 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      appBar: AppBar(
          backgroundColor: Colors.white,

          leading: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          centerTitle: true,
          title: const Text(
            "EVENT ATTANDANCE",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: Text(
                        'Select Item',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                          .toList(),
                      value: dropdownvalue,
                      onChanged: (value) {
                        event = value;


                        var a = items.indexOf(value!);
                        setState(() {
                          dropdownvalue = value;
                          start =  format.parse(date_[a-1][0]);
                          end = format.parse(date_[a-1][1]);
                          en=true;
                          date.text = "date";

                        });
                      },
                      buttonDecoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 17, 16, 16)),
                        ),
                      ),
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownWidth: 160,
                      dropdownPadding: null,
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: TextField(
                controller: date,
                enabled: en,
                //editing controller of this TextField
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: start!,
                      firstDate: start!,
                      //DateTime.now() - not to allow to choose before today.
                      lastDate:end!,
                      builder: ( context, child)
                      {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme:const ColorScheme.light(
                                primary: Colors.black,
                                onPrimary: Colors.white,
                                surface: Colors.red,
                                onSurface: Colors.black
                            ),
                          ),
                          child: child!,
                        );
                      }
                  );

                  if (pickedDate != null) {
                    //pickedDate output format => 2021-03-10 00:00:00.000

                    setState(() {
                      date.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      //set output date to TextField value.

                      Vol_list();
                    });
                  } else {}

                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 45, left: 60, right: 60),
                child: SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: TextField(
                      cursorColor: Colors.black,
                      onChanged: (a)async{
                        var acc=[];
                        await FirebaseFirestore.instance.collection("events").doc(event).get().then((value){
                          accept = value["accept"];
                        });
                        for(var i in accept){
                          if(i["email"].startsWith(a) || i["name"].toLowerCase().startsWith(a)){
                            acc.add(i);
                          }
                        }
                        setState(() {
                          accept = acc;
                        });
                      },

                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        suffixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        hintText: "Search ID or Name",

                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ))),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Container(
                  width: double.infinity,
                  decoration:  const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(12),topLeft: Radius.circular(12)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "VOLUNTEER LIST",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: accept == null?0: accept.length,
                        itemBuilder:(context,index){
                          return  Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 18),
                                  child: SizedBox(
                                    width: 100,
                                    child: Column(
                                      children: [
                                        Text(
                                            accept[index]["name"].toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                           accept[index]["email"].split('@')[0],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w100),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  width: 100,
                                  child: list_!.contains(accept[index]["email"].split('@')[0])? const Text(
                                    "Attend",
                                    textAlign: TextAlign.center,

                                    style:
                                    TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                  ):
                                  const Text(
                                    "Not Reported",
                                    textAlign: TextAlign.center,
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}