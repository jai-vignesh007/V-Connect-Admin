import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'MyHomePage.dart';
import 'Utils.dart';
import 'report.dart';
import 'settings.dart';

class Draw extends StatefulWidget {
  const Draw({Key? key}) : super(key: key);

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.cancel_outlined,size: 30,))),
        const  Padding(
            padding:  EdgeInsets.only(top: 40.0),
            child: Icon(Icons.account_circle_rounded, size: 150),
          ),
         const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 25.0),
              child: Text(
                "ADMIN",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()));
              },
              child: Row(
                children: const [
                  Padding(
                    padding:  EdgeInsets.only(left: 15.0, right: 20),
                    child: Icon(Icons.home),
                  ),
                  Text(
                    "Home",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const Report()));
              },

              child: Row(
                children:const [
                  Padding(
                    padding:  EdgeInsets.only(left: 15.0, right: 20),
                    child: Icon(Icons.book_online),
                  ),
                  Text(
                    "Report",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                ModalRoute? currentRoute = ModalRoute.of(context);
                String? currentPageName = currentRoute!.settings.name;
                debugPrint('Current page: $currentPageName');
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Settings()));
              },
              child: Row(
                children:const [
                  Padding(
                    padding:  EdgeInsets.only(left: 15.0, right: 20),
                    child: Icon(Icons.settings),
                  ),
                  Text(
                    "Settings",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: InkWell(
              onTap: () {

              },
              child: Row(
                children:const [
                  Padding(
                    padding:  EdgeInsets.only(left: 15.0, right: 20),
                    child: Icon(Icons.people_sharp),
                  ),
                  Text(
                    "About Us",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                // FirebaseAuth.instance.signOut();
                Alert_box().showAlertDialog(context, "Are you Confirm to logout?", () {Navigator.pop(context); }, () {
                  FirebaseAuth.instance.signOut();
                  Navigator.popUntil(context, (route) => route.isFirst);
                });
              },
              child: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 20),
                    child: Icon(Icons.logout),
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
         const  SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:  [
                  IconButton(
                    icon:const  FaIcon(FontAwesomeIcons.linkedin,size: 35,color: Colors.blue,),
                    onPressed: (){
                      launchUrl(
                        Uri.parse('https://www.linkedin.com/company/nss-sairam/'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                  IconButton(
                    icon:const FaIcon(FontAwesomeIcons.instagram,size: 35,color: Colors.pinkAccent,),
                    onPressed: (){
                      launchUrl(
                        Uri.parse('https://www.instagram.com/sairamnss/'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.facebook,size: 35,color: Colors.blue,),
                    onPressed: (){
                      launchUrl(
                        Uri.parse('https://www.facebook.com/profile.php?id=100081822491748'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
