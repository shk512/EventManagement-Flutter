import 'dart:io';
import 'package:event_management/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/decor.dart';
import '../widgets/snack_bar.dart';

class Add_Hall extends StatefulWidget {
  const Add_Hall({Key? key}) : super(key: key);

  @override
  State<Add_Hall> createState() => _Add_HallState();
}

class _Add_HallState extends State<Add_Hall> {
  TextEditingController hall_name = TextEditingController();
  TextEditingController floor = TextEditingController();
  TextEditingController sitting_capacity = TextEditingController();
  String imageUrl = '';
  bool isLoading = false;
  File? image;
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Add Hall',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    //Hall Name
                    TextFormField(
                      controller: hall_name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Hall Name',
                      ),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return '*Required';
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    //Floor
                    TextFormField(
                      controller: floor,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Floor',
                          hintText: 'Ground, 1st, 2nd etc..'),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return '*Required';
                        }
                      },
                    ),

                    SizedBox(height: 20),
                    //Sitting Capacity
                    TextFormField(
                      controller: sitting_capacity,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Sitting Capacity',
                          hintText: 'No.of Sittings e.g. 300'),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return '*Required';
                        }
                      },
                    ),
                    SizedBox(height: 20),

                    //IMAGE
                    InkWell(
                      onTap: () {
                        //uploadImage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26)),
                        alignment: Alignment.center,
                        height: 300,
                        child: image != null
                            ? Image.file(image!.absolute)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Icon(
                                      Icons.image,
                                      size: 40,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Select Image (Optional)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ]),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          saveHall();
                        },
                        child: isLoading ? Icon(Icons.done) : Text('Save'))
                  ],
                ),
              ),
            ),
          );
  }

  saveHall() async {
    if (formkey.currentState!.validate()) {
      String hallId = DateTime.now().millisecondsSinceEpoch.toString();
      await Db(id: FirebaseAuth.instance.currentUser!.uid)
          .saveHall(hall_name.text, floor.text, sitting_capacity.text, imageUrl,
              hallId)
          .then((value) {
        if (value == true) {
          setState(() {
            isLoading = false;
          });
          showSnackbar(context, Colors.green, "Saved Successfully");
          hall_name.text = '';
          floor.text = '';
          sitting_capacity.text = '';
          Navigator.pop(context);
        } else {
          showSnackbar(context, Colors.red, "Not saved. Try Again");
        }
      });
    }
  }
}
