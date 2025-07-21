
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'Utils.dart';
import 'drawer.dart';



class Add_Working_Hours extends StatefulWidget {
  const Add_Working_Hours({Key? key}) : super(key: key);

  @override
  State<Add_Working_Hours> createState() => _Add_Working_HoursState();
}

class _Add_Working_HoursState extends State<Add_Working_Hours> {

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
              print(row);
              var UserId = row[0]!.value.toString();
              var hours_ = row[1]!.value;


             
               await FirebaseFirestore.instance
                    .collection('users')
                    .where("email",isEqualTo: UserId).get().then((value) async{
                      var hours = value.docs.first.get('hours') + hours_;
                      await FirebaseFirestore.instance.collection("users").doc(value.docs.first.id).set({"hours":hours},SetOptions(merge: true));
               });
                Utils_g.showSnackBar("successfully added");
              
            
          }
        }
      }

    }  catch (e) {
      Utils.showSnackBar("USER SIDE APPROVAL ERROR");
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ADD WORKING HOURS",
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
      ),
    );
  }
}
