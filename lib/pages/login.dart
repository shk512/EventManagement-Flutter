import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:event_management/services/db.dart';
import 'package:event_management/services/spf.dart';
import 'package:event_management/utils/decor.dart';
import 'package:event_management/utils/routes.dart';
import 'package:event_management/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';
import '../utils/signature.dart';
import '../utils/styles.dart';
import '../utils/loading.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Auth auth = Auth();
  bool _hide = true;
  bool isLoading = false;
  String mail = '';
  String pass = '';
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 100),
                  Text(
                    'Loading',
                    style: TextStyle(
                        color: Decor.lightBlack, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Please Wait...',
                    style: TextStyle(
                        color: Decor.lightBlack, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/logo.png",
                    height: 200,
                    width: 600,
                  ),
                  const Text(
                    'Login Form',
                    style: Styles.heading,
                  ),
                  Decor.divider,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 30),
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          //Phone/EMAIL
                          Row(
                            children: [
                              const Icon(
                                Icons.mail,
                                color: Decor.color,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: Decor.border.copyWith(
                                    labelText: 'Email',
                                    hintText: 'Enter your mail',
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      mail = val;
                                    });
                                  },
                                  validator: (val) {
                                    if (EmailValidator.validate(val!)) {
                                      return null;
                                    } else {
                                      return "Invalid";
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          Decor.height,
                          //PASSWORD
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.lock, color: Decor.color),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  obscureText: _hide,
                                  decoration: Decor.border.copyWith(
                                    labelText: 'Password',
                                    hintText: 'Enter Your Password',
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      pass = val;
                                    });
                                  },
                                  validator: (val) {
                                    if (val!.length >= 6) {
                                      return null;
                                    } else {
                                      return 'Invalid';
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _hide = !_hide;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.remove_red_eye,
                                      color: _hide == true
                                          ? Colors.black54
                                          : Decor.prime,
                                    ),
                                    Text(
                                      _hide == true
                                          ? 'Show Password'
                                          : 'Hide Password',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Decor.height,
                          Decor.height,
                          //LOGIN
                          ElevatedButton(
                              onPressed: () {
                                login();
                              },
                              child: const Text('Login')),
                          Decor.height,
                          //SIGNUP
                          Text.rich(
                            TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(
                                color: Decor.prime,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Register here",
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, Routes.signup);
                                      })
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //DEVELOPED BY
                  Signature,
                ],
              ),
            ),
    );
  }

  login() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await auth.signInWithEmailAndPassword(mail, pass).then((value) async {
        print(value.toString());
        if (value == true) {
          DocumentSnapshot snapshot =
              await Db(id: FirebaseAuth.instance.currentUser!.uid).getData();

          //saving data in shared preferences
          await SPF.savePhone(snapshot['phone']);
          await SPF.saveUserLogInStatus(true);
          await SPF.saveUserName(snapshot['name']);
          await SPF.savePass(pass);

          Navigator.pushNamedAndRemoveUntil(
              context, Routes.bottomBar, (route) => false);
          showSnackbar(context, Colors.green, 'Login Successfully');
        } else {
          showSnackbar(context, Colors.red, value.toString());
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }
}
