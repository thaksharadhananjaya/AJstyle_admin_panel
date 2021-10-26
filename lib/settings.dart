import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class Settings extends StatelessWidget {
  Settings({Key key}) : super(key: key);
  TextEditingController textEditingControllerWA = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    getWApp(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 44),
            child: SizedBox(
              width: 200,
              child: TextFormField(
                autofocus: true,
                controller: textEditingControllerWA,
                decoration: decoration("Whatsapp"),
                keyboardType: TextInputType.number,
                maxLength: 10,
              ),
            ),
          ),
          SizedBox(
              width: 100,
              height: 40,
              child: FlatButton(
                  color: kPrimaryColor,
                  onPressed: () => setWApp(context),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  )))
        ],
      ),
    );
  }

  Future getWApp(BuildContext context) async {
    try {
      String path = "$url/getWApp.php";

      final response =
          await http.post(Uri.parse(path), body: {"key": accessKey});
      String data = jsonDecode(response.body).toString();
      print(data);
      textEditingControllerWA.text = data;
    } catch (e) {
     
    }
  }

  Future setWApp(BuildContext context) async {
    try {
      String path = "$url/setWApp.php";

      final response = await http.post(Uri.parse(path),
          body: {"key": accessKey, "wapp": "${textEditingControllerWA.text}"});
      String data = jsonDecode(response.body).toString();
      if (data == "1") {
        Flushbar(
          message: 'Whatsapp number updated !',
          messageColor: Colors.green,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 4),
          icon: Icon(
            Icons.info_rounded,
            color: Colors.green,
          ),
        ).show(context);
      }
    } catch (e) {
      Flushbar(
        message: 'No internet connection !',
        messageColor: Colors.red,
        backgroundColor: kPrimaryColor,
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.warning_rounded,
          color: Colors.red,
        ),
      ).show(context);
    }
  }
}
