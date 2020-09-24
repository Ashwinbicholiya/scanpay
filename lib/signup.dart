import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retail/home_page.dart';
import 'package:retail/services/AuthUtil.dart';

import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth mAuth = FirebaseAuth.instance;

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPassController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(height: 75),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 110.0,
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Color(0xFF455A64),
                      ),
                      labelText: "Username",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      errorStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Username",
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF455A64), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF455A64), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter a valid username";
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xFF455A64),
                      ),
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      errorStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Email",
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF455A64), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF455A64), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value.isNotEmpty && value.contains("@")) {
                        var splitEmail = value.split("@");
                        print("split length is ${splitEmail.length}");
                        if (splitEmail.length == 2) {
                          var firstHalf = splitEmail[0];
                          var secondHalf = splitEmail[1];

                          print(
                              "first half is $firstHalf with length of ${firstHalf.length}");
                          print(
                              "second half is $secondHalf with length of ${secondHalf.length}");

                          var secondHalfSplit = secondHalf.split(".");
                          print(
                              "second half split lenght is ${secondHalfSplit.length}");
                          print("second half 1 is [${secondHalfSplit[0]}] ");

                          if (!secondHalf.contains(".") ||
                              secondHalf.length < 3 ||
                              secondHalfSplit.length != 2 ||
                              secondHalfSplit[0].isEmpty ||
                              secondHalfSplit[1].isEmpty) {
                            return "Please enter a valid email";
                          }

                          if (firstHalf.length < 3) {
                            return "Please enter a valid email";
                          }
                        } else {
                          return "Please enter a valid email";
                        }
                      }

                      if (value.isEmpty ||
                          !value.contains("@") ||
                          !value.contains(".") ||
                          value.length < 6) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.vpn_key,
                        color: Color(0xFF455A64),
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      errorStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Password",
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF455A64), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF455A64), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: confirmPassController,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.vpn_key,
                        color: Color(0xFF455A64),
                      ),
                      labelText: "Confirm Password",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      errorStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Confirm Password",
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF455A64), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF455A64), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return 'Please enter an email';
                      }
                      if (value != passwordController.text) {
                        return 'Please enter the same password';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.lightBlueAccent,
                      child: Text(
                        "Sign up",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
//                      Scaffold.of(context)
//                          .showSnackBar(SnackBar(content: Text('Processing Data')));
                          AuthUtil.registerUser(
                                  emailController.text, passwordController.text)
                              .then((result) {
                            Firestore.instance
                                .collection('users')
                                .document(result.user.uid)
                                .setData({
                              'username': usernameController.text,
                              'email': emailController.text,
                              "uid": result.user.uid
                            }).then((success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                            });
                          }).catchError((error) {
                            var e = error;
                            var authError = "";
                            print("caught error ${e.code}");
                            switch (e.code) {
                              case 'ERROR_INVALID_EMAIL':
                                authError = 'Invalid Email';
                                break;
                              case 'ERROR_USER_NOT_FOUND':
                                authError = 'User Not Found';
                                break;
                              case 'ERROR_WRONG_PASSWORD':
                                authError = 'Wrong Password';
                                break;
                              case 'ERROR_EMAIL_ALREADY_IN_USE':
                                authError =
                                    "You have an account already, please sign in";
                                break;
                              default:
                                authError = 'Error';
                                break;
                            }
                            _showErrorDataDialog(context, authError);

                            print('The error is $authError');
                          });
                        } else {
                          print("check errors");
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future _showErrorDataDialog(context, String error) async {
  var matDialog = AlertDialog(
    title: new Text("Error"),
    content: new Text(error),
    actions: <Widget>[
      new FlatButton(
        child: new Text("Ok"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );

  var cupDialog = CupertinoAlertDialog(
    title: new Text("Error"),
    content: new Text(error),
    actions: <Widget>[
      new FlatButton(
        child: new Text("Ok"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );

  Widget dialog = matDialog;

  if (Platform.isIOS) {
    dialog = cupDialog;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}
