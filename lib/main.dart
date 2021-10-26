import 'package:ajstyle/login.dart';
import 'package:ajstyle/models/productModel.dart';
import 'package:ajstyle/order.dart';
import 'package:ajstyle/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config.dart';
import 'home.dart';
import 'settings.dart';
import 'splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'AJ STYLE | ADMIN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Login()
      /*home: FutureBuilder(
          future: Future.delayed(Duration(seconds: 3)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Splash();
            } else {
              return MainScren(index: 0);
            }
          })*/
      ,
    );
  }
}

class MainScren extends StatefulWidget {
  MainScren({Key key}) : super(key: key);

  @override
  _MainScrenState createState() => _MainScrenState();
}

class _MainScrenState extends State<MainScren> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Row(
          children: [
            Container(
              height: double.maxFinite,
              width: 100,
              color: kPrimaryColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: IconButton(
                        icon: Icon(
                          Icons.inventory,
                          color: kBackgroundColor,
                          size: 42,
                        ),
                        tooltip: "Inventry",
                        onPressed: () {
                          setState(() {
                            index = 0;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: IconButton(
                        tooltip: "Order",
                        icon: Icon(
                          Icons.shopping_bag,
                          color: kBackgroundColor,
                          size: 42,
                        ),
                        onPressed: () {
                          setState(() {
                            index = 1;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: kBackgroundColor,
                          size: 42,
                        ),
                        tooltip: "Settings",
                        onPressed: () {
                          setState(() {
                            index = 2;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                          color: kBackgroundColor,
                          size: 42,
                        ),
                        tooltip: "Log Out",
                        onPressed: () {
                          setState(() {
                            index = 3;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                child: index == 0
                    ? Home()
                    : (index == 1
                        ? Order()
                        : (index == 2
                            ? Settings()
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()))))),
          ],
        ),
      ),
    );
  }
}
