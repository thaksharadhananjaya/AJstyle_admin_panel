import 'dart:convert';

import 'package:ajstyle/config.dart';
import 'package:ajstyle/main.dart';
import 'package:ajstyle/models/varientModel.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:http/http.dart' as http;

import 'models/sizechart.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  List<Color> colorList = [];
  List<String> sizeList = [];
  List<Varient> varientList = [];
  List<SizeChart> sizeChartList = [];
  int categoryID = 0;
  bool isLoading = false;
  List<int> imgBytes;
  Image imageWidget;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerName = new TextEditingController();
  TextEditingController textEditingControllerPrice =
      new TextEditingController();
  TextEditingController textEditingControllerSalePrice =
      new TextEditingController();
  TextEditingController textEditingControllerCategory =
      new TextEditingController();
  TextEditingController textEditingControllerDis = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  Container buildBody() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMainImage(),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32, top: 5),
                      child: TextFormField(
                        autofocus: true,
                        controller: textEditingControllerName,
                        validator: (text) {
                          if (text.isEmpty) {
                            return "Enter Name";
                          }
                          return null;
                        },
                        decoration: decoration("Product Name"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        buildCategoryDailog();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: TextFormField(
                          enabled: false,
                          controller: textEditingControllerCategory,
                          decoration: decoration("Select Category"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: TextFormField(
                        controller: textEditingControllerPrice,
                        validator: (text) {
                          if (text.isEmpty) {
                            return "Enter Price";
                          }
                          return null;
                        },
                        decoration: decoration("Price"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: TextFormField(
                        controller: textEditingControllerSalePrice,
                        validator: (text) {
                          if (text.isEmpty) {
                            return "Enter Sale Price";
                          } else if (double.parse(text) >
                              double.parse(textEditingControllerPrice.text)) {
                            return "The selling price should be less than the price";
                          }
                          return null;
                        },
                        decoration: decoration("Sale Price"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: TextFormField(
                        controller: textEditingControllerDis,
                        maxLines: 5,
                        validator: (text) {
                          if (text.isEmpty) {
                            return "Enter Sale Discription";
                          }
                          return null;
                        },
                        decoration: decoration("Discription"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 28),
                      child: Text("Colours"),
                    ),
                    buildColor(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 28),
                      child: Text("Sizes"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: buildSize(),
                    ),
                    Visibility(
                        visible: sizeList.isNotEmpty,
                        child: Column(
                          children: [
                            Container(
                              width: 150,
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                color: Colors.grey,
                                child: Text(sizeChartList.isNotEmpty
                                    ? "Change Size Chart"
                                    : "Set Size Chart"),
                                onPressed: buildSizeChartDialog,
                              ),
                            )
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Visibility(
                          visible: sizeChartList.isNotEmpty,
                          child: buildSizeTable()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Visibility(
                          visible: colorList.isNotEmpty && sizeList.isNotEmpty,
                          child: Container(
                            width: 150,
                            child: FlatButton(
                              color: Colors.grey,
                              child: Text(varientList.isEmpty
                                  ? "Set Varient"
                                  : "Change Varient"),
                              onPressed: buildVarientDailog,
                            ),
                          )),
                    ),
                    isLoading
                        ? Container(
                            height: 45,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: kPrimaryColor,
                            ),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white)),
                            ),
                          )
                        : SizedBox(
                            height: 45,
                            width: 100,
                            child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                color: kPrimaryColor,
                                onPressed: () {
                                  if (formKey.currentState.validate() &&
                                      varientList.isNotEmpty) {
                                    uploadProductData();
                                  } else {
                                    return;
                                  }
                                },
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSizeTable() {
    List<TableRow> rows = [];
    for (int i = 0; i < sizeChartList.length; ++i) {
      var parts = sizeChartList[i].data.toString().split('|');
      if (i == 0) {
        List<Text> cell = [];
        cell.add(Text(" Size", style: TextStyle(fontWeight: FontWeight.w700)));
        for (int j = 0; j < parts.length; j++) {
          cell.add(Text(" ${parts[j]} ",
              style: TextStyle(fontWeight: FontWeight.w600)));
        }
        rows.add(TableRow(children: cell));
      } else {
        List<Text> cell = [];
        for (int j = 0; j < parts.length; j++) {
          j == 0
              ? cell.add(Text(" ${parts[j]}",
                  style: TextStyle(fontWeight: FontWeight.w700)))
              : cell.add(Text(
                  parts[j],
                  textAlign: TextAlign.center,
                ));
        }
        rows.add(TableRow(children: cell));
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 10),
          child: Text("Size Chart (cm)",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        ),
        Table(
            border: TableBorder.all(),
            columnWidths: {0: FlexColumnWidth(0.6)},
            children: rows),
        SizedBox(
          height: 4,
        )
      ],
    );
  }

  Container buildMainImage() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.4,
      margin: EdgeInsets.only(right: 60),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.grey),
      child: GestureDetector(
        onTap: () {
          getImage();
        },
        child: Stack(
          children: [
            Align(
                alignment: Alignment.center,
                child: imageWidget != null
                    ? imageWidget
                    : Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 80,
                      )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      color: Colors.grey[300].withOpacity(0.7)),
                  child: Text(
                    imageWidget != null ? "Change Image" : "Select Image",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black54),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Row buildColor() {
    return Row(
      children: [
        Container(
          width: colorList.length < 12
              ? 68.0 * colorList.length
              : MediaQuery.of(context).size.width * 0.48,
          height: 60,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: colorList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 28,
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: colorList[index],
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: colorPicker,
            icon: Icon(Icons.add),
            tooltip: "Add new colour",
          ),
        )
      ],
    );
  }

  Row buildSize() {
    return Row(
      children: [
        Container(
          width: sizeList.length < 12
              ? 68.0 * sizeList.length
              : MediaQuery.of(context).size.width * 0.48,
          height: 60,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: sizeList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 28,
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: kBackgroundColor,
                      child: Text(sizeList[index].toUpperCase()),
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: addSize,
            icon: Icon(Icons.add),
            tooltip: "Add new size",
          ),
        )
      ],
    );
  }

  Future colorPicker() {
    Color selectColor;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add colour'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: Colors.black,
                onColorChanged: (color) {
                  selectColor = color;
                },
                showLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Add'),
                onPressed: () {
                  varientList.clear();
                  setState(() {
                    colorList.add(selectColor);
                    colorList = colorList.toSet().toList();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future buildSizeChartDialog() {
    List<TextEditingController> textControllerList = new List();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Set Size Chart'),
            content: Container(
              width: 400,
              height: (50.0 * sizeList.length) + 60,
              child: ListView.builder(
                  itemCount: sizeList.length + 1,
                  itemBuilder: (context, index) {
                    textControllerList.add(new TextEditingController());
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            SizedBox(width: 50, child: Text("Label")),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 340,
                              height: 40,
                              child: TextField(
                                controller: textControllerList[0],
                                decoration: decoration("Sizes"),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 50,
                              child: Text(sizeList[index - 1].toUpperCase())),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 340,
                            height: 40,
                            child: TextField(
                              controller: textControllerList[index],
                              decoration: decoration("Sizes"),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: const Text('Set'),
                onPressed: () {
                  sizeChartList.clear();
                  setState(() {
                    for (int i = 0; i < textControllerList.length; i++) {
                      print(textControllerList[i].text);
                      if (i == 0) {
                        sizeChartList
                            .add(SizeChart(textControllerList[0].text, 1));
                      } else {
                        sizeChartList.add(SizeChart(
                            "${sizeList[i - 1]}|${textControllerList[i].text}",
                            0));
                      }
                    }
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future addSize() {
    TextEditingController textEditingControllerSize =
        new TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Size'),
            content: SingleChildScrollView(
              child: TextField(
                autofocus: true,
                controller: textEditingControllerSize,
                decoration: decoration("Enter Size Label"),
                maxLength: 3,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Add'),
                onPressed: () {
                  varientList.clear();
                  setState(() {
                    sizeList.add(textEditingControllerSize.text);
                    sizeList = sizeList.toSet().toList();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future buildCategoryDailog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Categoty'),
            content: FutureBuilder(
                future: getCategory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      width: 120,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length - 1,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              height: 35,
                              margin: EdgeInsets.only(bottom: 5),
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: index % 2 == 0
                                      ? Colors.grey[300]
                                      : Colors.grey[200]),
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  textEditingControllerCategory.text =
                                      snapshot.data[index + 1]["category"];
                                  categoryID = int.parse(
                                      snapshot.data[index + 1]["categoryID"]);
                                },
                                child:
                                    Text(snapshot.data[index + 1]["category"]),
                              ),
                            );
                          }),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          );
        });
  }

  Future buildVarientDailog() {
    if (varientList.isEmpty) {
      for (Color color in colorList) {
        for (String size in sizeList) {
          String colorValue =
              color.toString().substring(6, color.toString().length - 1);
          varientList
              .add(new Varient(colorValue, size, null, null, null, null));
        }
      }
    }

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Varient'),
            content: SizedBox(
              width: 80,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: varientList.length,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 35,
                      margin: EdgeInsets.only(bottom: 5),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: index % 2 == 0
                              ? Colors.grey[300]
                              : Colors.grey[200]),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          buildVarientInventary(varientList[index].color,
                              varientList[index].size);
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  Color(int.parse(varientList[index].color)),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(varientList[index].size.toUpperCase())
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          );
        });
  }

  Future buildVarientInventary(String color, String size) {
    final GlobalKey<FormState> formKeyVarient = GlobalKey<FormState>();
    TextEditingController textEditingControllerQty =
        new TextEditingController();
    TextEditingController textEditingControllerPrice =
        new TextEditingController();
    TextEditingController textEditingControllerSalePrice =
        new TextEditingController();
    List<int> imgBytes;
    Image imageWidget;
    String baseimage;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(int.parse(color)),
                ),
                SizedBox(
                  width: 16,
                ),
                Text("${size.toUpperCase()}"),
              ],
            ),
            content: StatefulBuilder(builder: (context, setState) {
              return Container(
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            var mediaData = await ImagePickerWeb.getImageInfo;

                            if (mediaData != null) {
                              setState(() {
                                baseimage = base64Encode(mediaData.data);
                                imageWidget = Image.memory(
                                  mediaData.data,
                                  fit: BoxFit.fill,
                                  width: 200,
                                  height: 250,
                                );
                              });
                            }
                          },
                          child: buildVarientImage(imageWidget)),
                      SizedBox(
                        width: 200,
                        child: Form(
                          key: formKeyVarient,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 32, top: 5),
                                child: TextFormField(
                                  autofocus: true,
                                  controller: textEditingControllerQty,
                                  validator: (text) {
                                    if (text.isEmpty) {
                                      return "Enter Quentity";
                                    }
                                    return null;
                                  },
                                  decoration: decoration("Quentity"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: TextFormField(
                                  controller: textEditingControllerPrice,
                                  validator: (text) {
                                    if (text.isEmpty) {
                                      return "Enter Price";
                                    }
                                    return null;
                                  },
                                  decoration: decoration("Price"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: TextFormField(
                                  controller: textEditingControllerSalePrice,
                                  validator: (text) {
                                    if (text.isEmpty) {
                                      return "Enter Sale Price";
                                    }
                                    return null;
                                  },
                                  decoration: decoration("Sale Price"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
            actions: <Widget>[
              FlatButton(
                child: const Text('Apply'),
                onPressed: () {
                  if (formKeyVarient.currentState.validate()) {
                    for (int i = 0; i < varientList.length; i++) {
                      if (varientList[i].color == color &&
                          varientList[i].size == size) {
                        varientList[i].price =
                            double.parse(textEditingControllerPrice.text);
                        varientList[i].salePrice =
                            double.parse(textEditingControllerSalePrice.text);
                        varientList[i].qty =
                            int.parse(textEditingControllerQty.text);
                        varientList[i].image = baseimage;
                      }
                    }
                    for (Varient varients in varientList) {
                      print("q: ${varients.qty}");
                      print("p: ${varients.price}");
                      print("s: ${varients.salePrice}");
                    }
                    Navigator.of(context).pop();
                  } else {
                    return;
                  }
                },
              ),
            ],
          );
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

  Future<void> getImage() async {
    var mediaData = await ImagePickerWeb.getImageInfo;

    if (mediaData != null) {
      setState(() {
        imgBytes = mediaData.data;
        imageWidget = Image.memory(
          mediaData.data,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.4,
        );
      });
    }
  }

  Container buildVarientImage(Image image) {
    return Container(
      width: 200,
      height: 250,
      margin: EdgeInsets.only(right: 40),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.grey),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: image == null
                  ? Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 80,
                    )
                  : image),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 40,
                alignment: Alignment.center,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: Colors.grey[300]),
                child: Text(
                  image == null ? "Select Image" : "Change Image",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black54),
                )),
          )
        ],
      ),
    );
  }

  Future<void> uploadProductData() async {
    setState(() {
      isLoading = true;
    });
    try {
      //print(imgBytes);
      String baseimage = base64Encode(imgBytes);
      // ignore: deprecated_member_use
      List varient = List();
      // ignore: deprecated_member_use
      List sizeChart = List();
      varientList.map((item) => varient.add(item.toJson())).toList();
      sizeChartList.map((item) => sizeChart.add(item.toJson())).toList();

      var response =
          await http.post(Uri.parse("$url/insertProduct.php"), body: {
        "key": accessKey,
        'image': "$baseimage",
        'name': "${textEditingControllerName.text}",
        'price': "${textEditingControllerPrice.text}",
        'salePrice': "${textEditingControllerSalePrice.text}",
        "category": "$categoryID",
        "discription": "${textEditingControllerDis.text}",
        "varient": "$varient",
        "sizeChart": "$sizeChart"
      });

      var data = await json.decode(response.body);
      print("data: $data");
      if (data.toString() == "false" || data.toString() == "-1") {
        isLoading = false;
        Flushbar(
          message: 'Upload faild!',
          messageColor: Colors.red,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScren()));
        Flushbar(
          message: 'New product added',
          messageColor: Colors.green,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.info_rounded,
            color: Colors.green,
          ),
        ).show(context);
      }
    } catch (e) {
      print("Error during converting to Base64");
    }
  }
}
