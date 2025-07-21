// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, use_build_context_synchronously, library_private_types_in_public_api

import 'photoview.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Profile extends StatefulWidget {
  var email;
  Profile({super.key, required this.email});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var data,id;
  TextEditingController hours = TextEditingController();
  getdata()async{
    await FirebaseFirestore.instance.collection("users").where("email",isEqualTo: widget.email).get().then((value){
      data = value.docs.first.data();
      id = value.docs.first.id;
    });
    try {
      print(data["number"]);
    }
    catch(e){
      print('pp');
    }
    setState(() {
      data;
    });
  }
  String trying(String val){
    try{
      return data.prof_data![val];
    }
    catch(e){
      return "Yet to fill";
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe5e5e5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Working Hours'),
                content: SizedBox(
                  height: 50,
                  child: TextField(
                    controller: hours,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(

                      hintText: "Enter The Hours",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      hours.text = "";
                      Navigator.pop(context, 'Cancel');},
                    child: const Text('Cancel',style: TextStyle(color: Colors.red),),
                  ),
                  TextButton(
                    onPressed: ()async{
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(child: CircularProgressIndicator()));
                      Navigator.pop(context);
                      await FirebaseFirestore.instance.collection("users").doc(id).set({"hours":data["hours"]+int.parse(hours.text)},SetOptions(merge: true));
                      hours.text = "";
                      await getdata();
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK',style: TextStyle(color: Colors.blue),),
                  ),
                ],
              ),
            );
          }, icon: const Icon(Icons.add,color: Colors.black,)),
        ],
        title: const Text("PROFILE",style: TextStyle(color: Colors.black),),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back,color: Colors.black,),
        ),
      ),
      body: data != null ?ListView(
        children: <Widget>[
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoShow(img: data!['profile_img'])));
                },
                child: Container(
                  color: const Color(0xffe5e5e5),
                  child: AvatarGlow(
                    startDelay: const Duration(milliseconds: 1000),
                    glowColor: Colors.indigoAccent,
                    endRadius: 100.0,
                    duration: const Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: const Duration(milliseconds: 100),
                    shape: BoxShape.circle,
                    animate: true,
                    curve: Curves.fastOutSlowIn,
                    child: Material(
                      elevation: 8.0,
                      shape: const CircleBorder(),
                      color: Colors.transparent,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(data!['profile_img']),
                        radius: 65.0,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.48,
                    child: Text(data!['name'],style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.48,
                    child: Text(data!['stud_id'],style: const TextStyle(fontSize: 18),),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width*0.48,
                      child: Text("${data!['dept']}-${data!['section']} | (${data!['year']}-year)",style: const TextStyle(fontSize: 16),)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.48,
                    child: data!['branch']!=null?Text(data!['branch'],style: const TextStyle(fontSize: 18),):Text("NOT SET"),
                  ),
                ],
              ),
            ],
          ),
          Contain(txt1: "DATE OF BIRTH", txt2: data!['dob']),
          Contain(txt1: "CONTACT NUMBER", txt2: data!['number']),
          Contain(txt1: "GENDER", txt2: data!['gender']),
          Contain(txt1: "MODE TO COLLEGE", txt2: data!['mode']),
          Contain(txt1: "UNIVERSITY NUMBER", txt2: trying('regnumber')),
          Contain(txt1: "BLOOD GROUP", txt2: data!['blood Group']),
          Contain(txt1: "WORKING HOURS", txt2: data!['hours'].toString()),
          Contain(txt1: "BRANCH", txt2: trying('branch')),
          Contain(txt1: "AADHAR NUMBER", txt2: data!['aadhar']),
          Contain(txt1: "COMMUNITY", txt2: data!['community']),
          Contain(txt1: "ADDRESS", txt2: "${data!['flat_no']},${data!['street1']}\n${data!['street2']}\n${data!['pin_code']}")

        ],
      ) : const Center(child: CircularProgressIndicator()),
    );
  }
}

class Contain extends StatelessWidget {
  final String? txt1;
  final String? txt2;
  const Contain({super.key, @required this.txt1,@required this.txt2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Row(
        children: [
          Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(txt1!,style: const TextStyle(color: Colors.white),),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(txt2!,style: const TextStyle(fontSize: 18,color: Colors.black),),
          ),
        ],
      ),
    );
  }
}