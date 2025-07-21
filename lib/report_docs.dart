// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Report_docs extends StatefulWidget {
  final String eventname;
  const Report_docs({super.key, required this.eventname});

  @override
  State<Report_docs> createState() => _Report_docsState();
}

class _Report_docsState extends State<Report_docs> {
   File? file;
   String? url;
   var load = true;
   // PDFDocument doc;
  Future<String?> uploadPdfToStorage() async {
    try {
      final path = 'report/${widget.eventname}';
      Reference ref = FirebaseStorage.instance.ref().child(path);

      UploadTask uploadTask = ref.putFile(file!);

      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      load = true;
      url = await snapshot.ref.getDownloadURL();

      setState(() {

      });
      await FirebaseFirestore.instance.collection('events').doc(widget.eventname).set({'report':url,},SetOptions(merge: true));
      return url;
    } catch (e) {
      return "";
    }
  }

  Future getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pdf','doc','docx']);

    if (result != null) {
      file = File(result.files.single.path!);
      setState(() {
        load=false;
      });

    } else {
      load = false;
    }
  }
   //
   // CollectionReference _collectionRef =
   // FirebaseFirestore.instance.collection('report');
   //
   // List<String> alldata = [];
get_url()async{
    try {
      await FirebaseFirestore.instance.collection("events").doc(
          widget.eventname).get().then((value) {
        url = value["report"];
      });
    }
    catch(e){
      url ="";
    }
 setState(() {
   url;
 });
}
  @override
   void initState() {

    get_url();
     super.initState();

   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.eventname,style: const TextStyle(color: Colors.black),),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back,color: Colors.black,)
        ),
        actions: [IconButton(
          onPressed: ()async{
    await getImage();
    await uploadPdfToStorage();
    // _pdfViewerKey.currentState?.openBookmarkView();
    },
      icon: const Icon(Icons.add,color: Colors.black,))],
      ),
      body: url != "" && url != null?SfPdfViewer.network(
        url.toString()
      ):url==null?const Center(child: LinearProgressIndicator()):const Center(child: Text("NO FILE"),),
    );
  }
}

