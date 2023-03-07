import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_management/services/db.dart';
import 'package:event_management/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/decor.dart';

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  String name = '';
  String address = '';
  File? image;
  String imgUrl = '';
  bool isLoading = false;
  final picker = ImagePicker();
  TextEditingController descCtrl = TextEditingController();
  fstorage.FirebaseStorage storage = fstorage.FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    DocumentSnapshot snapshot =
        await Db(id: FirebaseAuth.instance.currentUser!.uid).getData();
    setState(() {
      name = snapshot['name'];
      address = '${snapshot['address']} - ${snapshot['city']}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.back),
          color: Colors.white,
        ),
        title: Text(
          "What's in Your Mind?",
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
              TextField(
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
                                'Image',
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
          if (descCtrl.text.isEmpty && imgUrl.isEmpty) {
            showSnackbar(
                context, Colors.red, "Sorry! Fields are empty. Couldn't Save");
          } else {
            uploadPost();
            setState(() {
              isLoading = true;
            });
          }
        },
        label: Text(
          isLoading ? 'Saving... Please Wait' : 'Save',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          isLoading ? null : Icons.save,
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

  uploadPost() async {
    if (image != null) {
      fstorage.Reference reference = storage.ref(
          '/posts/' + "${DateTime.now().millisecondsSinceEpoch.toString()}");
      fstorage.UploadTask uploadTask = reference.putFile(image!.absolute);
      fstorage.TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      await snapshot.ref.getDownloadURL().then((url) {
        setState(() {
          imgUrl = url;
        });
      });
    }

    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .uploadPost(DateTime.now().millisecondsSinceEpoch.toString(), name,
            address, imgUrl, descCtrl.text)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
      showSnackbar(context, Colors.green, "Your post has been uploaded");
      Navigator.pop(context);
    });
  }
}
