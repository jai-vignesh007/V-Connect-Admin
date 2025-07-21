import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nssadmin/slidephotoview.dart';
import 'addxtra_evnt_img.dart';

var del;
var url;
var del_list;
class GalleryView extends StatefulWidget {
  final String eventname;
  GalleryView(this.eventname);

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {

  getdata()async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseFirestore.instance.collection("gallery_imgs").doc(
          widget.eventname).get().then((value) {
        setState(() {
          url = value["url"];
        });
      });
      if(url.length == 0){
        url=null;
      }
    }
    catch(e){
      url=null;
    }
    Navigator.pop(context);

  }
  @override
  void initState() {
    getdata();
    del = false;
    del_list = [];
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe5e5e5),
      appBar: AppBar(
        elevation: 0,
        leading: const Icon(
          Icons.menu,
          size: 35,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          widget.eventname,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                onPressed: () async{

                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator()));
                  if(del){
                    for(var i in del_list){
                      await FirebaseStorage.instance
                          .refFromURL(url[i])
                          .delete();
                      await FirebaseFirestore.instance.collection("gallery_imgs").doc(widget.eventname).update({'url':FieldValue.arrayRemove([url[i]])});
                      // url.removeAt(i);
                    }
                    setState(() {
                      del = !del;
                      del_list = [];
                    });
                    getdata();

                  }
                  Navigator.pop(context);

                },
                icon: !del
                    ? const Icon(
                  Icons.delete,
                  size: 35,
                  color: Colors.black,
                )
                    : const Icon(
                  Icons.check,
                  size: 35,
                  color: Colors.black,
                ),
              )),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Addimg(widget.eventname)));
            },
            icon: const Icon(
              Icons.add,
              size: 35,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Img(context),
    );
  }



  Widget Img(BuildContext context) {
    final DocumentReference docRef = FirebaseFirestore.instance
        .collection('gallery_imgs')
        .doc(widget.eventname);

    return url!=null?GridView.builder(
      itemCount: url.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
      itemBuilder: (BuildContext context, int index) {

        var str = url[index];
        return GestureDetector(onLongPress: (){
          setState(() {
            del = !del;
          });
        },child: Cuming( index: index,str: str,));
      },
    ):const Center(child: Text("NO IMAGES"),);

  }




}




class Cuming extends StatefulWidget {
  int index;
  String str;
  Cuming({required this.index , required this.str});

  @override
  State<Cuming> createState() => _CumingState();
}

class _CumingState extends State<Cuming> {
  var tick = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tick = true;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(!del) {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => PhotoViewPage(photos: url, index:widget.index)));
        }
        else{
          setState(() {
            tick = !tick;
          });
          if(!tick){
            del_list.add(widget.index);
          }
          else{
            del_list.remove(widget.index);
          }
        }
      },

      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          color: Colors.black,
          child: GridTile(
            header: del
                ? Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:Icon(
                  !tick
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 30,
                  color: Colors.grey,
                ),
              ),

            )
                : null,
            child: Image.network(
              widget.str,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
