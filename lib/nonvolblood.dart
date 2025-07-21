// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'addnonblood.dart';
import 'drawer.dart';
class NonVol_blood extends StatefulWidget {
  const NonVol_blood({Key? key}) : super(key: key);

  @override
  State<NonVol_blood> createState() => _NonVol_bloodState();
}

class _NonVol_bloodState extends State<NonVol_blood> {

  var details,user;
  DateFormat format = DateFormat('yyyy-MM-dd');
var show = true;




  getData()async{

try {
  await FirebaseFirestore.instance.collection("blood")
      .doc("non_volunteer")
      .get()
      .then((value) {
    user = value["history"];
  });

  setState(() {
    user;
  });
}
catch(e){
  setState(() {
    show = false;
  });

}
  }
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe5e5e5),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 70,
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
        title: SizedBox(
          height: 50,
          width: double.infinity,
          child: TextField(
            controller: search,
            onChanged: (i)async{
              // setState(() {
              //   load = true;
              // });
       user = [];
      var a = [];
              FirebaseFirestore ins = FirebaseFirestore.instance;
             await ins.collection("blood").doc("non_volunteer").get().then((value){
               for( var i in value["history"]){
                 if(i["name"].toLowerCase().startsWith(search.text.toLowerCase()) || i["stud_id"].toLowerCase().startsWith(search.text.toLowerCase())){
                   a.add(i);
                 }
               }
             });

              setState(() {
                user = a;
                // load = false;
              });
            },

            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: "Search",
                suffixIcon: const Icon(Icons.search_rounded),
                fillColor: const Color(0xffdadada),
                filled: true),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddNonBlood()));
              },
              icon: const Icon(
                Icons.bloodtype,
                size: 35,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      drawer: const Draw(),
      body: RefreshIndicator(
        onRefresh: ()async{
          getData();
        },
        child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 45, bottom: 35),
                  child: Text(
                    "NON VOLUNTEERS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: Material(
                    elevation: 10,
                    child: Container(
                      height: 35,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            'NAME',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                          ),
                          Text(
                            'BLOOD TYPE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                          ),
                          Text(
                            'CONTACT',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                 user != null? Expanded(
                  // height: 300,
                  // width: double.infinity,
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: user.length,
                        itemBuilder: (context,index){
                          // var a =  format.parse(details[index]["date"]);
                          // var dif =DateTime.now().difference(a).inDays;
                          // print(dif);
                          // print(user[index]);
                          return  Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: SizedBox(
                                      width: 100,
                                      child: Column(
                                        children: [
                                          Text(
                                            user[index]["name"],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            user[index]["stud_id"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w100),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                     user[index]["blood"],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: SizedBox(
                                      width: 90,
                                      child: Column(
                                        children: [
                                          Text(
                                             user[index]["number"],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            user[index]["street"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w100),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } )
                ):
                     !show?const Text("NO RECORDS",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),):const Center(child: CircularProgressIndicator(),),

              ],
            )),
      ),
    );
  }
}
