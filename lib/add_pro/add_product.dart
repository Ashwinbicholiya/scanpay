import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:retail/services/product_crud.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String barcode;
  String name;
  String price;
  String netweight;
  String imageUrl;
  String producttype;
  String _scanBarcode;

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Cancel", true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    crudProduct crudObj = new crudProduct();

    return Scaffold(
      floatingActionButton: floatingBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey.shade100,
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 70.0),
              Container(
                color: Colors.white10,
                width: 400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'AddDetails',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold,
                          fontSize: 45),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60),
              Container(
                width: 350,
                child: TextField(
                  keyboardType: TextInputType.url,
                  style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Image Url",
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.w200, fontSize: 20),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    this.imageUrl = value;
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 350,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Net Weight",
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.w200, fontSize: 20),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    this.netweight = value;
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 40,
                width: 350,
                child: Text(
                  'Barcode $_scanBarcode',
                  style: TextStyle(fontSize: 20),
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.vertical(),
                  shape: BoxShape.rectangle,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                child: TextField(
                  keyboardType: TextInputType.text,
                  maxLength: 15,
                  style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.w200, fontSize: 20),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    this.name = value;
                  },
                ),
              ),
              Container(
                width: 350,
                child: TextField(
                  keyboardType: TextInputType.text,
                  maxLength: 15,
                  style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Product Type",
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.w200, fontSize: 20),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    this.producttype = value;
                  },
                ),
              ),
              Container(
                width: 350,
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Price",
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.w200, fontSize: 20),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    this.price = value;
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Map<String, dynamic> products = {
                        'barcode': '$_scanBarcode',
                        'img': this.imageUrl,
                        'name': this.name,
                        'netweight': this.netweight,
                        'price': this.price,
                        'producttype':this.producttype,
                      };
                      crudObj.addData(products).then((result) {
                        dialogTrigger(context);
                      }).catchError((e) {
                        print(e);
                      });
                    },
                    elevation: 4.0,
                    splashColor: Colors.yellow,
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.red.shade400,
                    onPressed: () {
                      Navigator.of(context).pop();
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.of(context)
                            .pushReplacementNamed('\loginpage');
                      }).catchError((e) {
                        print(e);
                      });
                    },
                    elevation: 4.0,
                    splashColor: Colors.yellow,
                    child: Text(
                      'Back',
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget floatingBar() => Ink(
        decoration: ShapeDecoration(
          shape: StadiumBorder(),
        ),
        child: FloatingActionButton.extended(
          onPressed: () => scanBarcodeNormal(),
          backgroundColor: Colors.black,
          icon: Icon(
            FontAwesomeIcons.barcode,
            color: Colors.white,
          ),
          label: Text(
            "SCAN",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
}

Future<bool> dialogTrigger(BuildContext context) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Job done', style: TextStyle(fontSize: 22.0)),
          content: Text(
            'Added Successfully',
            style: TextStyle(fontSize: 20.0),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Alright',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
