import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AddNonBlood extends StatefulWidget {
  const AddNonBlood({Key? key}) : super(key: key);

  @override
  State<AddNonBlood> createState() => _AddNonBloodState();
}

class _AddNonBloodState extends State<AddNonBlood> {
  TextEditingController emailID = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController date = TextEditingController();
  //text editing controller for text field
  // ignore: prefer_typing_uninitialized_variables
  var pick;
  var items = ["Select Group","A+", "A-", "B+"," B-", "O+"," O-", "AB+"," AB-"];
  String dropdownvalue = 'Select Group';

  @override
  void initState() {
    date.text = ""; //set the initial value of text field
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xffe5e5e5),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "ADD BLOOD DONATION",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading:IconButton(icon: const Icon(Icons.arrow_back),iconSize: 25,color:Colors.black,onPressed: (){Navigator.pop(context);},),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 50, left: 50),
                child: TextField(
                  controller: name,
                  decoration:const InputDecoration(hintText: "Name",focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 50, left: 50),
                child: TextField(
                  controller: number,
                  keyboardType: TextInputType.number,
                  decoration:const InputDecoration(hintText: "Number",focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),


                  ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ), Padding(
                padding: const EdgeInsets.only(right: 50, left: 50),
                child: TextField(
                  controller: street,
                  decoration:const InputDecoration(hintText: "Area",focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),),
                ),
              ),
              const  SizedBox(
                height: 25,
              ),

              Padding(
                padding: const EdgeInsets.only(right: 50, left: 50),
                child: TextField(
                  controller: emailID,
                  decoration:const InputDecoration(hintText: "Student ID",focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),),
                ),
              ),
              const SizedBox(
                height: 25,
              ),

              Padding(
                padding: const EdgeInsets.only(right: 50, left: 50),

                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    hint: Text(
                      'Select Item',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ))
                        .toList(),
                    value: dropdownvalue,
                    onChanged: (value) {
                      setState(() {
                        dropdownvalue = value as String;
                      });
                    },
                    buttonDecoration:const BoxDecoration(

                      border: Border(
                        bottom: BorderSide(
                            width: 1.0,
                            color: Color.fromARGB(255, 17, 16, 16)),
                      ),

                    ),
                    itemHeight: 40,

                    itemPadding: const EdgeInsets.only(left: 14, right: 14),
                    dropdownMaxHeight: 160,
                    dropdownWidth: 160,
                    dropdownPadding: null,
                    dropdownElevation: 8,
                    scrollbarRadius: const Radius.circular(40),
                    scrollbarThickness: 6,
                    scrollbarAlwaysShow: true,
                    buttonWidth: double.infinity,
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 50, left: 50),
                child: TextField(

                  controller: date, //editing controller of this TextField
                  decoration:const InputDecoration(
                    hintText: "DATE",
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    icon: Icon(Icons.calendar_today,color: Colors.black,), //icon of text field
                    // labelText: "Enter Date", //label text of field,
                    // labelStyle:  TextStyle(color: Colors.black),



                  ),
                  readOnly: true,  //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context, initialDate: DateTime.now(),
                        firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101),

                        builder: ( context, child)
                        {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme:const ColorScheme.dark(
                                  primary: Colors.red,
                                  onPrimary: Colors.white,
                                  surface: Colors.red,
                                  onSurface: Colors.white
                              ),
                            ),
                            child: child!,
                          );
                        }
                    );

                    if(pickedDate != null ){
                        //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                       //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement
                      pick = pickedDate;
                      setState(() {
                        date.text = formattedDate; //set output date to TextField value.
                      });
                    }else{

                    }
                  },
                ),
              ),
              const SizedBox(
                  height: 25),
              Padding(
                padding: const EdgeInsets.only(right: 50, left: 50),
                child: SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ()async {

                        await FirebaseFirestore.instance.collection("blood").doc(
                            "non_volunteer").set({
                        'history': FieldValue.arrayUnion([{
                          "stud_id": emailID.text,
                          "blood": dropdownvalue,
                          "date":pick,
                          "name":name.text,
                          "number":number.text,
                          "street":street.text,
                        }])
                        }, SetOptions(merge: true));


                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                    child:const Text("ADD"),
                  ),
                ),
              )



            ]



        ),
      ),
    );
  }
}
