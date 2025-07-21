import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nssadmin/profile.dart';


class FeedView extends StatefulWidget {
  var id;
  FeedView({required this.id});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  var alldata = [];
  getdata()async{
    await FirebaseFirestore.instance.collection("feedback").doc(widget.id).get().then((value){
      alldata = value["feedback"];
    });
    setState(() {
      alldata;
    });
  }
  @override
  void initState() {
    print(widget.id);
    print("---");
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 70,
        title:  Text(
          widget.id,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){},icon: const Icon(Icons.menu,color: Colors.black,size: 30,),),
      ),
      backgroundColor: const Color(0xffe5e5e5),
      body: alldata.length >0? ListView.builder(
        physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    itemCount: alldata.length,
    itemBuilder:(context,index){
          return Padding(
            padding:  EdgeInsets.only(left: 20,right: 20,top: 20),
            child: Material(
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(8),

                ),
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(alldata[index],textAlign: TextAlign.center,),
                ) ,
              ),
            ),
          );
    }
      ):Center(child: CircularProgressIndicator(),),
    );

  }
}
