import 'package:flutter/material.dart';


const kPrimaryColor = Colors.black87;
//const kTextColor = Color(0xFF3C4046);
const kBackgroundColor = Colors.white;
const KPaddingHorizontal = 16.0;
const KPaddingVertical = 20.0;
const String accessKey = "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!";
const String url = "https://ajstyle.lk/php";



 InputDecoration decoration(String label) {
    return InputDecoration(
        labelText: label,
        counterText: "",
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black54)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black87)),
        contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8));
  }
