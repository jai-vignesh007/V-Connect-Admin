import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Utils.dart';
import 'drawer.dart';


class AddVol extends StatefulWidget {
  const AddVol({super.key});

  @override
  State<AddVol> createState() => _AddVolState();
}

class _AddVolState extends State<AddVol> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();



  @override
  void dispose() {
    email.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "ADD VOLUNTEER",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
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
          backgroundColor: Colors.white,
        ),
        drawer: const Draw(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 50, left: 50),
              child: TextField(
                controller: name,
                decoration: const InputDecoration(hintText: "NAME"),
              ),
            ),
           const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50, left: 50),
              child: TextFormField(
                controller: email,
                decoration: const InputDecoration(hintText: "MAIL ID"),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50, left: 50),
              child: SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    signUp();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff83ccad),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                  child:  const Text("ADD"),
                ),
              ),
            ),
           const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50, left: 50),
              child: SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    UploadAll();

                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                  child:const Text("UPLOAD EXCEL"),
                ),
              ),
            )
          ],
        ));
  }

  // ignore: non_constant_identifier_names
  UploadAll() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx','xlsm'],
        allowMultiple: false,
      );

      /// file might be picked

      if (pickedFile != null) {
        File file = File(pickedFile.files.single.path!);
        // var bytes = pickedFile.files.single.bytes;
        List<int> bytes = await file.readAsBytes();
        var excel = Excel.decodeBytes(bytes);
        for (var table in excel.tables.keys) {
         //sheet Name
          for (var row in excel.tables[table]!.rows) {
            try {
              var emailval = row[0]!.value.toString();
              var nameval = row[1]!.value.toString();
              try{
                emailval.split('@');
              }
              catch(e){
                Utils.showSnackBar("something wrong");
              }

              await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                  email: emailval.trim(), password: "welcome@123")
                  .then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(value.user?.uid)
                    .set({
                  "name":nameval ,
                  "email": emailval,
                  "hours":0,
                  "year":"-",
                  "dept":'-',
                  "gender":'-',
                  'attendance':[],
                  'blood Group':'-'
                });
                Utils_g.showSnackBar("successfully added");
              });
            }catch(e){
              Utils_g.showSnackBar("Something went wrong");
            }
          }
        }
      }

    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: "welcome@123")
          .then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(value.user?.uid)
            .set({
          "name": name.text,
          "email": email.text,
          "hours":0,
          "year":"-",
          "dept":'-',
          "gender":'-',
          'attendance':[],
          'blood Group':'-'
            });
        Utils_g.showSnackBar("successfully added");
      });



    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}
