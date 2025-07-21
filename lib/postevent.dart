// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages, empty_catches, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'postsucess_events.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class PostEvent extends StatefulWidget {
  const PostEvent({super.key});

  @override
  State<PostEvent> createState() => _PostEventState();
}

class _PostEventState extends State<PostEvent> {
  TextEditingController Eventname = TextEditingController();
  TextEditingController startcontroller = TextEditingController();
  TextEditingController endcontroller = TextEditingController();
  TextEditingController No_days = TextEditingController();
  TextEditingController No_vol = TextEditingController();
  TextEditingController Event_Details = TextEditingController();
  TextEditingController No_Hours = TextEditingController();
  String startdate = "";
  String enddate = "";
  File? image;
  bool z = false;
  bool next = false;
  String url = '';
  var urldownload;


  sendNotificationToTopic(String title,String body)async{

    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };

    try{
      http.Response response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: <String,String>{
        'Content-Type': 'application/json',
        'Authorization': KEY
      },
          body: jsonEncode(<String,dynamic>{
            'notification': <String,dynamic> {'title': title,'body': body},
            'priority': 'high',
            'data': data,
            'to': '/topics/subscription'
          })
      );


      if(response.statusCode == 200){

      }else{

      }

    }catch(e){

    }
  await FirebaseFirestore.instance.collection("users").get().then((value)async{
    for(var i in value.docs){
      await FirebaseFirestore.instance.collection("notification").doc(i["email"]).set({
        "notifications":FieldValue.arrayUnion([{"title":title,"body":body ,"time":DateTime.now()}])
      },SetOptions(merge: true));
    }
  });
  }

  PlatformFile? pickedfile;
  UploadTask? uploadTask;
  Future uploadimage() async {
    final path = 'files/${Eventname.text.toString()}';
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(image!);
    final snapshot = await uploadTask!.whenComplete(() {});
    urldownload = await snapshot.ref.getDownloadURL();
    //   url = urldownload.toString();
    setState(() {
      next = true;
    });
    // print(type == (urldownload));
  }

  Future getImage() async {
    try {
      final image_ = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 70);
      if (image_ == null) return;
      setState(() {
        image = File(image_.path);
        z = true;
      });
    } on PlatformException {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xffE5E5E5),
        appBar: AppBar(
            backgroundColor: Colors.white,

            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
            ),
            centerTitle: true,
            title: const Text(
              "POST EVENT",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [

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
                          //icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Start Date" //label text of field
                          ),
                      readOnly: true,
                      //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(DateTime.now().year + 2),
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
                          //icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "End Date" //label text of field
                          ),
                      readOnly: true,
                      //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(DateTime.now().year + 2),
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
                            });

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
                  padding: const EdgeInsets.only(top: 20, left: 55, right: 55),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextField(
                        controller: No_Hours,
                        decoration: const InputDecoration(labelText: "No of Hours"),
                        keyboardType: TextInputType.number),
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
                !z
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
                       showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    const Center(child: CircularProgressIndicator())
                       );
                        await uploadimage();
                        await FirebaseFirestore.instance
                            .collection("events")
                            .doc(Eventname.text.toString())
                            .set({
                          "eventname": Eventname.text.toString(),
                          "startdate": startdate,
                          "enddate": enddate,
                          "No_of_days": No_days.text.toString(),
                          "No_of_vol": No_vol.text.toString(),
                          "description": Event_Details.text.toString(),
                          "poster": urldownload,
                          "mark": false,
                          "call_off": false,
                          "posted": DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          "Timestamp":FieldValue.serverTimestamp(),
                          "No_of_Hours":No_Hours.text.toString(),
                          "accept":[],
                          "decline":[],
                          "request":[],

                        });
                        FirebaseFirestore.instance.collection("gallery_imgs").doc(Eventname.text).set({"name":Eventname.text});
                        sendNotificationToTopic("ANNOUNCEMENT", "new event has been posted - ${Eventname.text.toString()}");
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Success()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff83CCAD),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          elevation: 10,
                          shadowColor: Colors.black),
                      child: const Text(
                        "POST",
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
