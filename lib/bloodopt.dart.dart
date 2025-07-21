// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'blooddonor.dart';
import 'drawer.dart';
import 'nonvolblood.dart';

class Blood_opt extends StatefulWidget {
  const Blood_opt({Key? key}) : super(key: key);

  @override
  State<Blood_opt> createState() => _Blood_optState();
}

class _Blood_optState extends State<Blood_opt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: Colors.white,
        // toolbarHeight: 70,
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

        title: const Center(
          child: Text(
    "Blood Donation",
    style: TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold),
    ),
        ),

      ),
    drawer: const Draw(),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 60,  right: 60),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Blood()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 10,
                        shadowColor: Colors.black

                      // foreground (text) color
                    ),
                    child: const Text(
                      "Volunteers",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, top: 30, right: 60),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const NonVol_blood())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 10,
                        shadowColor: Colors.black

                      // foreground (text) color
                    ),
                    child: const Text(
                      "Non Volunteers",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
