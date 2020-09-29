import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PurchaseHistory extends StatefulWidget {
  @override
  _PurchaseHistoryState createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  FirebaseUser user;

  Future<void> getUserData() async {
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
      print(userData.uid);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 30,),
              StreamBuilder(
                  stream: Firestore.instance
                      .collection("userOrders")
                      .document('${user.uid}')
                      .collection('orders')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null)
                      return Text(
                        '                    No Items In The Orders',
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
                                    width: 30,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "\₹ " + products['price'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
        ));
  }
}

AppBar buildAppBar() {
  return AppBar(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.blue,
    iconTheme: IconThemeData(color: Colors.black),
    title: Text(
      "Purchase History",
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
  );
}
