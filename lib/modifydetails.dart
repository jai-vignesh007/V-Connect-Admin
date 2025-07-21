// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'drawer.dart';
import 'postsucess_events.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Modifyevents extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;
  const Modifyevents({super.key,  required this.id,
              required this.data,
  });

  @override
  State<Modifyevents> createState() => _Modifyevents();
}

class _Modifyevents extends State<Modifyevents> {
  TextEditingController Eventname = TextEditingController();
  TextEditingController startcontroller = TextEditingController();
  TextEditingController endcontroller = TextEditingController();
  TextEditingController No_days = TextEditingController();
  TextEditingController No_vol = TextEditingController();
  TextEditingController Event_Details = TextEditingController();
  String startdate = "";
  String enddate = "";
  var mark;
  File? image;
  bool z = false;
  bool next = false;
  String url = '';
  var urldownload;
  PlatformFile? pickedfile;
  UploadTask? uploadTask;
  Future uploadimage() async {

    final path = 'files/${Eventname.text.toString()}';
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(image!);
    final snapshot = await uploadTask!.whenComplete(() {});
    urldownload = await snapshot.ref.getDownloadURL();

  }

  Future getImage() async {
    try {
      final image_ = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 70);
      if (image_ == null) return;
      setState(() {
        image = File(image_.path);
        z = true;
      });
    // ignore: empty_catches
    } on PlatformException {

    }
  }


  @override
  void initState() {
   Eventname.text = widget.data["eventname"];
   startcontroller.text = widget.data["startdate"];
   startdate = widget.data["startdate"];
   endcontroller.text = widget.data["enddate"];
   enddate = widget.data["enddate"];
   No_days.text = widget.data["No_of_days"];
   No_vol.text = widget.data["No_of_vol"];
   Event_Details.text = widget.data["description"];
   urldownload = widget.data["poster"];
   mark = widget.data["mark"];

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xffE5E5E5),
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                    size: 25,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },),
            centerTitle: true,
            title: const Text(
              "EVENT",
              textAlign: TextAlign.center,
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
        drawer: const Draw(),
        body: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text("POST EVENT",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 55, right: 55),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: Eventname,
                          decoration: const InputDecoration(labelText: "Event Name"),
                        ),
                      ),
                    ),
                    Padding(
                        padding:
                        const EdgeInsets.only(top: 20, left: 55, right: 55),
                        child: TextField(
                          controller: startcontroller,
                          //editing controller of this TextField
                          decoration: const InputDecoration(

                              labelText: "Start Date" //label text of field
                          ),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(DateTime.now().year + 2));

                            if (pickedDate != null) {
                              startdate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              setState(() {
                                startcontroller.text =
                                    startdate; //set output date to TextField value.
                              });
                            } else {}
                          },
                        )),
                    Padding(
                        padding:
                        const EdgeInsets.only(top: 20, left: 55, right: 55),
                        child: TextField(
                          controller: endcontroller,
                          //editing controller of this TextField
                          decoration: const InputDecoration(

                              labelText: "End Date" //label text of field
                          ),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(DateTime.now().year + 2));

                            if (pickedDate != null) {
                             //pickedDate output format => 2021-03-10 00:00:00.000
                              enddate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              setState(() {
                                endcontroller.text =
                                    enddate; //set output date to TextField value.
                              });
                            } else {}
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 55, right: 55),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextField(
                            controller: No_days,
                            decoration: const InputDecoration(labelText: "No of Days"),
                            keyboardType: TextInputType.number),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 55, right: 55),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: No_vol,
                          decoration: const InputDecoration(
                            labelText: "No of Volunteers",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 55, right: 55, bottom: 40),
                      child: SizedBox(
                        height: 180,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xffcc99ff),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                offset: Offset(
                                  5,
                                  5,
                                ),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                controller: Event_Details,
                                cursorColor: Colors.black,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.black),
                                maxLines: 5,
                                minLines: 5,
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText:
                                  "\nENTER A DETAIL\nDESCRIPTION ABOUT THE\nEVENT",
                                  hintStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  fillColor: const Color(0xffcc99ff), //0xff916E89
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                   urldownload != ""?
                    Padding(
                      padding: const EdgeInsets.only(left: 55, right: 55),
                      child: Stack(children: [
                        Container(
                          color: Colors.black,
                          height: 150,
                          width: double.infinity,
                          child: Image.network(
                            urldownload,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: () async{
                                setState(() {
                                  urldownload="";
                                  z = false;
                                });
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.white,
                              )),
                        )
                      ]),
                    ): !z
                       ? GestureDetector(
                     onTap: () {
                       getImage();
                     },
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: const [
                         Text(
                           "Select Image",
                           style: TextStyle(
                               fontWeight: FontWeight.bold, fontSize: 15),
                         ),
                         Icon(Icons.upload)
                       ],
                     ),
                   )
                        : Padding(
                      padding: const EdgeInsets.only(left: 55, right: 55),
                      child: Stack(children: [
                        Container(
                          color: Colors.black,
                          height: 150,
                          width: double.infinity,
                          child: Image.file(
                            image!,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  z = false;
                                });
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.white,
                              )),
                        )
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 85, right: 85),
                      child: SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            !next
                                ? showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    const Center(child: CircularProgressIndicator()))
                                : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Success()));

                           if(image != null) {
                             await uploadimage();
                           }

                            setState(() {
                              next = true;
                            });

                            if( Eventname.text != widget.data["eventname"]) {

                              await FirebaseFirestore.instance.collection("events").doc(Eventname.text).set(widget.data,SetOptions(merge: true));
                              await FirebaseFirestore.instance.collection("events").doc(widget.data["eventname"]).delete();
                              await FirebaseFirestore.instance.collection("gallery_imgs").doc(widget.data["eventname"]).get().then((value)async{
                                await FirebaseFirestore.instance.collection("gallery_imgs").doc(Eventname.text).set(value.data()!,SetOptions(merge: true));
                              });
                              await FirebaseFirestore.instance.collection("gallery_imgs").doc( widget.data["eventname"]).delete();
                            }
                              await FirebaseFirestore.instance
                                  .collection("events")
                                  .doc(Eventname.text.toString())
                                  .update({
                                "eventname": Eventname.text.toString(), //hellooo// copy from line 357 to 385 only using mouse No mouse lap touch pad pannita
                                "startdate": startdate,
                                "enddate": enddate,
                                "No_of_days": No_days.text.toString(),
                                "No_of_vol": No_vol.text.toString(),
                                "description": Event_Details.text.toString(),
                                "poster": urldownload,
                                "mark": mark,
                                "call_off": false,
                                "posted": DateFormat('yyyy-MM-dd').format(
                                    DateTime.now()),
                                "Timestamp": FieldValue.serverTimestamp()
                              });


                            Navigator.pop(context);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => const Success()));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff83CCAD),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)),
                              elevation: 10,
                              shadowColor: Colors.black),
                          child: const Text(
                            "UPDATE",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    )
                  ],
                ),
              ),
            )));
  }
}
