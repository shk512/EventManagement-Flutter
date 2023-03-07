import 'dart:core';
import 'package:email_validator/email_validator.dart';
import 'package:event_management/services/db.dart';
import 'package:event_management/services/auth.dart';
import 'package:event_management/services/spf.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../utils/city_list.dart';
import '../utils/decor.dart';
import '../utils/routes.dart';
import '../utils/signature.dart';
import '../utils/styles.dart';
import '../widgets/snack_bar.dart';
import '../utils/loading.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _hide = true;
  bool _chide = true;
  bool check = false;
  bool isLoading = false;
  String country_code = '+92';
  String phone = '';
  String mail = '';
  String cpass = '';
  String pass = '';
  String name = '';
  String imageUrl = '';
  String city = 'Select the City';
  String address = '';
  final formkey = GlobalKey<FormState>();
  Auth auth = Auth();
  List<DropdownMenuItem<cityList>> _dropdownMenuItem = [];
  late cityList _itemSelected;

  @override
  void initState() {
    super.initState();
    _dropdownMenuItem = buildDropDownItems(dropDownItems);
    _itemSelected = _dropdownMenuItem[0].value!;
  }

  List<DropdownMenuItem<cityList>> buildDropDownItems(List list) {
    List<DropdownMenuItem<cityList>> items = [];
    for (cityList item in list) {
      items.add(DropdownMenuItem(
        child: Text(item.name),
        value: item,
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? loading
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Registration Form',
                    style: Styles.heading,
                  ),
                  const SizedBox(
                    width: 280,
                    height: 10,
                    child: Divider(
                      thickness: 2.0,
                      color: Colors.black87,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 20),
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          //EMAIL
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
                                    hintText: 'example@example.com',
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

                          //Phone
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Decor.color,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                '+92',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  decoration: Decor.border.copyWith(
                                    labelText: 'Phone',
                                    hintText: '3xxxxxxxxx',
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      phone = val;
                                    });
                                  },
                                  validator: (val) {
                                    if (val?.length == 10) {
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

                          //PALACE NAME
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.warehouse_outlined,
                                  color: Decor.color),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: Decor.border.copyWith(
                                    labelText: 'Palace',
                                    hintText: 'Enter Name',
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      name = val;
                                    });
                                  },
                                  validator: (val) {
                                    if (name.isNotEmpty) {
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

                          //Complete Address
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_pin,
                                  color: Decor.color),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: Decor.border.copyWith(
                                    labelText: 'Search Address',
                                    hintText: 'Your location',
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      address = val;
                                    });
                                  },
                                  validator: (val) {
                                    if (name.isNotEmpty) {
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

                          //City
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_city,
                                  color: Decor.color),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    hint: Text(
                                      "Select the City",
                                    ),
                                    value: _itemSelected,
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    onChanged: (value) {
                                      setState(() {
                                        _itemSelected = value!;
                                        city = _itemSelected.name;
                                      });
                                    },
                                    items: _dropdownMenuItem,
                                  ),
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
                                    hintText: 'Min six characters',
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

                          //CONFIRM PASSWORD
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
                                  obscureText: _chide,
                                  decoration: Decor.border.copyWith(
                                    labelText: 'Confirm Password',
                                    hintText: 'Retype Your Password',
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      cpass = val;
                                    });
                                  },
                                  validator: (val) {
                                    if (cpass == pass) {
                                      return null;
                                    } else {
                                      return "Password doesn't match";
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
                                    _chide = !_chide;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.remove_red_eye,
                                      color: _chide == true
                                          ? Colors.black54
                                          : Decor.prime,
                                    ),
                                    Text(
                                      _chide == true
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

                          //Register
                          ElevatedButton(
                              onPressed: () {
                                signup();
                              },
                              child: const Text('Register')),
                          Decor.height,

                          //LOGIN
                          Text.rich(
                            TextSpan(
                              text: "Already have an account? ",
                              style: const TextStyle(
                                color: Decor.prime,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Login",
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, Routes.login);
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

  signup() async {
    if (formkey.currentState!.validate()) {
      phone = country_code + phone;
      setState(() {
        isLoading = true;
      });
      auth.createUser(mail, pass).then((value) async {
        if (value != null) {
          await Db(id: value.toString())
              .saveData(mail, phone, name, city, address, imageUrl);
          await SPF.saveUserLogInStatus(true);
          await SPF.saveUserName(name);
          await SPF.savePhone(phone);
          await SPF.savePass(pass);
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.bottomBar, (route) => false);
          showSnackbar(context, Colors.green, "Registered Successfully");
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
