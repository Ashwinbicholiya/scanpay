import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail/screens/Cart.dart';
import 'package:retail/check.dart';
import 'package:retail/screens/PurchaseHistory.dart';
import 'package:retail/screens/signup.dart';
import 'package:retail/screens/splashscreen.dart';
import 'package:retail/services/theme.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeNotifier()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routes = <String, WidgetBuilder>{
    '/check': (BuildContext context) => new Check(),
    '/homepage': (BuildContext context) => new HomePage(),
    '/loginpage': (BuildContext context) => new LoginPage(),
    '/signup': (BuildContext context) => new Signup(),
    '/cartpage': (BuildContext context) => new Cart(),
    '/purchasehistory': (BuildContext context) => new PurchaseHistory(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RetailApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: HomePage(),
      routes: routes,
    );
  }
}
