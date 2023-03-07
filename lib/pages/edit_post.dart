import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../services/db.dart';
import '../utils/decor.dart';
import '../widgets/snack_bar.dart';

class Edit_post extends StatefulWidget {
  String postId;
  Edit_post({Key? key, required this.postId}) : super(key: key);

  @override
  State<Edit_post> createState() => _Edit_postState();
}

class _Edit_postState extends State<Edit_post> {
  File? image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  TextEditingController descCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              //DESCRIPTION
              Text(
                'Description',
                style: TextStyle(
                  color: Decor.prime,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextFormField(
                onChanged: (value) {},
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter description here...',
                ),
                maxLines: 4,
                controller: descCtrl,
              ),
              SizedBox(height: 15),
              InkWell(
                onTap: () {
                  uploadImage();
                },
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black26)),
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
                                'Select Image',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //uploadPost();
        },
        label: Text(
          'Save',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }

  uploadImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  uploadPost() async {}
}
