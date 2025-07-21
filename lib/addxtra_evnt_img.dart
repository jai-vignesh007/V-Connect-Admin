import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'postsuccess_gallery.dart';

class Addimg extends StatefulWidget {
  final String eventname;
  Addimg(String this.eventname);

  @override
  State<Addimg> createState() => _AddimgState();
}

class _AddimgState extends State<Addimg> {
  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? imageFileList = [];

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

  List<String> Url = [];

  Future uploadimage(File image, String name) async {
    final path = 'event/${widget.eventname}/$name';
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(image);

    final snapshot = await uploadTask!.whenComplete(() {});
    urldownload = await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Post Event Images")),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Text(
                  "Upload image",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
              ),
Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20),
                child: Text(
                  "Count - ${imageFileList!.length}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
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
                    child: Icon(
                      Icons.add_a_photo,
                      size: 300,
                    ),
                  )
                : CarouselSlider(
                    items: imageFileList
                        ?.map((i) => Stack(children: [
                      Container(
                        color: Colors.black,
                        height: 250,
                        width: double.infinity,
                        child: Image.file(
                        File(i.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                               imageFileList!.remove(i);
                              });
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.black,
                            )),
                      )
                    ]),

                    )
                        .toList(),
                    options: CarouselOptions(
                      height: 250,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: false,
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
              child: Icon(
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
                  shadowColor: Colors.black),
              onPressed: () async {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        Center(child: CircularProgressIndicator()));
                for (int i = 0; i < imageFileList!.length; i++) {
                  String a = imageFileList![i].name;
                  await uploadimage(File(imageFileList![i].path), a);
                  Url.add(urldownload.toString());
                }
                await FirebaseFirestore.instance
                    .collection('gallery_imgs')
                    .doc('${widget.eventname}')
                    .update({"url": FieldValue.arrayUnion(Url)});

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Success()));
              },
              child: Text(
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
