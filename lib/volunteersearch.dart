// ignore_for_file: prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers, empty_catches

import 'profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class VoluSearch extends StatefulWidget {
  const VoluSearch({super.key});

  @override
  State<VoluSearch> createState() => _VoluSearchState();
}

class _VoluSearchState extends State<VoluSearch> {

  var multidept =  ["CSBS", "CSE", "IT", "AIDS", "EEE", "ECE", "MECH", "E&I",'-'] , multiyear = ["I", "II", "III",'IV','V','-'],
      multigender =["MALE", "FEMALE",'-'];
  var dept = ["CSBS", "CSE", "IT", "AIDS", "EEE", "ECE", "MECH", "E&I"],
      year = ['I','II','III','IV','V'],
      gender = ["male", "female"],
      year_ = ["gritex", "BDC", "camp"];
  var i;
  var details = [
    ["499", "Mithilesh", "SEC20CB33", "II/CSE"],
    ["2", "SUJAN", "SEC20CB33", "III/CSBS"],
    ["3", "NAVIN", "SEC20CB33", "IV/CSE"],
    ["4", "JAI", "SEC20CB33", "III/EEE"],
    ["5", "DUMMY", "SEC20CB33", "II/EI"],
    ["6", "NAME", "SEC20CB33", "III/MECH"],
    ["7", "DETAIL", "SEC20CB33", "III/CSBS"],
  ];
  var details_ = [];
  var load=true;
  var deptItem = [], yearItem = [], genderItem = [], eventItem = [], yearItem_ = [] ;

