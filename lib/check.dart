import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retail/home_page.dart';
import 'package:retail/login_page.dart';

class Check extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
            future: FirebaseAuth.instance.currentUser(),
            builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
                       if (snapshot.hasData){
                           // ignore: unused_local_variable
                           FirebaseUser user = snapshot.data; // this is your user instance
                           /// is because there is user already logged
                           return HomePage();
                        }
                         /// other way there is no user logged.
                         return LoginPage();
             }
          );
  }
}