import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoShow extends StatefulWidget {
  final String img;
  PhotoShow({super.key, required this.img}) ;
  @override
  State<PhotoShow> createState() => _PhotoShowState();
}

class _PhotoShowState extends State<PhotoShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  backgroundColor: Colors.black,
        elevation: 0,),
      body: PhotoView(
        imageProvider: NetworkImage(widget.img),
      ),
    );
  }
}
