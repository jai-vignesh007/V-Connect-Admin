
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class OD_List extends StatefulWidget {
  List<dynamic> l;
  OD_List({super.key,required this.l});

  @override
  State<OD_List> createState() => _OD_ListState();
}

class _OD_ListState extends State<OD_List> {

  var first ={},other = {},k = true;
  set_val()async{
    for(var i in widget.l){
      await  FirebaseFirestore.instance.collection("users").where("email",isEqualTo: i["email"]).get().then((value){
        var val = value.docs.first;
        if(val["year"] == 'I'){
          try {
            first[val["dept"]].add(
              {
                "name":val["name"],
                "id":val["stud_id"]
              }
            );
          }
          catch(e){
            first[val["dept"]] = [
              {
                "name":val["name"],
                "id":val["stud_id"]
              }
            ];
          }
        }
        else{
          try {
            other[val["dept"]].add(
                {
                  "name":val["name"],
                  "id":val["stud_id"]
                }
            );
          }
          catch(e){
            other[val["dept"]] = [
              {
                "name":val["name"],
                "id":val["stud_id"],
              }
            ];
          }
        }

      });
    }
    setState(() {
      k = false;

    });
  }

  @override
  void initState() {

    // TODO: implement initState
    set_val();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,

      actions: [
        IconButton(onPressed: (){
          // _createPDF();
        }, icon: Icon(Icons.create),color: Colors.black,)
      ] ,),
      body: k?Center(child: CircularProgressIndicator(color: Colors.black,)): Column(
        children: [
          Container(alignment:Alignment.center,padding: EdgeInsets.all(20),child: Text("OD LIST",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
          Expanded(child:
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SelectableText("First Year",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,)),
                  for(var i in first.keys)
                    Column(
                      children: [
                        Container(
                            alignment:Alignment.centerLeft,
                            padding: EdgeInsets.all(10),
                            child: SelectableText("DEPT: ${i}",style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,),)),

                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.6,
                                    child: SelectableText("Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
                                Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.3,
                                    child: SelectableText("ID",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
                              ],
                            )
                        ),
                        for(var j in first[i])
                          Container(
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Container(
                                       alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width*0.6,
                                      child: Text("${j["name"]}")),
                                  Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width*0.3,
                                      child: Text("${j["id"]}")),
                                ],
                              )
                          )
                      ],
                    ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Text("Other Years",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,)),
                  for(var i in other.keys)
                    Column(
                      children: [
                        Container(
                            alignment:Alignment.centerLeft,
                            padding: EdgeInsets.all(10),
                            child: Text("DEPT: ${i}",style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,),)),

                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.6,
                                    child: Text("Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
                                Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width*0.3,
                                    child: Text("ID",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
                              ],
                            )
                        ),
                        for(var j in other[i])
                          Container(
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width*0.6,
                                      child: Text("${j["name"]}")),
                                  Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width*0.3,
                                      child: Text("${j["id"]}")),
                                ],
                              )
                          )
                      ],
                    ),


                ],
              ),
            ) ,
          )),

        ],

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return  PdfPreviewPage("text",first,other);
          }));
        },
        child: const Icon(Icons.picture_as_pdf_sharp),
      ),
    );
  }
}

class PdfPreviewPage extends StatelessWidget {
  String? text;
  dynamic first,other;
  PdfPreviewPage(this.text , this.first, this.other, {Key? key}) : super(key: key);
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

  Future<Uint8List> makePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
          margin: const pw.EdgeInsets.all(10),
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return     [pw.Table(// This is the starting widget for the table
                children: [
                  pw.TableRow(
                      children: [
                        pw.Container(
                            alignment: pw.Alignment.center,
                            padding: pw.EdgeInsets.all(20),
                            child: pw.Text("Volunteers First Year".toUpperCase(),style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 15)))
                      ]
                  ),
                  for(var i in first.keys)
                    pw.TableRow(
                      // This is the starting row for the table, within which the subsequent columns will be nested
                      children: [
                        pw.Column(
                            children: [
                              pw.Container(
                                padding: pw.EdgeInsets.only(left: 10,bottom: 10) ,
                                alignment: pw.Alignment.centerLeft,
                                child: pw.Text("$i",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 13)),
                              ),
                              pw.ListView.builder(

                                  itemCount: first[i].length,
                                  itemBuilder: (context, index) {
                                    return
                                      pw.Container(
                                          width: double.infinity,
                                          padding: pw.EdgeInsets.only(left: 30,bottom: 5),
                                          child :pw.Row(
                                              children: [
                                                pw.Container(
                                                  width: 30,
                                                  child:
                                                  pw.Text("${index+1}.   "),
                                                ),
                                                pw.Container(
                                                  alignment: pw.Alignment.centerLeft,
                                                  width: 300,
                                                  child:pw.Text('${first[i][index]["name"].toString().toUpperCase()}',),),

                                                pw.Container(
                                                  alignment: pw.Alignment.centerRight,
                                                  child:
                                                  pw.Text('${first[i][index]["sec_id"]}'),)
                                              ]
                                          ))

                                    ;}),
                              pw.Container(
                                  height: 15
                              )
                            ]
                        )



                      ],
                    ),
                ])];

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
          }
      ),

    );
    return pdf.save();
  }
}
//
// class PdfPreviewPage extends StatelessWidget {
//   String? text;
//   PdfPreviewPage(this.text, {Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PDF Preview'),
//       ),
//       body: PdfPreview(
//         build: (context) => makePdf(),
//       ),
//     );
//   }
//
//   Future<Uint8List> makePdf() async {
//     final pdf = pw.Document();
//     pdf.addPage(
//         pw.Page(
//             margin: const pw.EdgeInsets.all(10),
//             pageFormat: PdfPageFormat.a4,
//             build: (context) {
//               return pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                         children: [
//                           pw.Header(text: "About Cat", level: 1),
//                         ]
//                     ),
//                     pw.Divider(borderStyle: pw.BorderStyle.dashed),
//                     pw.Paragraph(text: text),
//                   ]
//               );
//             }
//         ));
//     return pdf.save();
//   }
// }