  Future<void> getdata() async {
    FirebaseFirestore ins = FirebaseFirestore.instance;
    QuerySnapshot data = await ins.collection("users").limit(100).get();
    details_ = data.docs;

setState(() {
  details_;
  load = false;

});
  }
  TextEditingController search = TextEditingController();
  getmulti()async{
    load = true;
    var deptfilter = [] , genderfilter = [] , yearfilter=[];
    if(deptItem.isEmpty){
      deptfilter = multidept;
    }
    else{
      deptfilter = deptItem;
    }
    if(yearItem.isEmpty){
      yearfilter = multiyear;
    }
    else{
      yearfilter = yearItem;
    }
    if(genderItem.isEmpty){
      genderfilter = multigender;
    }
    else{
      genderfilter = genderItem;
    }
    Query val =  FirebaseFirestore.instance.collection(
        "users").where(
        "dept", whereIn: deptfilter);
    // val = val.where("year",whereIn: multiyear);
    // val = val.where("gender",whereIn: multigender);
    await val.get().then((value) {
      details_ = value.docs.where((element){
        var gen = element['gender'];
        var ye = element['year'];
        return genderfilter.contains(gen) && yearfilter.contains(ye);
      }).toList();
    });



    setState(() {
      details_;
      load = false;
    });
  }
  var refresh = false;
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
        title: SizedBox(
          height: 50,
          width: double.infinity,
          child: TextField(
            controller: search,
            onChanged: (i)async{
              setState(() {
                load = true;
              });
              FirebaseFirestore ins = FirebaseFirestore.instance;
              QuerySnapshot data = await ins.collection("users").get();

              setState(() {
                details_= data.docs.where((i){
                  String id = i["email"].toLowerCase();
                  String name = i["name"].toLowerCase();
                  return id.startsWith(search.text.toLowerCase()) || name.startsWith(search.text.toLowerCase());
                }).toList();
                load = false;
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
                getdata();
              },
              icon: const Icon(
                Icons.refresh,
                size: 35,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          await Future.delayed(const Duration(milliseconds: 1500));
          getdata();
        },
        displacement: 20,
        backgroundColor: Colors.white,
        color: Colors.lightBlueAccent,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: Center(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 20),
              child: Text(
                "SORT BY",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 45),
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
                          hint: const Align(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              'DEPT',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan,
                              ),
                            ),
                          ),
                          items: dept.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              //disable default onTap to avoid closing menu when selecting an item
                              enabled: false,
                              child: StatefulBuilder(
                                builder: (context, menuSetState) {
                                  final _isSelected = deptItem.contains(item);
                                  return InkWell(
                                    onTap: () {
                                      _isSelected
                                          ? deptItem.remove(item)
                                          : deptItem.add(item);
                                      getmulti();
                                      //This rebuilds the StatefulWidget to update the button's text
                                      setState(() {});
                                      //This rebuilds the dropdownMenu Widget to update the check mark
                                      menuSetState(() {});
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        children: [
                                          _isSelected
                                              ? const Icon(
                                                  Icons.check_box_outlined,
                                                  size: 20,
                                                )
                                              : const Icon(
                                                  Icons.check_box_outline_blank,
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
                          value: deptItem.isEmpty ? null : deptItem.last,
                          onChanged: (value) {},
                          buttonHeight: 40,
                          buttonWidth: 70,
                          itemHeight: 40,
                          itemPadding: EdgeInsets.zero,
                          selectedItemBuilder: (context) {
                            return dept.map(
                              (item) {
                                return Container(
                                  alignment: AlignmentDirectional.center,
                                  child: const Text(
                                    "DEPT",
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
                                  final _isSelected = yearItem.contains(item);
                                  return InkWell(
                                    onTap: () {
                                      _isSelected
                                          ? yearItem.remove(item)
                                          : yearItem.add(item);
                                      getmulti();
                                      //This rebuilds the StatefulWidget to update the button's text
                                      setState(() {});
                                      //This rebuilds the dropdownMenu Widget to update the check mark
                                      menuSetState(() {});
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        children: [
                                          _isSelected
                                              ? const Icon(
                                                  Icons.check_box_outlined,
                                                  size: 20,
                                                )
                                              : const Icon(
                                                  Icons.check_box_outline_blank,
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
                                  final _isSelected = genderItem.contains(item);
                                  return InkWell(
                                    onTap: () {
                                      _isSelected
                                          ? genderItem.remove(item)
                                          : genderItem.add(item);
                                      getmulti();
                                      //This rebuilds the StatefulWidget to update the button's text
                                      setState(() {});
                                      //This rebuilds the dropdownMenu Widget to update the check mark
                                      menuSetState(() {});
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      padding: const EdgeInsets.only(left: 7),
                                      child: Row(
                                        children: [
                                          _isSelected
                                              ? const Icon(
                                                  Icons.check_box_outlined,
                                                  size: 20,
                                                )
                                              : const Icon(
                                                  Icons.check_box_outline_blank,
                                                  size: 20,
                                                ),
                                          const SizedBox(width: 5),
                                          Text(
                                            item,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
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
                          value: genderItem.isEmpty ? null : genderItem.last,
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

                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 192, 191, 191),
                border: Border(
                  top: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  bottom: BorderSide(
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
                    const SizedBox(
                      width: 90,
                      child: Text(
                        "NAME",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: SizedBox(
                        width: 90,
                        child: Column(
                          children: const [
                            Text(
                              "ID",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: SizedBox(
                        width: 80,
                        child: Column(
                          children: const [
                            Text(
                              "YEAR/DEPT",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            load ? const Padding(padding: EdgeInsets.only(top: 30),child: CircularProgressIndicator(color: Colors.lightBlueAccent,), ) :Expanded(
              child: SizedBox(
                width: double.infinity,
                child:ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: details_.length,
                  itemBuilder:(context,index){
                    return         GestureDetector(
                      onTap: (){
                        try {
                          details_[index]["number"];
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  Profile(email: details_[index]["email"])));
                        }
                        catch(e){

                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
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
                              SizedBox(
                                width: 90,
                                child: Text(
                                  details_[index]["name"],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: SizedBox(
                                  width: 90,
                                  child: Column(
                                    children: [
                                      Text(
                                       details_[index]["email"].substring(0,10).toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: SizedBox(
                                  width: 80,
                                  child: Column(
                                    children: [
                                     Text(
                                        details_[index]["year"] + '/' + details_[index]["dept"],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ),
            )
          ],
        )),
      ),
    );
  }
}
