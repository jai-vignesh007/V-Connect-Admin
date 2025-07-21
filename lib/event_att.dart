// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'drawer.dart';
import 'Utils.dart';
import 'eventreport.dart';

class EventAtt extends StatefulWidget {
  const EventAtt({super.key});

  @override
  State<EventAtt> createState() => _EventAttState();
}


class _EventAttState extends State<EventAtt> {

  @override
  void initState() {
    super.initState();
    getdata();
    date.text = "Date";
  }

  TextEditingController date = TextEditingController();
  DateTime? start,end;
  List<int> hours_list=[0];
  var hour;
  var text_area = false,enable_val = false;

  Future<void> getdata() async {
  await FirebaseFirestore.instance.collection("events").get().then((value){
    for(var i in value.docs){
      if(DateTime.parse(i["enddate"])
          .compareTo(DateTime.parse(
          DateFormat('yyyy-MM-dd')
              .format(DateTime
              .now()))) >=0
      &&      DateTime.parse(i["startdate"]).compareTo(
          DateTime.parse(DateFormat(
              'yyyy-MM-dd')
              .format(DateTime.now()))) <= 0 ) {
        items.add(i["eventname"]);
        date_.add([i["startdate"], i["enddate"]]);
        var tint = int.parse(i["No_of_Hours"]);
        hours_list.add(tint as int);
      }
    }
  });
  setState(() {
    items;
  });
  }


  String dropdownvalue = 'SELECT EVENT';
  TextEditingController text = TextEditingController();

  // List of items in our dropdown menu
  var items = ["SELECT EVENT"],date_=[];
  var items1 = ["date", "25/02/22", "26/02/22"];

  String id = "STUDENT ID";
  String attval = "MARK HERE",
      attval1 = "MARK AS PRESENT",
      attval2 = "NOT A VOLUNTEER";

  var attmark = 0;
  var event;
  var defaults = 0xffB8B1B1, green = 0xff82CC76, red = 0xffEB787D;

  var name;
  var volunteers=false;
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;


    id = barcodeScanRes.substring(3);

    await FirebaseFirestore.instance.collection("events").doc(dropdownvalue).get().then((val){
      for(var i in val["accept"]){
        if(i["email"].split('@')[0] == id.toLowerCase()){
          volunteers = true;
          name = i["name"];
          break;
        }
        else{
          volunteers = false;
        }
      }
    });


    setState(() {
      id;
      if (volunteers) {
        defaults = green;
        attval = attval1;
      }
      else {
        defaults = red;
        attval = attval2;
      }
    });
  }
  var en = false;
  DateFormat format = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  text_area = !text_area;
                });
                //need to change................................
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.black,
                size: 28.0,
              ),
            ),
          ],
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },),
          centerTitle: true,
          title: const Text(
            "EVENT ATTANDANCE",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )),
      drawer:const  Draw(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/2.8),
                      child: DropdownButtonHideUnderline(
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
                            hour = hours_list[a];

                            setState(() {
                              dropdownvalue = value as String;
                              start =  format.parse(date_[a-1][0]);
                              end = format.parse(date_[a-1][1]);
                              en=true;
                              date.text = "Date";
                              text.text ="";
                              id = "STUDENT ID";

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
                    ),
                   const SizedBox(width: 25,),
                    GestureDetector(
                      onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const EventReport()));
                      },
                      child: Column(

                        children:const [
                             Icon(Icons.groups_outlined,size: 30,),
                          Text("Volunteer list"),

                        ],
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: TextField(
                  controller: date,
                  enabled: en,
                  //editing controller of this TextField
                  decoration:const InputDecoration(
                    focusedBorder:  UnderlineInputBorder(
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


                      setState(() {
                        enable_val = true;
                        date.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);//set output date to TextField value.
                        text.text = "";
                        id = "STUDENT ID";
                      });
                    } else {}

                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 75, left: 100, right: 100),
                child: SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: text_area?TextField(
                    controller: text,
                    enabled: enable_val,
                    onChanged: (i)async{
                      setState(() {
                        if(i == ""){
                          id = "STUDENT ID";
                        }
                        else {
                          id = i;
                        }
                      });
                      await FirebaseFirestore.instance.collection("events").doc(dropdownvalue).get().then((val){
                        for(var i in val["accept"]){
                          if(i["email"].split('@')[0] == id.toLowerCase()){
                            volunteers = true;
                            name = i["name"];
                            break;
                          }
                          else{
                            volunteers = false;
                          }
                        }
                      });


                      setState(() {
                        if (volunteers) {
                          defaults = green;
                          attval = attval1;
                        }
                        else {
                          defaults = red;
                          attval = attval2;
                        }
                      });
                    },
                  ): ElevatedButton(
                    onPressed: (){

                      if(dropdownvalue != 'SELECT EVENT' && date.text != "date") {
                        scanBarcodeNormal();
                      } else{

                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 10,
                        shadowColor: Colors.black

                        // foreground (text) color
                        ),
                    child: const Text(
                      "scan",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 85),
                child: Text(
                  id.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 19),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                    onPressed: () async{
                      var tempHr = 0;

                      await FirebaseFirestore.instance.collection("events").doc(dropdownvalue).collection("attendance").doc(date.text).get().then((value) {
                        try{
                          value[id.toLowerCase()];
                          volunteers = false;
                          Utils.showSnackBar("already marked");
                        }
                        // ignore: empty_catches
                        catch(e){}
                      });
                      if(volunteers){
                        await FirebaseFirestore.instance.collection("events").doc(dropdownvalue).collection("attendance").doc(date.text).set({id.toLowerCase():true},SetOptions(merge : true));
                        await FirebaseFirestore.instance.collection("users").where("stud_id",isEqualTo: id.toLowerCase()).get().then((value){
                         tempHr = value.docs.first["hours"]+hour;
                         FirebaseFirestore.instance.collection("users").doc(value.docs.first.id).set({"hours":tempHr, "attend":FieldValue.arrayUnion([dropdownvalue])},SetOptions(merge: true));
                         Utils_g.showSnackBar("Marked");
                                              });

                       volunteers = false;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(defaults),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0)),
                        elevation: 10,
                        shadowColor: Colors.black

                        // foreground (text) color
                        ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.check,
                            size: 28.0,
                          ),
                        ),
                        Text(
                          attval,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
