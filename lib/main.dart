import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import "MyHomePage.dart";
import 'Utils.dart';
import 'login.dart';
import 'package:google_fonts/google_fonts.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    scaffoldMessengerKey: messengerKey,
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    //onGenerateRoute: routes,
    home: const App(),
    theme: ThemeData(
      fontFamily: GoogleFonts.laila().fontFamily,
      primaryColor: Colors.grey,
      // primarySwatch: Colors.grey,
    ),
  ));
}
// Route routes(RouteSettings settings)
// {
//   if(settings.name== '/events')
//     {
//       return MaterialPageRoute(builder: (context)
//       {
//         return Events();
//       }
//       );
//     }
//   else
//     {
//       return MaterialPageRoute(builder: (context)
//       {
//         return Events();
//       }
//       );
//     }
// }

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text("erorrrr"));
              }
              else if (snapshot.hasData) {
                return const MyHomePage();
              } else {
                return Login();
              }
            }),
    );
  }
}
