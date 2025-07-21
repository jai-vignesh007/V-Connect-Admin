// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_blood.dart';
import 'drawer.dart';

class Blood extends StatefulWidget {
  const Blood({super.key});

  @override
  State<Blood> createState() => _BloodState();
}

// ignore: duplicate_ignore
class _BloodState extends State<Blood> {
  // ignore: prefer_typing_uninitialized_variables
  var details,user;
  DateFormat format = DateFormat('yyyy-MM-dd');

  List<String> item_all = [
    'A+','A-','B','B+','AB+',"AB-",'O+','O-','-'
  ],

      avaliavility_all = ["available", "not available",'-'],
      H_D_all = ["H", "D",'-'];
  final List<String> items = [
        'A','A+','B','B+','AB+',"AB-",'O+','O-',
      ],
      avaliavility = ["available", "not available"],
      H_D = ["H", "D"];
  List<String> selectedItems = [], Selectedavailability = [], selectedH_D = [];

  getmuti()async{
    var itemfil = selectedItems , availfilt = Selectedavailability , hdfilter = selectedH_D;
    if(selectedItems.isEmpty){
    itemfil = item_all;
    }
    if(Selectedavailability.isEmpty){
      availfilt = avaliavility_all;
    }
    if(hdfilter.isEmpty){
      hdfilter = H_D_all;
    }


    Query val = FirebaseFirestore.instance.collection("users").where("blood Group",whereIn: itemfil);
    await val.get().then((value){
      user = value.docs.where((element) {
        var avail = "-";
        var type = '-';
        try {
          var dif = DateTime
              .now()
              .difference(element["last_donated"].toDate())
              .inDays;
          if(dif>120){
            avail = 'available';
          }
          else{
            avail = 'not available';
          }
        }
        catch(e){
          avail = 'available';
        }
        try{
          type = element['mode'];
          if(type == 'Hostler'){
            type = 'H';
          }
          else{
            type ='D';
          }
        }
        // ignore: empty_catches
        catch(e){}
        return availfilt.contains(avail) && hdfilter.contains(type);
      }).toList();
    });
    setState(() {
      user;
    });
  }
  
  getData()async{
    await FirebaseFirestore.instance.collection("users").limit(100).get().then((value)async{
       user = value.docs;
     });

setState(() {
  user;
});
  }
 TextEditingController search = TextEditingController();

@override
  void initState() {
    super.initState();
    getData();
  }

