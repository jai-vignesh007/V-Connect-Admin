import 'package:flutter/material.dart';
import 'package:nssadmin/drawer.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffdadada),
      appBar: AppBar(

        backgroundColor: Colors.white,

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
       title: Padding(
         padding: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.135),
         child: Row(

           children:const [
             Icon(
               Icons.settings,
               color: Colors.black,
               size: 35,
             ),
             Text(
               "  SETTINGS",
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
             )
           ],
         ),
       ),
centerTitle: true,
      ),
      drawer: const Draw(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Icon(
                      Icons.account_circle_rounded,
                      color: Colors.black,
                      size: 25,
                    ),
                    Text(
                      "  ACCOUNT",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 20, left: 20, top: 8.0, bottom: 8),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(">", style: TextStyle(color: Colors.black)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  left: 20,
                ),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Change Password",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(">", style: TextStyle(color: Colors.black)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 20, left: 20, top: 8.0, bottom: 8),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Feedback",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(">", style: TextStyle(color: Colors.black)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Icon(
                      Icons.notifications,
                      color: Colors.black,
                      size: 25,
                    ),
                    Text(
                      "  NOTIFICATION",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 20, left: 20, top: 8.0, bottom: 8),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Notification",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(">", style: TextStyle(color: Colors.black)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 8),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "App Notification",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(">", style: TextStyle(color: Colors.black)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Icon(
                      Icons.more,
                      color: Colors.black,
                      size: 25,
                    ),
                    Text(
                      "  MORE",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 8.0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Language",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(">", style: TextStyle(color: Colors.black)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 20, left: 20, top: 8.0, bottom: 8),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Country",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(">", style: TextStyle(color: Colors.black)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
