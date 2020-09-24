import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retail/add_pro/add_product.dart';
import 'package:retail/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retail/services/AuthUtil.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();
    String _warning;

    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 160),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 135.0,
                    child: Image.asset('assets/logo.png'),
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
                      errorStyle: TextStyle(color: Colors.blueGrey[700]),
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
                      errorStyle: TextStyle(color: Colors.blueGrey[700]),
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
                      if (value.isEmpty || value.length < 6) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.lightBlueAccent,
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          AuthUtil.signInUser(
                                  emailController.text, passwordController.text)
                              .then((AuthResult authResult) {
                            print("authResult is ${authResult.user.email}");
                            Navigator.pop(context);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/homepage', (Route<dynamic> route) => false);
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
                ),
                FlatButton(
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.black54),
                    textAlign: TextAlign.left,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0)), //this right here
                            child: Container(
                              height: 160,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
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
                                        errorStyle: TextStyle(
                                            color: Colors.blueGrey[700]),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: "Email",
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFF455A64),
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFF455A64),
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 320.0,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0)),
                                        onPressed: () {
                                          try {
                                            AuthUtil.resetpassword(
                                                emailController.text);
                                            print("Password reset email sent");
                                            _warning =
                                                "A password reset link has been sent! Check Your Email";
                                            _showforgotpass(context, _warning);
                                          } catch (e) {
                                            print(e);
                                            setState(() {
                                              _warning = e.message;
                                              _showforgotpass(
                                                  context, _warning);
                                            });
                                          }
                                        },
                                        child: Text(
                                          "Send",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.lightBlueAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
                FlatButton(
                  child: Text(
                    'Sign up',
                    style: TextStyle(color: Colors.black54),
                    textAlign: TextAlign.right,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                ),
                 FlatButton(
                  child: Text(
                    'Add Product',
                    style: TextStyle(color: Colors.black54),
                    textAlign: TextAlign.right,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddProduct()));
                  },
                ),
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

Future _showforgotpass(context, String error) async {
  var matreset = AlertDialog(
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

  var cupreset = CupertinoAlertDialog(
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

  Widget dialog = matreset;

  if (Platform.isIOS) {
    dialog = cupreset;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}
