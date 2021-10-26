import 'dart:convert';

import 'package:ajstyle/config.dart';
import 'package:ajstyle/main.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode focusNodePass = new FocusNode();
  String userName;
  String password;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 700) {
      return WillPopScope(onWillPop: null, child: buildMobileLogin());
    } else {
      return WillPopScope(onWillPop: null, child: buildDesktopLogin());
    }
  }

  Scaffold buildDesktopLogin() {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 80,
            child: Form(
              key: formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 200, vertical: 28),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/ajlogo.png',
                      fit: BoxFit.scaleDown,
                      width: 140,
                      height: 140,
                    ),
                    SizedBox(height: 50),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login to your account',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        )),
                    SizedBox(
                      height: 20,
                    ),

                    // User Name
                    TextFormField(
                        maxLength: 20,
                        autofocus: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'User Name',
                            counter: Text(''),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black87)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 8)),
                        validator: (text) {
                          RegExp regex = new RegExp("[']");
                          RegExp regex2 = new RegExp('["]');
                          if (text.isEmpty)
                            return 'Enter User Name';
                          else if (regex.hasMatch(text)) {
                            return 'Invalid User Name !';
                          } else if (regex2.hasMatch(text)) {
                            return 'Invalid User Name !';
                          }
                          return null;
                        },
                        onFieldSubmitted: (text) {
                          focusNodePass.requestFocus();
                        },
                        onSaved: (value) {
                          userName = value;
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    // Password
                    TextFormField(
                        maxLength: 8,
                        focusNode: focusNodePass,
                        obscureText: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Password',
                            counter: Text(''),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black87)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 8)),
                        validator: (text) {
                          RegExp regex = new RegExp("[']");
                          RegExp regex2 = new RegExp('["]');
                          if (text.isEmpty) {
                            return 'Enter Password';
                          } else if (regex.hasMatch(text)) {
                            return 'Invalid Password !';
                          } else if (regex2.hasMatch(text)) {
                            return 'Invalid Password !';
                          }
                          return null;
                        },
                        onFieldSubmitted: (text) {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            login();
                          } else {
                            return;
                          }
                        },
                        onSaved: (value) {
                          password = value;
                        }),
                    SizedBox(
                      height: 50,
                    ),

                    // Loging Buttons
                    Container(
                      width: MediaQuery.of(context).size.width / 6,
                      height: 50,

                      // ignore: deprecated_member_use
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: kPrimaryColor,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            login();
                          } else {
                            return;
                          }
                        },
                      ),
                    ),

                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 80,
            width: double.maxFinite,
            color: kPrimaryColor,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Copyright © 2021 AJStyle - All Rights Reserved",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      await launch('https://www.widdev.com',
                          forceSafariVC: false, forceWebView: false);
                    },
                    child: Text(
                      'Developed By Widdev',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Scaffold buildMobileLogin() {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 45,
            child: Form(
              key: formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/ajlogo.png',
                      fit: BoxFit.scaleDown,
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 50),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login to your account',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        )),
                    SizedBox(
                      height: 20,
                    ),

                    // User Name
                    TextFormField(
                        maxLength: 20,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'User Name',
                            counter: Text(''),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black87)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 8)),
                        validator: (text) {
                          RegExp regex = new RegExp("[']");
                          RegExp regex2 = new RegExp('["]');
                          if (text.isEmpty)
                            return 'Enter User Name';
                          else if (regex.hasMatch(text)) {
                            return 'Invalid User Name !';
                          } else if (regex2.hasMatch(text)) {
                            return 'Invalid User Name !';
                          }
                          return null;
                        },
                        onFieldSubmitted: (text) {
                          focusNodePass.requestFocus();
                        },
                        onSaved: (value) {
                          userName = value;
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    // Password
                    TextFormField(
                        maxLength: 8,
                        focusNode: focusNodePass,
                        obscureText: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Password',
                            counter: Text(''),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black87)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 8)),
                        validator: (text) {
                          RegExp regex = new RegExp("[']");
                          RegExp regex2 = new RegExp('["]');
                          if (text.isEmpty) {
                            return 'Enter Password';
                          } else if (regex.hasMatch(text)) {
                            return 'Invalid Password !';
                          } else if (regex2.hasMatch(text)) {
                            return 'Invalid Password !';
                          }
                          return null;
                        },
                        onFieldSubmitted: (text) {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            login();
                          } else {
                            return;
                          }
                        },
                        onSaved: (value) {
                          password = value;
                        }),
                    SizedBox(
                      height: 50,
                    ),

                    // Loging Buttons
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 50,

                      // ignore: deprecated_member_use
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: kPrimaryColor,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            login();
                          } else {
                            return;
                          }
                        },
                      ),
                    ),

                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 45,
            width: double.maxFinite,
            color: kPrimaryColor,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Copyright © 2021 AJStyle - All Rights Reserved",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                SizedBox(
                  height: 5,
                ),
                MouseRegion(
                   cursor: SystemMouseCursors.click,
                  child: GestureDetector(

                    onTap: () async {
                      await launch('https://www.widdev.com',
                          forceSafariVC: false, forceWebView: false);
                    },
                    child: Text(
                      'Developed By Widdev',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                          fontSize: 11),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future buildVerifivation() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          new TextEditingController();
          return WillPopScope(
            onWillPop: () async => null,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                "Sign In...",
              ),
              titlePadding: EdgeInsets.only(left: 16, top: 0, bottom: 6),
              content: Container(
                  alignment: Alignment.center,
                  height: 80,
                  width: MediaQuery.of(context).size.width < 700
                      ? double.maxFinite
                      : MediaQuery.of(context).size.width / 2.5,
                  child: CircularProgressIndicator()),
            ),
          );
        });
  }

  void login() async {
    print(userName);
    print(password);
    String path = "$url/loginAdmin.php";
    print(path);
    buildVerifivation();
    try {
      final response = await http.post(Uri.parse(path), body: {
        "key": "$accessKey",
        "user": "$userName",
        "password": "$password",
      });

      String data = jsonDecode(response.body).toString();
      print(data);
      if (data == '1') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScren()));
      } else {
        Navigator.of(context).pop();
        Flushbar(
          message: 'Wrong user name or password !',
          maxWidth: MediaQuery.of(context).size.width < 550
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2,
          messageColor: Colors.red,
          messageSize: 18,
          duration: Duration(seconds: 4),
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      }
    } catch (e) {
      print(e);
    }
  }
}
