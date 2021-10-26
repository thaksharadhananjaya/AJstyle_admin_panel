import 'dart:convert';

import 'package:ajstyle/product.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:http/http.dart' as http;
import 'package:card_loading/card_loading.dart';
import 'bloc/product_bloc.dart';
import 'config.dart';
import 'util/comfirmDailogBox.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textEditingControllerSearch =
      new TextEditingController();
  ProductBloc productBloc, saleProductBloc;
  int indexCategory = 0;
  String cusID;
  @override
  void initState() {
    super.initState();

    productBloc = ProductBloc(false, null, 0);
    productBloc.add(FetchProduct());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => null,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: buidAppBar(),
        body: buidBody(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: Icon(Icons.add, color: Colors.white,),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddProduct()));
          },
        ),
      ),
    );
  }

  Widget buidBody() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            SizedBox(
              height: KPaddingVertical,
            ),
            buildCategory(),
            buidProductList(),
          ],
        ),
      ),
    );
  }

  Widget buidProductList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
      child: BlocBuilder(
          bloc: productBloc,
          builder: (context, state) {
            if (state is LoadedProduct) {
              return LazyLoadScrollView(
                onEndOfPage: () => productBloc.add(FetchProduct()),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 40.0),
                  shrinkWrap: true,
                  itemCount: state.productList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildProductCard(context, state, index);
                  },
                ),
              );
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: 8,
                  padding: EdgeInsets.only(top: 40),
                  itemBuilder: (context, index) {
                    return CardLoading(
                      height: 100,
                      padding: const EdgeInsets.only(bottom: 8),
                      borderRadius: 15,
                    );
                  }),
            );
          }),
    );
  }

  Future buildNewCategoryDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController textEditingControllerCategory =
              new TextEditingController();
          return WillPopScope(
            onWillPop: () async => null,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add New Category",
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onPressed: () => Navigator.of(context).pop()),
                  )
                ],
              ),
              titlePadding: EdgeInsets.only(left: 16, top: 0, bottom: 6),
              content: TextField(
                controller: textEditingControllerCategory,
                inputFormatters: [
                  // ignore: deprecated_member_use
                  new WhitelistingTextInputFormatter(RegExp("[a-zA-Z-0-9- ]")),
                ],
                autofocus: true,
                onSubmitted: (text) {
                  if (text.isNotEmpty) {
                    addCategory(text);
                  }
                },
                decoration: InputDecoration(
                    labelText: "Category",
                    counterText: "",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black87)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 6, vertical: 8)),
                maxLength: 150,
              ),
              actions: [
                SizedBox(
                  height: 36,
                  width: 100,

                  // ignore: deprecated_member_use
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (textEditingControllerCategory.text.isNotEmpty) {
                          FocusScope.of(context).unfocus();
                          addCategory(textEditingControllerCategory.text);
                        }
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          );
        });
  }

  Container buildProductCard(
      BuildContext context, LoadedProduct state, int index) {
    print(state.productList[index].image);
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: Text(state.productList[index].productID.toString(),
                    style: TextStyle(fontSize: 22, color: kPrimaryColor)),
              ),
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(right: 32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      state.productList[index].image,
                    ),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "${state.productList[index].name}\n\n"
                            .toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: kPrimaryColor)),
                    TextSpan(
                      text:
                          "LKR ${double.parse(state.productList[index].salePrice).toStringAsFixed(2)}\n",
                      style: TextStyle(fontSize: 22, color: kPrimaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 80,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green),
                child: IconButton(
                    onPressed: null,
                    tooltip: "Edit",
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 40,
                    )),
              ),
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), color: Colors.red),
                child: IconButton(
                    onPressed: () =>
                        buildDeleteProduct(state.productList[index].productID),
                    tooltip: "Delete",
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 40,
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

  Row buildCategory() {
    return Row(
      children: [
        Container(
          height: 30.0,
          child: FutureBuilder(
              future: getCategory(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = snapshot.data[index];

                      if (index == indexCategory) {
                        return GestureDetector(
                          onLongPress: data['category'].toString() != "All"
                              ? () {
                                  buildDeleteCategory(
                                      int.parse(data['categoryID']));
                                }
                              : null,
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.0),
                              width: 100,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(18.0)),
                              child: Center(
                                  child: Text(
                                data['category'],
                                style: TextStyle(color: Colors.white),
                              ))),
                        );
                      } else {
                        return GestureDetector(
                          onLongPress: data['category'].toString() != "All"
                              ? () {
                                  buildDeleteCategory(
                                      int.parse(data['categoryID']));
                                }
                              : null,
                          onTap: () {
                            textEditingControllerSearch.clear();
                            productBloc = ProductBloc(false, null, index);
                            productBloc.add(FetchProduct());
                            setState(() {
                              indexCategory = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            width: 100,
                            height: 10,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(18.0)),
                            child: Center(
                                child: Text(
                              data['category'],
                              style: TextStyle(color: Colors.black),
                            )),
                          ),
                        );
                      }
                    },
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      CardLoading(
                        height: 40,
                        width: 120,
                        padding: const EdgeInsets.only(bottom: 8),
                        borderRadius: 15,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      CardLoading(
                        height: 40,
                        width: 120,
                        padding: const EdgeInsets.only(bottom: 8),
                        borderRadius: 15,
                      ),
                    ],
                  ),
                );
              }),
        ),
        IconButton(
          onPressed: buildNewCategoryDialogBox,
          icon: Icon(Icons.add),
          tooltip: "Add new category",
        )
      ],
    );
  }

  AppBar buidAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 4,
      leading: Icon(
        Icons.access_alarm_sharp,
        color: kBackgroundColor,
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 13.0),
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(246, 246, 246, 1),
              //color : Colors.red,
              borderRadius: BorderRadius.circular(15.0)),
          child: TextField(
            controller: textEditingControllerSearch,
            inputFormatters: [
              // ignore: deprecated_member_use
              new WhitelistingTextInputFormatter(RegExp("[a-zA-Z-0-9-+_)( ]")),
            ],
            onChanged: (text) {
              if (text.isEmpty) {
                setState(() {
                  indexCategory = 0;
                  productBloc = ProductBloc(false, null, 0);
                  productBloc.add(FetchProduct());
                });
              }
            },
            onSubmitted: (text) {
              setState(() {
                if (text.isNotEmpty) {
                  indexCategory = 0;
                  productBloc = ProductBloc(false, text, 0);
                  productBloc.add(FetchProduct());
                }
              });
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search ...",
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }

  Future buildDeleteCategory(int id) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ComfirmDailogBox(
              yesButton: FlatButton(
                child: Text('Yes',
                    style: TextStyle(fontSize: 17, color: Colors.white)),
                onPressed: () => deleteCategory(id),
              ),
              icon: Icon(
                Icons.delete,
                color: Colors.white,
                size: 48,
              ));
        });
  }

  Future buildDeleteProduct(int id) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ComfirmDailogBox(
              yesButton: FlatButton(
                child: Text('Yes',
                    style: TextStyle(fontSize: 17, color: Colors.white)),
                onPressed: () => deleteProduct(id),
              ),
              icon: Icon(
                Icons.delete,
                color: Colors.white,
                size: 48,
              ));
        });
  }

  Future getCategory() async {
    try {
      String path = "$url/getCategory.php";

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

  Future addCategory(String category) async {
    try {
      String path = "$url/addCategory.php";

      await http.post(Uri.parse(path),
          body: {"key": accessKey, "category": "$category"});

      setState(() {});
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

  Future deleteCategory(int categoryID) async {
    try {
      String path = "$url/deleteCategory.php";

      await http.post(Uri.parse(path),
          body: {"key": accessKey, "categoryID": "$categoryID"});
      Navigator.of(context).pop();
      setState(() {});
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

  Future deleteProduct(int productID) async {
    try {
      String path = "$url/deleteProduct.php";

      await http.post(Uri.parse(path),
          body: {"key": accessKey, "productID": "$productID"});
      Navigator.of(context).pop();
      productBloc = ProductBloc(false, null, 0);
      productBloc.add(FetchProduct());
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
