import 'dart:convert';

import 'package:ajstyle/config.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'orderItems.dart';

class Order extends StatefulWidget {
  Order({Key key}) : super(key: key);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 60, vertical: KPaddingVertical),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              buildOrders(context),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildOrders(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
          future: getOrders(context),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != '0') {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = snapshot.data[index];
                    return builtCard(context, index, data);
                  });
            } else if (snapshot.data == '0') {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/noOrder.png",
                      width: 250,
                    ),
                    Text(
                      "No Order Found !",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              );
            }
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
              child: Column(
                children: [
                  CardLoading(
                    height: 60,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CardLoading(
                    height: 60,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CardLoading(
                    height: 60,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CardLoading(
                    height: 60,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                ],
              ),
            );
          }),
    );
  }

  Container builtCard(BuildContext context, int index, data) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 9)
          ],
          color: index % 2 == 0 ? Colors.white : Colors.white54),
      // ignore: deprecated_member_use
      child: FlatButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderItems(
                        orderID: int.parse(data['orderID']),
                        name: data['name'],
                        mobile: data['mobile'],
                        address: data['address'],
                        city: data['city'],
                        district: data['district'],
                        total: double.parse(
                          data['total'],
                        ),
                      )));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "#${data['orderID']}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black54),
            ),
            Text("${data['date']}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black54)),
            Text(
                "LKR ${(double.parse(data['total']) + 300).toStringAsFixed(2)}  ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black54)),
            FlatButton(
                onPressed: () => buildStatusDailog(int.parse(data['orderID'])),
                child: Text(
                    data["status"] == "0"
                        ? "Processing"
                        : (data["status"] == "1"
                            ? "Shipped"
                            : "Contact Failure"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black54)))
          ],
        ),
      ),
    );
  }

  Future buildStatusDailog(int orderID) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
                width: 200,
                height: 300,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: SizedBox(
                        width: 190,
                        height: 40,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: kPrimaryColor,
                            onPressed: () =>
                                setOrderStatus(context, orderID, 0),
                            child: Text("Mark AS Processing",
                                style: TextStyle(color: Colors.white))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: SizedBox(
                        width: 190,
                        height: 40,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: kPrimaryColor,
                            onPressed: () =>
                                setOrderStatus(context, orderID, 1),
                            child: Text(
                              "Mark AS Shipped",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: SizedBox(
                        width: 190,
                        height: 40,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: kPrimaryColor,
                            onPressed: () =>
                                setOrderStatus(context, orderID, 2),
                            child: Text("Mark AS Contact Failure",
                                style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  Future getOrders(BuildContext context) async {
    try {
      String path = "$url/getOrderAdmin.php";

      final response =
          await http.post(Uri.parse(path), body: {"key": accessKey});
      var data = jsonDecode(response.body);
      return data;
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

  void setOrderStatus(BuildContext context, int orderID, int status) async {
    Navigator.of(context).pop();
    try {
      String path = "$url/setOrderStatus.php";

      var response = await http.post(Uri.parse(path),
          body: {"key": accessKey, "status": "$status", "orderID": "$orderID"});
      var data = jsonDecode(response.body);
      if (data.toString() == "1") {
        setState(() {});
        Flushbar(
          message: 'Updated',
          messageColor: Colors.green,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.info_rounded,
            color: Colors.green,
          ),
        ).show(context);
      } else {}
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
