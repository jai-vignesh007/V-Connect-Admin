// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'postsuccess_gallery.dart';

class Postimg extends StatefulWidget {
  const Postimg({super.key});

  @override
  State<Postimg> createState() => _PostimgState();
}

class _PostimgState extends State<Postimg> {
  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? imageFileList = [];

  // image view
  //Image.file(File(imageFileList![index].path)
  var z = 0;
  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  var urldownload;
  PlatformFile? pickedfile;
  UploadTask? uploadTask;
  TextEditingController Eventname = TextEditingController();

  List<String> Url = [];

  Future uploadimage(File image, String name) async {
    final path = 'event/${Eventname.text}/$name';
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(image);

    final snapshot = await uploadTask!.whenComplete(() {});
    urldownload = await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Post Event Images")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 30),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Event Name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: TextField(
              controller: Eventname,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Upload image",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: z == 0
                ? GestureDetector(
                    onTap: () => {
                      selectImages(),
                      setState(() {
                        z = 1;
                      })
                    },
                    child: const Icon(
                      Icons.add_a_photo,
                      size: 300,
                    ),
                  )
                : CarouselSlider(
                    items: imageFileList
                        ?.map((i) => Container(
                            height: 70,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              // image: DecorationImage(
                              //     image: Image.file(File(imageFileList![i].path)),
                              //     )
                            ),
                            child: Image.file(
                              File(i.path),
                              fit: BoxFit.fill,
                            )))
                        .toList(),
                    options: CarouselOptions(
                      height: 200,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: GestureDetector(
              onTap: () => {
                selectImages(),
                setState(() {
                  z = 1;
                })
              },
              child: const Icon(
                Icons.add_circle_rounded,
                size: 60,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 10,
                  shadowColor: Colors.black

                  // foreground (text) color
                  ),
              onPressed: () async {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()));
                for (int i = 0; i < imageFileList!.length; i++) {
                  String a = imageFileList![i].name;
                  await uploadimage(File(imageFileList![i].path), a);
                  Url.add(urldownload.toString());
                  // print(urldownload);
                  // print(Url);
                }
                await FirebaseFirestore.instance
                    .collection('gallery_imgs')
                    .doc(Eventname.text)
                    .set({'url': FieldValue.arrayUnion(Url), 'name': Eventname.text},SetOptions(merge: true));
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Success()));
              },
              child: const Text(
                "     POST    ",
                style: TextStyle(fontSize: 19),
              ),
            ),
          )
        ],
      ),
    );
  }
}
