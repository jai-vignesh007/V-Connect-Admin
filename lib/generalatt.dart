import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class GeneralAtt extends StatefulWidget {
  const GeneralAtt({super.key});

  @override
  State<GeneralAtt> createState() => _GeneralAttState();
}

class _GeneralAttState extends State<GeneralAtt> {
  String dropdownvalue = "DATE";
  int i = 0;

  String id = "STUDENT ID";
  String attval = "MARK AS PRESENT", attval1 = "MARK AS PRESENT";

  var attmark = 0;
  // ignore: non_constant_identifier_names
  var text_area = false;
  var defaults = 0xffB8B1B1, green = 0xff82CC76, red = 0xffEB787D;
  bool action = false;
  ConnectivityResult result = ConnectivityResult.none;
  List<String> alldata = [];
  List<String> date = [];
  String docid = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";

  DocumentSnapshot? documentSnapshot;
  Future<void> val() async {
    // try {
    await FirebaseFirestore.instance
        .collection('attendance')
        .doc(docid)
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          documentSnapshot = value;
        });
      } else {
        await FirebaseFirestore.instance
            .collection('attendance')
            .doc(docid)
            .set({});
      }
    });

  }



  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    alldata = querySnapshot.docs
        .map((doc) => doc["email"].toString().trim().split("@")[0])
        .toList();

  }


  @override
  void initState() {

    getData();
    super.initState();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      id = barcodeScanRes.substring(3, barcodeScanRes.length);
    });
    if (alldata.contains(id.toLowerCase())) {
      defaults = green;
      action = true;
    } else {
      defaults = red;
      action = false;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  text_area=!text_area;
                });
              },
              icon:const Icon(
                Icons.edit,
                color: Colors.black,
                size: 28.0,
              ),
            ),
          ],
          leading:IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
          ),
          centerTitle: true,
          title: const Text(
            "GENERAL ATTANDANCE",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

               const Text(
                  "DATE:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  ("${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 65, left: 100, right: 100),
              child: SizedBox(
                height: 45,
                width: double.infinity,
                child:text_area?TextField(
                  // enabled: enable_val,
                  onChanged: (i)async{
                    setState(() {
                      if(i == ""){
                        id = "STUDENT ID";
                      }
                      else {
                        id = i;
                      }
                    });
                    if (alldata.contains(id.toLowerCase())) {
                      defaults = green;
                      action = true;
                    } else {
                      defaults = red;
                      action = false;
                    }
                  },
                ): ElevatedButton(
                  onPressed: () async {
                    val();
                    result = await Connectivity().checkConnectivity();
                    if (result != ConnectivityResult.wifi &&
                        result != ConnectivityResult.mobile) {
                      Utils.showSnackBar("No internet");
                    }
                    scanBarcodeNormal();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 10,
                      shadowColor: Colors.black
                      ),
                  child: const Text(
                    "scan",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 85),
              child: Text(
                id.toUpperCase(),
                style:const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 19),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 90, right: 90),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (() async {
                    result = await Connectivity().checkConnectivity();
                    if (result != ConnectivityResult.wifi &&
                        result != ConnectivityResult.mobile) {
                      Utils.showSnackBar("No internet");
                    }
                    if (action) {
                      // print(documentSnapshot![id.toLowerCase()]);
                      try {
                        if (documentSnapshot?[id.toLowerCase()]) {
                          Utils.showSnackBar("already marked");
                        }
                      } catch (e) {

                        FirebaseFirestore.instance
                            .collection("attendance")
                            .doc(("${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}"))
                            .update({id.toLowerCase(): true});
                        FirebaseFirestore.instance.collection("users").where("email",isGreaterThanOrEqualTo: id.toLowerCase()).where("email",isLessThan: '${id.toLowerCase()}z').get().then((value) {
                         FirebaseFirestore.instance.collection("users").doc(value.docs.first.id).update({
                           "attendance":FieldValue.arrayUnion([DateTime.now()])
                         });
                        });
                        Utils_g.showSnackBar("done");
                      }
                    }
                  }),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(defaults),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0)),
                      elevation: 10,
                      shadowColor: Colors.black

                      // foreground (text) color
                      ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check,
                        size: 28.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          attval,
                          textAlign: TextAlign.center,
                          style:const TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
           const SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
