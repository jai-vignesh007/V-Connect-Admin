import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class RemoveVol extends StatelessWidget {

  final user = FirebaseAuth.instance.currentUser;
  var email = TextEditingController();

  RemoveVol({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "REMOVE VOLUNTEER",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading:const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 50, left: 50),
              child: TextField(
                decoration: InputDecoration(hintText: "NAME"),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50, left: 50),
              child: TextField(
                controller: email,
                decoration:const InputDecoration(hintText: "MAIL ID"),
              ),
            ),
            const   SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50, left: 50),
              child: SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    var l =[],c=0;
                  await FirebaseFirestore.instance.collection("users").get().then((value)async{
                    var val = value.docs;
                    for(var i in val){
                      var k = i.data();
                      if(k["gender"]=='-'){
                        print(k["name"]);
                        l.add({
                          "name":k["name"],
                          "email":k["email"],
                          "count":c
                        });
                        c+=1;
                        await FirebaseFirestore.instance.collection("users").doc(i.id).delete();
                      }
                    }
                    print('ppp');
                  });
                  await FirebaseFirestore.instance.collection('remove').doc('1').set({'data':l});
                  print('aa');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:const Color(0xffeb797c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                  child: const Text("REMOVE"),
                ),
              ),
            )
          ],
        ));
  }
}
