// ignore_for_file: camel_case_types, must_be_immutable, prefer_typing_uninitialized_variables, non_constant_identifier_names, empty_catches
import 'package:draggable_fab/draggable_fab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:nssadmin/search.dart';
import 'profile.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class volunteerslist extends StatefulWidget {
  var id;
  bool after;
  volunteerslist({super.key, required this.id, required this.after});

  @override
  State<volunteerslist> createState() => _volunteerslistState();
}

class _volunteerslistState extends State<volunteerslist> {
  var accept = [],
      request = [],
      decline = [],
      a = [],
      r = [],
      d = [],
      view = true;
  var multidept = [
        "CSBS",
        "CSE",
        "IT",
        "AIDS",
        "EEE",
        "ECE",
        "MECH",
        "E&I",
        '-'
      ],
      multiyear = ["I", "II", "III", 'IV', 'V', '-'],
      multigender = ["MALE", "FEMALE", '-'];
  List<String> deptItem = [],
      yearItem = [],
      genderItem = [],
      eventItem = [],
      yearItem_ = [],
      selectedH_D = [];
  var year = ["I", "II", "III", 'IV', 'V'],
      gender = ["MALE", "FEMALE"],
      H_D = ['Hostler', 'Day Scholar'];
  var first = {},
      second = {},
      third = {},
      four = {},
      five = {},
      i,
      select = false;
  var accept_select = {};
  set_val() async {
    first = {};
    second = {};
    third = {};
    four = {};
    five = {};
    for (var i in accept) {
      await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: i["email"])
          .get()
          .then((value) {
        var val = value.docs.first;
        if (val["year"] == 'I') {
          try {
            first[val["dept"]].add({"name": val["name"], "id": val["stud_id"]});
          } catch (e) {
            first[val["dept"]] = [
              {"name": val["name"], "id": val["stud_id"]}
            ];
          }
        } else if (val["year"] == 'II') {
          try {
            second[val["dept"]]
                .add({"name": val["name"], "id": val["stud_id"]});
          } catch (e) {
            second[val["dept"]] = [
              {
                "name": val["name"],
                "id": val["stud_id"],
              }
            ];
          }
        } else if (val["year"] == 'III') {
          try {
            third[val["dept"]].add({"name": val["name"], "id": val["stud_id"]});
          } catch (e) {
            third[val["dept"]] = [
              {
                "name": val["name"],
                "id": val["stud_id"],
              }
            ];
          }
        } else if (val["year"] == 'IV') {
          try {
            four[val["dept"]].add({"name": val["name"], "id": val["stud_id"]});
          } catch (e) {
            four[val["dept"]] = [
              {
                "name": val["name"],
                "id": val["stud_id"],
              }
            ];
          }
        } else if (val["year"] == 'V') {
          try {
            five[val["dept"]].add({"name": val["name"], "id": val["stud_id"]});
          } catch (e) {
            five[val["dept"]] = [
              {
                "name": val["name"],
                "id": val["stud_id"],
              }
            ];
          }
        }
      });
    }
  }

  getData() async {
    setState(() {
      view = false;
    });
    await FirebaseFirestore.instance
        .collection("events")
        .doc(widget.id)
        .get()
        .then((value) {
      setState(() {
        accept = value["accept"];
        decline = value["decline"];
        var k = {};
        for (var i in value["request"]) {
          k[i["email"]] = i["name"];
        }
        request = [];
        for (var i in k.keys) {
          request.add({"email": i, "name": k[i]});
        }
        a = accept;
        r = request;
        d = decline;
      });
    });

    setState(() {
      view = true;
    });
  }

  getmulti(String name) async {
    setState(() {
      view = false;
    });
    var list;
    // await FirebaseFirestore.instance.collection("events").doc(widget.id).get().then((value) {
    //   if(name == 'a') {
    //     list = value["accept"];
    //   } else if(name == 'd') {
    //     list = value["request"];
    //   }
    //   else {
    //     list = value["decline"];
    //   }
    // });
    if (name == 'a') {
      list = a;
    } else if (name == 'd') {
      list = d;
    } else {
      list = r;
    }
    var newlist = [],
        multiyear = ["I", "II", "III", 'IV', 'V'],
        multigender = ["MALE", "FEMALE"],
        newhd = ['Hostler', 'Day Scholar'];
    if (yearItem.isNotEmpty) {
      multiyear = yearItem;
    }
    if (genderItem.isNotEmpty) {
      multigender = genderItem;
    }
    if (selectedH_D.isNotEmpty) {
      newhd = selectedH_D;
    }

    for (var e in list) {
      await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: e["email"])
          .get()
          .then((value) {
        var a = value.docs.first.data();
        if (multigender.contains(a["gender"]) &&
            multiyear.contains(a["year"]) &&
            newhd.contains(a["mode"])) {
          newlist.add(e);
        }
      });
    }
    if (name == "a") {
      setState(() {
        accept = newlist;
      });
    } else if (name == 'd') {
      setState(() {
        decline = newlist;
      });
    } else {
      setState(() {
        request = newlist;
      });
    }
    setState(() {
      view = true;
    });
  }

  // List b = widget.data!['accept'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  sendNotification(String email, String title, String body) async {
    var token;
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((value) {
      token = value.docs.first.data()["token"];
    });

    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': "ff",
    };
    try {
      http.Response response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': KEY
          },
          body: jsonEncode(<String, dynamic>{
            'notification': <String, dynamic>{
              'title': title.capitalize(),
              'body': body,
              "sound": "default"
            },
            'priority': 'high',
            'data': data,
            'to': '$token'
          }));

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {}

    await FirebaseFirestore.instance.collection("notification").doc(email).set({
      "notifications": FieldValue.arrayUnion([
        {"title": title, "body": body, "time": DateTime.now()}
      ])
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: DraggableFab(
            child: FloatingActionButton(
                onPressed: () async {
                  await set_val();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return PdfPreviewPage(
                        "text", first, second, third, four, five);
                  }));
                },
                child: Text("PDF"),
                backgroundColor: Colors.black)),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          actions: [
            IconButton(
              onPressed: () async {
                // yearItem = []; genderItem = []; eventItem = [];yearItem_ = []; selectedH_D = [];
                //   getData();

                setState(() {
                  select = !select;
                });
              },
              icon: Icon(
                  select
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_sharp,
                  size: 32),
              color: Colors.black,
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          title: const Text(
            'VOLUNTEERS LIST',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xffADD1C2),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8)),
                    ),
                    child: const Text(
                      "ACCEPTED",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
              Tab(
                child: Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xffEBB7B9),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8)),
                    ),
                    child: const Text(
                      "DECLINE",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
              Tab(
                child: Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xffA2C6D0),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8)),
                    ),
                    child: const Text(
                      "NEW",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 20, right: 20, bottom: 5),
                    child: TextFormField(
                      onChanged: (i) async {
                        await getData();
                        accept = accept.where((element) {
                          return element["name"].toLowerCase().startsWith(i) ||
                              element["email"].toLowerCase().startsWith(i);
                        }).toList();
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          labelText: "Search name or ID",
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Material(
                    elevation: 5,
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: const Align(
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  'YEAR',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ),
                              items: year.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  //disable default onTap to avoid closing menu when selecting an item
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final isSelected =
                                          yearItem.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          isSelected
                                              ? yearItem.remove(item)
                                              : yearItem.add(item);
                                          getmulti("a");

                                          //This rebuilds the StatefulWidget to update the button's text
                                          setState(() {});
                                          //This rebuilds the dropdownMenu Widget to update the check mark
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Row(
                                            children: [
                                              isSelected
                                                  ? const Icon(
                                                      Icons.check_box_outlined,
                                                      size: 20,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .check_box_outline_blank,
                                                      size: 20,
                                                    ),
                                              const SizedBox(width: 5),
                                              Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
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
                              value: yearItem.isEmpty ? null : yearItem.last,
                              onChanged: (value) {},
                              buttonHeight: 40,
                              buttonWidth: 70,
                              itemHeight: 40,
                              itemPadding: EdgeInsets.zero,
                              selectedItemBuilder: (context) {
                                return year.map(
                                  (item) {
                                    return Container(
                                      alignment: AlignmentDirectional.center,
                                      child: const Text(
                                        "YEAR",
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
                                  'GENDER',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ),
                              items: gender.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  //disable default onTap to avoid closing menu when selecting an item
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final isSelected =
                                          genderItem.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          isSelected
                                              ? genderItem.remove(item)
                                              : genderItem.add(item);
                                          getmulti("a");

                                          //This rebuilds the StatefulWidget to update the button's text
                                          setState(() {});
                                          //This rebuilds the dropdownMenu Widget to update the check mark
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding:
                                              const EdgeInsets.only(left: 7),
                                          child: Row(
                                            children: [
                                              isSelected
                                                  ? const Icon(
                                                      Icons.check_box_outlined,
                                                      size: 20,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .check_box_outline_blank,
                                                      size: 20,
                                                    ),
                                              const SizedBox(width: 5),
                                              Text(
                                                item,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                  genderItem.isEmpty ? null : genderItem.last,
                              onChanged: (value) {},
                              buttonHeight: 40,
                              buttonWidth: 90,
                              itemHeight: 40,
                              itemPadding: EdgeInsets.zero,
                              selectedItemBuilder: (context) {
                                return genderItem.map(
                                  (item) {
                                    return Container(
                                      alignment: AlignmentDirectional.center,
                                      child: const Text(
                                        "GENDER",
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
                                      final isSelected =
                                          selectedH_D.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          isSelected
                                              ? selectedH_D.remove(item)
                                              : selectedH_D.add(item);
                                          getmulti('a');
                                          //This rebuilds the StatefulWidget to update the button's text
                                          setState(() {});
                                          //This rebuilds the dropdownMenu Widget to update the check mark
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Row(
                                            children: [
                                              isSelected
                                                  ? const Icon(
                                                      Icons.check_box_outlined)
                                                  : const Icon(Icons
                                                      .check_box_outline_blank),
                                              const SizedBox(width: 3),
                                              Text(
                                                item[0],
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
                                  selectedH_D.isEmpty ? null : selectedH_D.last,
                              onChanged: (value) {},
                              buttonHeight: 40,
                              buttonWidth: 65,
                              itemHeight: 40,
                              itemPadding: EdgeInsets.zero,
                              selectedItemBuilder: (context) {
                                return H_D.map(
                                  (item) {
                                    return Container(
                                      alignment: AlignmentDirectional.center,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "COUNT: ${accept.length}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )),
                        const Spacer(),
                        !widget.after
                            ? const Text(
                                "REMOVE",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : const Text(""),
                      ],
                    ),
                  ),
                  view
                      ? Expanded(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: accept.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    color: select
                                        ? accept_select[accept[index]
                                                    ["email"]] !=
                                                null
                                            ? Colors.black
                                            : Colors.white
                                        : Colors.white,
                                    child: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, right: 6),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              right: 20, left: 20),
                                          child: !widget.after
                                              ? Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => Profile(
                                                                    email: accept[
                                                                            index]
                                                                        [
                                                                        "email"])));
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            accept[index]
                                                                ["name"],
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(accept[index]
                                                              ["email"])
                                                        ],
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    IconButton(
                                                        onPressed: () async {
                                                          HapticFeedback
                                                              .heavyImpact();
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "events")
                                                              .doc(widget.id)
                                                              .update({
                                                            "decline": FieldValue
                                                                .arrayUnion([
                                                              accept[index]
                                                            ]),
                                                            "accept": FieldValue
                                                                .arrayRemove([
                                                              accept[index]
                                                            ])
                                                          });
                                                          sendNotification(
                                                              accept[index]
                                                                  ["email"],
                                                              "DECLINE",
                                                              "you're declined for ${widget.id} event");
                                                          await getData();
                                                        },
                                                        icon: const Icon(
                                                          Icons.cancel,
                                                          size: 30,
                                                          color: Colors.red,
                                                        ))
                                                  ],
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Profile(
                                                                    email: accept[
                                                                            index]
                                                                        [
                                                                        "email"])));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        accept[index]["name"],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(accept[index]
                                                          ["email"])
                                                    ],
                                                  ),
                                                ),
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                        thickness: 0,
                                      ),
                                    ]),
                                  );
                                }),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * .2),
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          )),
                ],
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height*0.83,
              color: Colors.white,
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 20, right: 20, bottom: 5),
                    child: TextFormField(
                      onChanged: (i) async {
                        await getData();
                        decline = decline.where((element) {
                          return element["name"].toLowerCase().startsWith(i) ||
                              element["email"].toLowerCase().startsWith(i);
                        }).toList();
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          labelText: "Search name or ID",
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Material(
                    elevation: 5,
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: const Align(
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  'YEAR',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ),
                              items: year.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  //disable default onTap to avoid closing menu when selecting an item
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final isSelected =
                                          yearItem.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          isSelected
                                              ? yearItem.remove(item)
                                              : yearItem.add(item);
                                          getmulti("d");
                                          //This rebuilds the StatefulWidget to update the button's text
                                          setState(() {});
                                          //This rebuilds the dropdownMenu Widget to update the check mark
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Row(
                                            children: [
                                              isSelected
                                                  ? const Icon(
                                                      Icons.check_box_outlined,
                                                      size: 20,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .check_box_outline_blank,
                                                      size: 20,
                                                    ),
                                              const SizedBox(width: 5),
                                              Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
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
                              value: yearItem.isEmpty ? null : yearItem.last,
                              onChanged: (value) {},
                              buttonHeight: 40,
                              buttonWidth: 70,
                              itemHeight: 40,
                              itemPadding: EdgeInsets.zero,
                              selectedItemBuilder: (context) {
                                return year.map(
                                  (item) {
                                    return Container(
                                      alignment: AlignmentDirectional.center,
                                      child: const Text(
                                        "YEAR",
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
                                  'GENDER',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ),
                              items: gender.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  //disable default onTap to avoid closing menu when selecting an item
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final isSelected =
                                          genderItem.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          isSelected
                                              ? genderItem.remove(item)
                                              : genderItem.add(item);
                                          getmulti("d");

                                          //This rebuilds the StatefulWidget to update the button's text
                                          setState(() {});
                                          //This rebuilds the dropdownMenu Widget to update the check mark
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding:
                                              const EdgeInsets.only(left: 7),
                                          child: Row(
                                            children: [
                                              isSelected
                                                  ? const Icon(
                                                      Icons.check_box_outlined,
                                                      size: 20,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .check_box_outline_blank,
                                                      size: 20,
                                                    ),
                                              const SizedBox(width: 5),
                                              Text(
                                                item,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                  genderItem.isEmpty ? null : genderItem.last,
                              onChanged: (value) {},
                              buttonHeight: 40,
                              buttonWidth: 90,
                              itemHeight: 40,
                              itemPadding: EdgeInsets.zero,
                              selectedItemBuilder: (context) {
                                return genderItem.map(
                                  (item) {
                                    return Container(
                                      alignment: AlignmentDirectional.center,
                                      child: const Text(
                                        "GENDER",
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
                                      final isSelected =
                                          selectedH_D.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          isSelected
                                              ? selectedH_D.remove(item)
                                              : selectedH_D.add(item);
                                          getmulti("d");
                                          //This rebuilds the StatefulWidget to update the button's text
                                          setState(() {});
                                          //This rebuilds the dropdownMenu Widget to update the check mark
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Row(
                                            children: [
                                              isSelected
                                                  ? const Icon(
                                                      Icons.check_box_outlined)
                                                  : const Icon(Icons
                                                      .check_box_outline_blank),
                                              const SizedBox(width: 3),
                                              Text(
                                                item[0],
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
                                  selectedH_D.isEmpty ? null : selectedH_D.last,
                              onChanged: (value) {},
                              buttonHeight: 40,
                              buttonWidth: 60,
                              itemHeight: 40,
                              itemPadding: EdgeInsets.zero,
                              selectedItemBuilder: (context) {
                                return H_D.map(
                                  (item) {
                                    return Container(
                                      alignment: AlignmentDirectional.center,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "COUNT: ${decline.length}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )),
                        const Spacer(),
                        !widget.after
                            ? const Text(
                                "RESELECT",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : const Text("")
                      ],
                    ),
                  ),
                  view
                      ? Expanded(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: decline.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, right: 14),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              right: 20, left: 20),
                                          child: !widget.after
                                              ? Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => Profile(
                                                                    email: decline[
                                                                            index]
                                                                        [
                                                                        "email"])));
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            decline[index]
                                                                ["name"],
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(decline[index]
                                                              ["email"])
                                                        ],
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    IconButton(
                                                      onPressed: () async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "events")
                                                            .doc(widget.id)
                                                            .update({
                                                          "accept": FieldValue
                                                              .arrayUnion([
                                                            decline[index]
                                                          ]),
                                                          "decline": FieldValue
                                                              .arrayRemove([
                                                            decline[index]
                                                          ])
                                                        });
                                                        sendNotification(
                                                            decline[index]
                                                                ["email"],
                                                            "REACCEPT",
                                                            "you're accepted for ${widget.id} event");
                                                        await getData();
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .check_circle_rounded,
                                                        size: 32,
                                                        color: Colors.green,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => Profile(
                                                                email: decline[
                                                                        index][
                                                                    "email"])));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        decline[index]["name"],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(decline[index]
                                                          ["email"])
                                                    ],
                                                  ),
                                                ),
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                        thickness: 0,
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * .2),
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          )),
                ],
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height*0.83,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 20, right: 20, bottom: 5),
                    child: TextFormField(
                      onChanged: (i) async {
                        await getData();
                        request = request.where((element) {
                          return element["name"].toLowerCase().startsWith(i) ||
                              element["email"].toLowerCase().startsWith(i);
                        }).toList();
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          labelText: "Search name or ID",
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Material(
                    elevation: 5,
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: const Align(
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  'YEAR',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ),
                              items: year.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  //disable default onTap to avoid closing menu when selecting an item
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final isSelected =
                                          yearItem.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          isSelected
                                              ? yearItem.remove(item)
                                              : yearItem.add(item);
                                          getmulti("r");
                                          //This rebuilds the StatefulWidget to update the button's text
                                          setState(() {});
                                          //This rebuilds the dropdownMenu Widget to update the check mark
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Row(
                                            children: [
                                              isSelected
                                                  ? const Icon(
                                                      Icons.check_box_outlined,
                                                      size: 20,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .check_box_outline_blank,
                                                      size: 20,
                                                    ),
                                              const SizedBox(width: 5),
                                              Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
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
                              value: yearItem.isEmpty ? null : yearItem.last,
                              onChanged: (value) {},
                              buttonHeight: 40,
                              buttonWidth: 70,
                              itemHeight: 40,
                              itemPadding: EdgeInsets.zero,
                              selectedItemBuilder: (context) {
                                return year.map(
                                  (item) {
                                    return Container(
                                      alignment: AlignmentDirectional.center,
                                      child: const Text(
                                        "YEAR",
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
                                  'GENDER',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ),
                              items: gender.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  //disable default onTap to avoid closing menu when selecting an item
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final isSelected =
                                          genderItem.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          isSelected
                                              ? genderItem.remove(item)
                                              : genderItem.add(item);
                                          getmulti("r");
                                          //This rebuilds the StatefulWidget to update the button's text
                                          setState(() {});
                                          //This rebuilds the dropdownMenu Widget to update the check mark
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding:
                                              const EdgeInsets.only(left: 7),
                                          child: Row(
                                            children: [
                                              isSelected
                                                  ? const Icon(
                                                      Icons.check_box_outlined,
                                                      size: 20,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .check_box_outline_blank,
                                                      size: 20,
                                                    ),
                                              const SizedBox(width: 5),
                                              Text(
                                                item,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                  genderItem.isEmpty ? null : genderItem.last,
                              onChanged: (value) {},
                              buttonHeight: 40,
                              buttonWidth: 90,
                              itemHeight: 40,
                              itemPadding: EdgeInsets.zero,
                              selectedItemBuilder: (context) {
                                return genderItem.map(
                                  (item) {
                                    return Container(
                                      alignment: AlignmentDirectional.center,
                                      child: const Text(
                                        "GENDER",
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
                                      final isSelected =
                                          selectedH_D.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          isSelected
                                              ? selectedH_D.remove(item)
                                              : selectedH_D.add(item);
                                          getmulti('new');
                                          //This rebuilds the StatefulWidget to update the button's text
                                          setState(() {});
                                          //This rebuilds the dropdownMenu Widget to update the check mark
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Row(
                                            children: [
                                              isSelected
                                                  ? const Icon(
                                                      Icons.check_box_outlined)
                                                  : const Icon(Icons
                                                      .check_box_outline_blank),
                                              const SizedBox(width: 3),
                                              Text(
                                                item[0],
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
                                  selectedH_D.isEmpty ? null : selectedH_D.last,
                              onChanged: (value) {},
                              buttonHeight: 40,
                              buttonWidth: 60,
                              itemHeight: 40,
                              itemPadding: EdgeInsets.zero,
                              selectedItemBuilder: (context) {
                                return H_D.map(
                                  (item) {
                                    return Container(
                                      alignment: AlignmentDirectional.center,
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
                  const SizedBox(
                    height: 20,
                  ),
                  !widget.after
                      ? Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "COUNT: ${request.length}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )),
                              const Spacer(),
                              const Text(
                                "SELECT   ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "REMOVE  ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )
                      : const Text(""),
                  !widget.after
                      ? view
                          ? Expanded(
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: request.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  right: 18, left: 20),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => Profile(
                                                                  email: request[
                                                                          index]
                                                                      [
                                                                      "email"])));
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          request[index]
                                                              ["name"],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(request[index]
                                                            ["email"])
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  IconButton(
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("events")
                                                          .doc(widget.id)
                                                          .update({
                                                        "accept": FieldValue
                                                            .arrayUnion([
                                                          request[index]
                                                        ]),
                                                        "request": FieldValue
                                                            .arrayRemove([
                                                          request[index]
                                                        ])
                                                      });

                                                      sendNotification(
                                                          request[index]
                                                              ["email"],
                                                          "ACCEPT",
                                                          "you're request accepted for ${widget.id} event");
                                                      await getData();
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .check_circle_rounded,
                                                      size: 32,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("events")
                                                          .doc(widget.id)
                                                          .update({
                                                        "decline": FieldValue
                                                            .arrayUnion([
                                                          request[index]
                                                        ]),
                                                        "request": FieldValue
                                                            .arrayRemove([
                                                          request[index]
                                                        ])
                                                      });
                                                      sendNotification(
                                                          request[index]
                                                              ["email"],
                                                          "DECLINE",
                                                          "you're request has been declined for ${widget.id} event");
                                                      await getData();
                                                    },
                                                    icon: const Icon(
                                                      Icons.cancel,
                                                      size: 32,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.black,
                                            thickness: 0,
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * .2),
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ))
                      : const Text(""),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfPreviewPage extends StatelessWidget {
  String? text;
  dynamic first, second, third, four, five;
  PdfPreviewPage(
      this.text, this.first, this.second, this.third, this.four, this.five,
      {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(),
      ),
    );
  }

  Add_page(pdf, list, year) {
    pdf.addPage(
      pw.MultiPage(
          margin: const pw.EdgeInsets.all(10),
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return [
              pw.Table(// This is the starting widget for the table
                  children: [
                pw.TableRow(children: [
                  pw.Container(
                      alignment: pw.Alignment.center,
                      padding: pw.EdgeInsets.all(20),
                      child: pw.Text("Volunteers $year Year".toUpperCase(),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 15)))
                ]),
                for (var i in list.keys)
                  pw.TableRow(
                    // This is the starting row for the table, within which the subsequent columns will be nested
                    children: [
                      pw.Column(children: [
                        pw.Container(
                          padding: pw.EdgeInsets.only(left: 10, bottom: 10),
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text("$i",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 13)),
                        ),
                        pw.ListView.builder(
                            itemCount: list[i].length,
                            itemBuilder: (context, index) {
                              return pw.Container(
                                  width: double.infinity,
                                  padding:
                                      pw.EdgeInsets.only(left: 30, bottom: 5),
                                  child: pw.Row(children: [
                                    pw.Container(
                                      width: 30,
                                      child: pw.Text("${index + 1}.   "),
                                    ),
                                    pw.Container(
                                      alignment: pw.Alignment.centerLeft,
                                      width: 300,
                                      child: pw.Text(
                                        '${list[i][index]["name"].toString().toUpperCase()}',
                                      ),
                                    ),
                                    pw.Container(
                                      alignment: pw.Alignment.centerRight,
                                      child: pw.Text(
                                          '${list[i][index]["id"].toString().toUpperCase()}'),
                                    )
                                  ]));
                            }),
                        pw.Container(height: 15)
                      ])
                    ],
                  ),
              ])
            ];

            //   pw.Column(
            //     crossAxisAlignment: pw.CrossAxisAlignment.start,
            //     children: [
            //       pw.Row(
            //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            //           children: [
            //             pw.Header(text: "About Cat", level: 1),
            //           ]
            //       ),
            //       pw.Divider(borderStyle: pw.BorderStyle.dashed),
            //       pw.Paragraph(text: text),
            //     ]
            // );
          }),
    );
  }

  Future<Uint8List> makePdf() async {
    final pdf = pw.Document();

    if (first.length != 0) Add_page(pdf, first, "first");
    if (second.length != 0) Add_page(pdf, second, "second");
    if (third.length != 0) Add_page(pdf, third, "Third");
    if (four.length != 0) Add_page(pdf, four, "Fourth");
    if (five.length != 0) Add_page(pdf, five, "Fifth");

    return pdf.save();
  }
}
