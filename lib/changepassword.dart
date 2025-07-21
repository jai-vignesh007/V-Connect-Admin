import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  String pass = '';
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffdadada),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
            size: 35,
          ),
        ),
        title: SizedBox(
          height: 50,
          width: double.infinity,
          child: TextField(
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
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
                size: 35,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 35),
            const Text("CHANGE PASSWORD",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: MediaQuery.of(context).size.width * 0.99,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  15.0, 15.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                      label: Row(
                                        children: const [
                                          Text("E-MAIL ID ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          Text('*',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          Padding(
                                            padding: EdgeInsets.all(1.0),
                                          ),
                                        ],
                                      ),
                                      //suffixText: Text("SEND OTP")
                                      suffix: GestureDetector(
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Text(
                                            "SEND OTP ",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        onTap: () => {},
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Email id Required";
                                      } else if (!EmailValidator.validate(
                                          value)) {
                                        return "Enter valid email id";
                                      } else {
                                        return null;
                                      }
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                      label: Row(
                                        children: const [
                                          Text(
                                            "ENTER OTP ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text('*',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          Padding(
                                            padding: EdgeInsets.all(1.0),
                                          ),
                                        ],
                                      ),
                                      suffix: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          "VERIFY",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter the OTP";
                                      } else {
                                        return null;
                                      }
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                      label: Row(
                                        children: const [
                                          Text("ENTER NEW PASSWORD ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          Text('*',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          Padding(
                                            padding: EdgeInsets.all(1.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    validator: (value) {
                                      pass = value!;
                                      if (value.isEmpty) {
                                        return "Enter your new password";
                                      } else {
                                        return null;
                                      }
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      label: Row(
                                        children: const [
                                          Text("CONFIRM PASSWORD ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          Text('*',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          Padding(
                                            padding: EdgeInsets.all(1.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please re-enter your password";
                                      } else if (value != pass) {
                                        return "password Does not match";
                                      } else {
                                        return null;
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Scaffold.of(context).showSnackBar(snackBar);

                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        Color(0xff00C6CF),
                        Color(0xff00A0CB),
                        Color(0xff3777B3),
                        Color(0xff594D87),
                        Color(0xff5C2551)
                      ]),
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.061,
                    width: MediaQuery.of(context).size.width * 0.80,
                    alignment: Alignment.center,
                    child: const Text(
                      'SAVE',
                      style: TextStyle(
                          fontSize: 24, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
