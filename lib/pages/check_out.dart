import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_management/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckOut extends StatefulWidget {
  String bookingId;
  CheckOut({Key? key, required this.bookingId}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  int total = 0;
  int balance = 0;
  int concession = 0;
  int advance = 0;
  @override
  void initState() {
    super.initState();
    getBooking();
  }

  getBooking() async {
    DocumentSnapshot snapshot =
        await Db(id: FirebaseAuth.instance.currentUser!.uid)
            .getBookingInfo(widget.bookingId);
    setState(() {
      total = snapshot['total'];
      advance = snapshot['advance'];
      concession = snapshot['concession'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
