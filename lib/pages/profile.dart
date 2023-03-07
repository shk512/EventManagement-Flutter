import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_management/services/auth.dart';
import 'package:event_management/services/db.dart';
import 'package:event_management/services/spf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:event_management/widgets/snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/city_list.dart';
import '../utils/decor.dart';
import '../utils/routes.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  TextEditingController passCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  String newPass = '';
  String name = '';
  String phone = '';
  String country_code = '+92';
  String pass = '';
  String mail = '';
  String address = '';
  String city = '';
  String imageUrl = '';
  File? image;
  final picker = ImagePicker();
  Auth auth = Auth();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final formKey = GlobalKey<FormState>();

  //CITIES LIST
  List<DropdownMenuItem<cityList>> _dropdownMenuItem = [];
  late cityList _itemSelected;
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
  void initState() {
    super.initState();
    getUserData();
    _dropdownMenuItem = buildDropDownItems(dropDownItems);
    _itemSelected = _dropdownMenuItem[0].value!;
  }

  getUserData() async {
    DocumentSnapshot? snapshot;
    snapshot = await Db(id: FirebaseAuth.instance.currentUser!.uid).getData();
    setState(() {
      name = snapshot!['name'];
      phone = snapshot['phone'];
      city = snapshot['city'];
      address = snapshot['address'];
      mail = snapshot['email'];
      imageUrl = snapshot['dp'];
    });
    await SPF.getPass().then((value) {
      setState(() {
        pass = value!.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading || name.isEmpty
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        uploadImage();
                      },
                      child: CircleAvatar(
                        radius: 100,
                        child: imageUrl.isNotEmpty
                            ? Image.network(imageUrl)
                            : Icon(
                                Icons.person,
                                size: 60,
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 40),

                    //MAIL
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.mail_outline_rounded),
                            SizedBox(width: 15),
                            Text(
                              mail,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 20),

                    //NAME
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.warehouse_outlined),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                name,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Edit'),
                                          content: TextField(
                                            controller: nameCtrl,
                                            decoration: InputDecoration(
                                              hintText: "Edit Name",
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Text('Cancel')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  if (nameCtrl
                                                      .text.isNotEmpty) {
                                                    name = nameCtrl.text;
                                                    update();
                                                    Navigator.pop(context);
                                                  } else {
                                                    showSnackbar(context,
                                                        Colors.red, "Invalid");
                                                  }
                                                },
                                                child: Text('Done')),
                                          ],
                                        );
                                      });
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Decor.color,
                                )),
                          ],
                        )),
                    SizedBox(height: 20),

                    //Phone
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.phone),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                phone,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Edit'),
                                          content: TextField(
                                            controller: phoneCtrl,
                                            decoration: InputDecoration(
                                              hintText: "3xxxxxxxxx",
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Text('Cancel')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  if (phoneCtrl.text.length ==
                                                      10) {
                                                    phone = country_code +
                                                        phoneCtrl.text;
                                                    update();
                                                    Navigator.pop(context);
                                                  } else {
                                                    showSnackbar(context,
                                                        Colors.red, "Invalid");
                                                  }
                                                },
                                                child: Text('Done')),
                                          ],
                                        );
                                      });
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Decor.color,
                                )),
                          ],
                        )),
                    SizedBox(height: 20),

                    //City
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.location_city),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                city,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Edit'),
                                          content: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              hint: Text(
                                                "Select the City",
                                              ),
                                              value: _itemSelected,
                                              icon: Icon(
                                                  Icons.keyboard_arrow_down),
                                              onChanged: (value) {
                                                setState(() {
                                                  _itemSelected = value!;
                                                });
                                              },
                                              items: _dropdownMenuItem,
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Text('Cancel')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  if (_itemSelected.name !=
                                                      'Select the City') {
                                                    city = _itemSelected.name;
                                                    update();
                                                    Navigator.pop(context);
                                                  } else {
                                                    showSnackbar(context,
                                                        Colors.red, "Invalid");
                                                  }
                                                },
                                                child: Text('Done')),
                                          ],
                                        );
                                      });
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Decor.color,
                                )),
                          ],
                        )),
                    SizedBox(height: 20),

                    //Address
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.location_pin),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                address,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Edit'),
                                          content: TextField(
                                            controller: addressCtrl,
                                            decoration: InputDecoration(
                                              hintText: "Edit Address",
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Text('Cancel')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  if (addressCtrl
                                                      .text.isNotEmpty) {
                                                    address = addressCtrl.text;
                                                    update();
                                                    Navigator.pop(context);
                                                  } else {
                                                    showSnackbar(context,
                                                        Colors.red, "Invalid");
                                                  }
                                                },
                                                child: Text('Done')),
                                          ],
                                        );
                                      });
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Decor.color,
                                )),
                          ],
                        )),
                    SizedBox(height: 20),

                    //PASSWORD
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.lock_outline),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                'Password*******',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Edit'),
                                          content: Container(
                                            height: 250,
                                            child: Form(
                                              key: formKey,
                                              child: Column(
                                                children: [
                                                  //CURRENT PASSWORD
                                                  TextFormField(
                                                    obscureText: true,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Enter Your Current Password',
                                                      label: Text(
                                                          'Current Password'),
                                                    ),
                                                    validator: (val) {
                                                      if (val == pass) {
                                                        return null;
                                                      } else {
                                                        return "Current Password doesn't match";
                                                      }
                                                    },
                                                  ),
                                                  //NEW PASSWORD
                                                  TextFormField(
                                                    obscureText: true,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Choose a Strong Password',
                                                      label:
                                                          Text('New Password'),
                                                    ),
                                                    onChanged: (val) {
                                                      newPass = val;
                                                    },
                                                    validator: (val) {
                                                      if (val!.length >= 6) {
                                                        return null;
                                                      } else {
                                                        return "Invalid";
                                                      }
                                                    },
                                                  ),
                                                  //CONFIRM NEW PASSWORD
                                                  TextFormField(
                                                    obscureText: true,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Retype Your Password',
                                                      label: Text(
                                                          'Confirm Password'),
                                                    ),
                                                    validator: (val) {
                                                      if (val == newPass) {
                                                        return null;
                                                      } else {
                                                        return "Password doesn't match";
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Text('Cancel')),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    await updatePass();
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: Text('Done')),
                                          ],
                                        );
                                      });
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Decor.color,
                                )),
                          ],
                        )),
                    SizedBox(height: 40),

                    //DELETE BUTTON
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: const Text(
                                    "Are you sure your want to delete your account?"),
                                title: const Text("Delete Account"),
                                actions: [
                                  //CANCEL
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                  //DONE
                                  IconButton(
                                    onPressed: () {
                                      delete();
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Container(
                        width: 150,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Delete Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              letterSpacing: 1,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  delete() {
    setState(() {
      isLoading = true;
    });
    auth.deleteUser().then((value) {
      if (value == true) {
        SPF.savePhone('');
        SPF.saveUserName('');
        SPF.saveUserLogInStatus(false);
        SPF.savePass('');
        showSnackbar(context, Colors.green, "Successfully Deleted");
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.login, (route) => false);
      } else {
        showSnackbar(context, Colors.red, value.toString());
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  update() async {
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .updateData(
      mail,
      phone,
      name,
      city,
      address,
      imageUrl,
    )
        .then((value) {
      if (value == true) {
        setState(() {});
        showSnackbar(context, Colors.green, "Updated");
      } else {
        showSnackbar(context, Colors.red, value.toString());
      }
    });
  }

  updatePass() async {
    await auth.updateNewPass(newPass).then((value) async {
      if (value == true) {
        await SPF.savePass(newPass);
        showSnackbar(context, Colors.green, "Updated");
        setState(() {});
      } else {
        showSnackbar(context, Colors.red, value.toString());
      }
    });
  }

  uploadImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
    var reference = storage
        .ref('/dp/' + "${DateTime.now().millisecondsSinceEpoch.toString()}");
    var uploadTask = reference.putFile(image!.absolute);
    await Future.value(uploadTask);
    var newUrl = reference.getDownloadURL();
    imageUrl = newUrl.toString();
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .updateData(mail, phone, name, city, address, imageUrl)
        .then((value) {
      if (value != null) {
        setState(() {
          isLoading = false;
        });
      } else {
        showSnackbar(context, Colors.red, value.toString());
      }
    });
  }
}
