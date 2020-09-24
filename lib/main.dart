import 'package:flutter/material.dart';
import 'package:retail/Cart.dart';
import 'package:retail/check.dart';
import 'package:retail/signup.dart';
import 'package:retail/splashscreen.dart';
import 'login_page.dart';
import 'home_page.dart';
void main() => runApp(
      MyApp(),
    );

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
      home: SplashScreen(),
      routes: routes,
    );
  }
}