  // main we need to use query
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:const Color(0xffe5e5e5),

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
                size: 35,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: SizedBox (
          height: 50,
          width: double.infinity,
          child: TextField(
            controller: search,
            onChanged: (i)async{
              // setState(() {
              //   load = true;
              // });
              FirebaseFirestore ins = FirebaseFirestore.instance;
              QuerySnapshot data = await ins.collection("users").get();
              setState(() {
                user= data.docs.where((i){
                  String email = i["email"].toLowerCase();
                  String name = i['name'].toLowerCase();
                  return email.startsWith(search.text.toLowerCase()) || name.startsWith(search.text.toLowerCase());
                }).toList();
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
                    MaterialPageRoute(builder: (context) => const Add_Blood()));
              },
              icon:const Icon(
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
                "VOLUNTEERS",
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
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint:const Align(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              'BLOOD TYPE',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan,
                              ),
                            ),
                          ),
                          items: items.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              //disable default onTap to avoid closing menu when selecting an item
                              enabled: false,
                              child: StatefulBuilder(
                                builder: (context, menuSetState) {
                                  final isSelected =
                                      selectedItems.contains(item);
                                  return InkWell(
                                    onTap: () {
                                      isSelected
                                          ? selectedItems.remove(item)
                                          : selectedItems.add(item);
                                      getmuti();
                                      //This rebuilds the StatefulWidget to update the button's text
                                      setState(() {});
                                      //This rebuilds the dropdownMenu Widget to update the check mark
                                      menuSetState(() {});
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        children: [
                                          isSelected
                                              ? const Icon(
                                                  Icons.check_box_outlined)
                                              : const Icon(
                                                  Icons.check_box_outline_blank),
                                          const SizedBox(width: 16),
                                          Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                          //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                          value:
                              selectedItems.isEmpty ? null : selectedItems.last,
                          onChanged: (value) {},
                          buttonHeight: 40,
                          buttonWidth: 140,
                          itemHeight: 40,
                          itemPadding: EdgeInsets.zero,
                          selectedItemBuilder: (context) {
                            return items.map(
                              (item) {
                                return Container(
                                  alignment: AlignmentDirectional.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: const Text(
                                    "BLOOD TYPE",
                                    style: TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyan,
                                    ),
                                    maxLines: 1,
                                  ),
                                );
                              },
                            ).toList();
                          },
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint:const Align(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              'AVAILABILITY',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan,
                              ),
                            ),
                          ),
                          items: avaliavility.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              //disable default onTap to avoid closing menu when selecting an item
                              enabled: false,
                              child: StatefulBuilder(
                                builder: (context, menuSetState) {
                                  final isSelected =
                                      Selectedavailability.contains(item);
                                  return InkWell(
                                    onTap: () {
                                      isSelected
                                          ? Selectedavailability.remove(item)
                                          : Selectedavailability.add(item);
                                      getmuti();
                                      //This rebuilds the StatefulWidget to update the button's text
                                      setState(() {});
                                      //This rebuilds the dropdownMenu Widget to update the check mark
                                      menuSetState(() {});
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        children: [
                                          isSelected
                                              ? const Icon(
                                                  Icons.check_box_outlined)
                                              : const Icon(
                                                  Icons.check_box_outline_blank),
                                          const SizedBox(width: 16),
                                          Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                          //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                          value: Selectedavailability.isEmpty
                              ? null
                              : Selectedavailability.last,
                          onChanged: (value) {},
                          buttonHeight: 40,
                          buttonWidth: 150,
                          itemHeight: 40,
                          itemPadding: EdgeInsets.zero,
                          selectedItemBuilder: (context) {
                            return items.map(
                              (item) {
                                return Container(
                                  alignment: AlignmentDirectional.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: const Text(
                                    "AVAILABILITY",
                                    style: TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyan,
                                    ),
                                    maxLines: 1,
                                  ),
                                );
                              },
                            ).toList();
                          },
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: const Align(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              'H/D',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan,
                              ),
                            ),
                          ),
                          items: H_D.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              //disable default onTap to avoid closing menu when selecting an item
                              enabled: false,
                              child: StatefulBuilder(
                                builder: (context, menuSetState) {
                                  final isSelected = selectedH_D.contains(item);
                                  return InkWell(
                                    onTap: () {
                                      isSelected
                                          ? selectedH_D.remove(item)
                                          : selectedH_D.add(item);
                                      getmuti();
                                      //This rebuilds the StatefulWidget to update the button's text
                                      setState(() {});
                                      //This rebuilds the dropdownMenu Widget to update the check mark
                                      menuSetState(() {});
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        children: [
                                          isSelected
                                              ? const Icon(
                                                  Icons.check_box_outlined)
                                              : const Icon(
                                                  Icons.check_box_outline_blank),
                                          const SizedBox(width: 16),
                                          Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                          //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                          value: selectedH_D.isEmpty ? null : selectedH_D.last,
                          onChanged: (value) {},
                          buttonHeight: 40,
                          buttonWidth: 100,
                          itemHeight: 40,
                          itemPadding: EdgeInsets.zero,
                          selectedItemBuilder: (context) {
                            return items.map(
                              (item) {
                                return Container(
                                  alignment: AlignmentDirectional.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: const Text(
                                    "H/D",
                                    style: TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyan,
                                    ),
                                    maxLines: 1,
                                  ),
                                );
                              },
                            ).toList();
                          },
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
                    
                    var len=true,avail = true;
                    try {
                      var dif = DateTime
                          .now()
                          .difference(user[index]["last_donated"].toDate())
                          .inDays;
                      if(dif<120){
                        avail = false;
                      }
                    }
                    catch(e){
                      avail = true;
                    }
                    // print(dif);
                    try{
                      user[index]["number"];

                    }
                    catch(e){
                      len= false;
                    }
                   return  Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: avail
                        ? const Color.fromARGB(255, 173, 231, 175)
                        : const Color.fromARGB(255, 231, 130, 123),
                    border: const Border(
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
                                 user[index]["email"].split('@')[0],
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
                           ! len ? '-':user[index]["blood Group"],
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
                                 !len? '-':  user[index]["number"],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                !len ? '-' :user[index]["street1"],
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
            ):const Center(child: CircularProgressIndicator(),),

          ],
        )),
      ),
    );
  }
}
