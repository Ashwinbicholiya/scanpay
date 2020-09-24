import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  Cart({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _Cart createState() => _Cart();
}

class _Cart extends State<Cart> {
  FirebaseUser user;

  Future<void> getUserData() async {
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
      print(userData.uid);
    });
  }

  Future gettotalId() async {
    QuerySnapshot qn = await Firestore.instance
        .collection('userData')
        .document('${user.uid}')
        .collection('cartData')
        .getDocuments();
    return qn.documents.length.toString();
  }

  Future gettotal() async {
    double total = 0.0;
    QuerySnapshot qn = await Firestore.instance
        .collection('userData')
        .document('${user.uid}')
        .collection('cartData')
        .getDocuments();
    for (int i = 0; i < qn.documents.length; i++) {
       total = total + int.parse(qn.documents[i]['price']);
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    gettotalId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              StreamBuilder(
                  stream: Firestore.instance
                      .collection("userData")
                      .document('${user.uid}')
                      .collection('cartData')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null)
                      return Text(
                        '                    No Items In The Cart',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      );
                    return Container(
                        height: 510,
                        width: 400,
                        child: ListView.separated(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot products =
                                  snapshot.data.documents[index];
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Container(
                                        padding: EdgeInsets.all(1.0),
                                        height: 80,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Color(0xFF3D82AE),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Image.network(products['img']),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0 / 4),
                                    child: Text(
                                      products['name'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "\₹ " + products['price'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      GestureDetector(
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            gettotalId();
                                          });

                                          Firestore.instance
                                              .collection("userData")
                                              .document('${user.uid}')
                                              .collection('cartData')
                                              .document(products['id'])
                                              .delete()
                                              .then((result) {})
                                              .catchError((e) {
                                            print(e);
                                          });
                                          Scaffold.of(context)
                                              .showSnackBar(new SnackBar(
                                            content: new Text(
                                              'Deleted',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                              textAlign: TextAlign.start,
                                            ),
                                            duration:
                                                Duration(milliseconds: 300),
                                            backgroundColor: Color(0xFF3D82AE),
                                          ));
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(height: 20);
                            }));
                  }),
            ],
          ),
        ),
        bottomNavigationBar: FutureBuilder(
            future: gettotalId(),
            builder: (context, snapshot) {
              return Container(
                margin: EdgeInsets.only(left: 35, bottom: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FutureBuilder(
                              future: gettotal(),
                              builder: (context, price) {
                                return Text(
                                  "Total:                   " + '${price.data}',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300),
                                );
                              }),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey[700],
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Row(
                        children: <Widget>[
                          Text("Quantity",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              )),
                          SizedBox(
                            width: 200,
                          ),
                          Text(
                              snapshot.data != null ? snapshot.data : 'Loading',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              )),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(right: 25),
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                            color: Colors.blue[600],
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: <Widget>[
                            Center(
                              child: Text(
                                "   Next",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              );
            }));
  }
}

AppBar buildAppBar() {
  return AppBar(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.blue,
    iconTheme: IconThemeData(color: Colors.black),
    title: Text(
      "My Orders",
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
  );
}
