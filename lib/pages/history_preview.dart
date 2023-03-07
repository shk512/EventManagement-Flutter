import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/db.dart';
import '../utils/decor.dart';

class HistoryPreview extends StatefulWidget {
  final String bookingId;
  const HistoryPreview({Key? key, required this.bookingId}) : super(key: key);

  @override
  State<HistoryPreview> createState() => _HistoryPreviewState();
}

class _HistoryPreviewState extends State<HistoryPreview> {
  String name = '';
  String contact = '';
  String contact2 = '';
  String time = '';
  String hall = '';
  String date = '';
  String decor = '';
  String decorAmount = '';
  String type = '';
  String extraInfo = '';
  String menu = '';
  String advance = '';
  String totalPersons = '';
  String rate = '';
  String details = '';
  String extraAmount = '';
  String totalAmount = '';
  String balanceAmount = '';
  String concessionAmount = '';
  String receiveAmount = '';

  @override
  void initState() {
    getFunctionDetails();
    super.initState();
  }

  getFunctionDetails() async {
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .getHistoryInfo(widget.bookingId)
        .then((val) {
      setState(() {
        name = val['name'];
        contact = val['contact'];
        contact2 = val['contact2'];
        time = val['time'];
        type = val['type'];
        decor = val['decoration'];
        decorAmount = val['decorAmount'].toString();
        date = val['date'];
        hall = val['hallName'];
        totalPersons = val['totalPersons'].toString();
        advance = val['advance'].toString();
        extraInfo = val['extraInfo'];
        menu = val['menu'];
        rate = val['rate'];
        concessionAmount = val["concessionAmount"];
        balanceAmount = val["balanceAmount"];
        totalAmount = val["totalAmount"];
        extraAmount = val['extraAmount'];
        receiveAmount = val['receiveAmount'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back),
          color: Colors.white,
        ),
        title: Text(widget.bookingId.toUpperCase()),
      ),
      body: name == ''
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //DATE
                    Row(
                      children: [
                        const Text(
                          'Date: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Decor.prime,
                          ),
                        ),
                        Text(
                          date,
                          style: const TextStyle(
                            color: Decor.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //HALL
                    Row(
                      children: [
                        const Text(
                          'Hall: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Decor.prime,
                          ),
                        ),
                        Text(
                          hall.toUpperCase(),
                          style: const TextStyle(
                            color: Decor.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //NAME
                    Row(
                      children: [
                        const Text(
                          'Name: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Decor.prime,
                          ),
                        ),
                        Text(
                          name.toUpperCase(),
                          style: const TextStyle(
                            color: Decor.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //CONTACT
                    Row(
                      children: [
                        const Text(
                          'Contact: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Decor.prime,
                          ),
                        ),
                        Text(
                          contact2 != '' ? "$contact, $contact2" : "$contact",
                          style: const TextStyle(
                            color: Decor.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //TIME
                    Row(
                      children: [
                        const Text(
                          'Time: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Decor.prime,
                          ),
                        ),
                        Text(
                          time.toUpperCase(),
                          style: const TextStyle(
                            color: Decor.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //TYPE
                    Row(
                      children: [
                        Text(
                          type.toLowerCase() == 'perhead'
                              ? "Per-Head: "
                              : 'Lumpsum: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Decor.prime,
                          ),
                        ),
                        Text(
                          rate,
                          style: const TextStyle(
                            color: Decor.color,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    //TOTAL PERSONS
                    Row(
                      children: [
                        const Text(
                          'Person: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Decor.prime,
                          ),
                        ),
                        Text(
                          totalPersons,
                          style: const TextStyle(
                            color: Decor.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    SizedBox(height: type.toLowerCase() == 'perhead' ? 10 : 0),

                    //MENU
                    type.toLowerCase() == 'perhead'
                        ? const Text(
                            'Menu',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Decor.prime,
                            ),
                          )
                        : Container(),
                    type.toLowerCase() == 'perhead'
                        ? Text(
                            menu,
                            style: const TextStyle(
                              color: Decor.color,
                            ),
                          )
                        : Container(),
                    SizedBox(height: decor != '' ? 10 : 0),

                    //DECOR
                    decor != ''
                        ? const Text(
                            'Decor:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Decor.prime,
                              letterSpacing: 2,
                            ),
                          )
                        : Container(),
                    decor != ''
                        ? Text(
                            decor,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Decor.color,
                              letterSpacing: 2,
                            ),
                          )
                        : Container(),
                    SizedBox(height: decorAmount != '0' ? 10 : 0),
                    decorAmount != '0'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Decor Amount:',
                                style: TextStyle(
                                    color: Decor.prime,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                decorAmount,
                                style: const TextStyle(
                                    color: Decor.color,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 10),

                    //EXTRA INFO
                    extraInfo != ''
                        ? const Text(
                            'Extra Info',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Decor.prime,
                              letterSpacing: 2,
                            ),
                          )
                        : Container(),
                    extraInfo != ''
                        ? Text(
                            extraInfo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Decor.color,
                              letterSpacing: 2,
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 10),
                    details != ''
                        ? const Text(
                            'Utils or Services:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Decor.prime,
                              letterSpacing: 2,
                            ),
                          )
                        : Container(),
                    details != ''
                        ? Text(
                            details,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Decor.color,
                              letterSpacing: 2,
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 10),
                    extraAmount != ''
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Utils or Service Charges:',
                                style: TextStyle(
                                    color: Decor.prime,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                extraAmount,
                                style: const TextStyle(
                                    color: Decor.color,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount:',
                          style: TextStyle(
                              color: Decor.prime, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          totalAmount,
                          style: const TextStyle(
                              color: Decor.color, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Advance:',
                          style: TextStyle(
                              color: Decor.prime, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          advance,
                          style: const TextStyle(
                              color: Decor.color, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Concession:',
                          style: TextStyle(
                              color: Decor.prime, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          concessionAmount,
                          style: const TextStyle(
                              color: Decor.color, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Receive Amount:',
                          style: TextStyle(
                              color: Decor.prime, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          receiveAmount,
                          style: const TextStyle(
                              color: Decor.color, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Balance:',
                          style: TextStyle(
                              color: Decor.prime, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          balanceAmount,
                          style: const TextStyle(
                              color: Decor.color, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
