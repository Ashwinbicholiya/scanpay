import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _scanBarcode;

  @override
  void initState() {
    super.initState();
  }

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
    return Scaffold(
      floatingActionButton: floatingBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: buildAppBar(),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            FutureBuilder(
                future: FirebaseAuth.instance.currentUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return UserAccountsDrawerHeader(
                        currentAccountPicture: new CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              "https://cdn2.iconfinder.com/data/icons/website-icons/512/User_Avatar-512.png"),
                        ),
                        accountEmail: Text(
                          "${snapshot.data.email}",
                          style: TextStyle(fontSize: 19),
                        ));
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text(
                "Purchase History",
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                "Log out",
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut().then(
                  (value) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/loginpage', (Route<dynamic> route) => false);
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              ' Food Items',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
            ),
          ),
          buildStreamBuilder(),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              ' Clothes',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
            ),
          ),
          buildStreamClothes()
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot> buildStreamBuilder() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("products")
            .where("producttype", isEqualTo: "fooditem")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Text(
              'Scan Barcode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          return Container(
              height: 240,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot products = snapshot.data.documents[index];
                    return ItemCard(products: products);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 10);
                  }));
        });
  }

  StreamBuilder<QuerySnapshot> buildStreamClothes() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("products")
            .where("producttype", isEqualTo: "clothes")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Text(
              'Scan Barcode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          return Container(
              height: 240,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot products = snapshot.data.documents[index];
                    return ItemCard(products: products);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 10);
                  }));
        });
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.blue,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        "Scan&Pay",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/cartpage');
          },
        )
      ],
    );
  }

  Widget floatingBar() => Ink(
        decoration: ShapeDecoration(
          shape: StadiumBorder(),
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            scanBarcodeNormal();
            if (_scanBarcode != '-1' || null) {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Container(
                        height: 350,
                        child: Column(
                          children: [
                            StreamBuilder(
                                stream: Firestore.instance
                                    .collection("products")
                                    .where("barcode",
                                        isEqualTo: '$_scanBarcode')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.data == null)
                                    return Text(
                                      'Scan Barcode',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    );
                                  return Container(
                                      height: 350,
                                      width: 165,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder: (context, index) {
                                          DocumentSnapshot products =
                                              snapshot.data.documents[index];
                                          return ScanCard(products: products);
                                        },
                                      ));
                                }),
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
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

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key key,
    @required this.products,
  }) : super(key: key);

  final DocumentSnapshot products;

  @override
  Widget build(BuildContext context) {
    String _userId;

    FirebaseAuth.instance.currentUser().then((user) {
      _userId = user.uid;
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          height: 180,
          width: 160,
          decoration: BoxDecoration(
              color: Color(0xFF3D82AE),
              borderRadius: BorderRadius.circular(16)),
          child: Image.network(products['img']),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
          child: Text(
            products['name'],
            style: TextStyle(
              color: Color(0xFF535353),
            ),
          ),
        ),
        Row(
          children: [
            Text(
              "\₹ " + products['price'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 60,
            ),
            GestureDetector(
              child: Icon(
                Icons.add_shopping_cart,
                color: Colors.black,
              ),
              onTap: () {
                DocumentReference documentReference = Firestore.instance
                    .collection('userData')
                    .document(_userId)
                    .collection('cartData')
                    .document();
                documentReference
                    .setData({
                      'uid': _userId,
                      'barcode': products['barcode'],
                      'img': products['img'],
                      'name': products['name'],
                      'netweight': products['netweight'],
                      'price': products['price'],
                      'id': documentReference.documentID
                    })
                    .then((result) {})
                    .catchError((e) {
                      print(e);
                    });
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text('Added to Cart',
                  style:TextStyle(color:Colors.white,fontSize: 18),
                  textAlign: TextAlign.start, 
                  ),
                  duration: Duration(milliseconds: 300),
                  backgroundColor: Color(0xFF3D82AE),
                ));
              },
            ),
          ],
        )
      ],
    );
  }
}

class ScanCard extends StatelessWidget {
  const ScanCard({
    Key key,
    @required this.products,
  }) : super(key: key);
  final DocumentSnapshot products;

  @override
  Widget build(BuildContext context) {
    String _userId;

    FirebaseAuth.instance.currentUser().then((user) {
      _userId = user.uid;
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          height: 180,
          width: 160,
          decoration: BoxDecoration(
              color: Color(0xFF3D82AE),
              borderRadius: BorderRadius.circular(16)),
          child: Image.network(products['img']),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
          child: Text(
            products['name'],
            style: TextStyle(
              color: Color(0xFF535353),
              fontSize: 18,
            ),
          ),
        ),
        Column(
          children: [
            Text(
              "netweight- " + products['netweight'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "\₹ " + products['price'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              width: 60,
            ),
            Icon(
              Icons.add_shopping_cart,
              color: Colors.black,
              size: 27,
            ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Color(0xFF3D82AE),
              child: Text(
                "Add to cart",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                DocumentReference documentReference = Firestore.instance
                    .collection('userData')
                    .document(_userId)
                    .collection('cartData')
                    .document();
                documentReference.setData({
                  'uid': _userId,
                  'barcode': products['barcode'],
                  'img': products['img'],
                  'name': products['name'],
                  'netweight': products['netweight'],
                  'price': products['price'],
                  'id': documentReference.documentID
                }).then((result) {
                  dialogTrigger(context);
                }).catchError((e) {
                  print(e);
                });
              },
            ),
          ),
        )
      ],
    );
  }
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
