import 'package:event_management/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/decor.dart';
import '../utils/routes.dart';

class FunctionDetails extends StatefulWidget {
  final String bookingId;
  const FunctionDetails({Key? key, required this.bookingId}) : super(key: key);

  @override
  State<FunctionDetails> createState() => _FunctionDetailsState();
}

class _FunctionDetailsState extends State<FunctionDetails> {
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
  String receiveAmount = '0';
  bool isTotal = false;
  bool isDone = false;

  @override
  void initState() {
    getFunctionDetails();
    super.initState();
  }

  getFunctionDetails() async {
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .getBookingInfo(widget.bookingId)
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: isTotal ? checkOutWidget() : detailsWidget(),
        ),
      ),
    );
  }

  saveHistory() async {
    Map<String, dynamic> bookingMap = {
      "date": date,
      "bookingId": widget.bookingId,
      "hallName": hall,
      "time": time,
      "name": name,
      "contact": contact,
      "contact2": contact2,
      "type": type,
      "totalPersons": totalPersons,
      "menu": menu,
      "rate": rate,
      "advance": advance,
      "decoration": decor,
      "decorAmount": decorAmount,
      "extraInfo": extraInfo,
      "extraAmount": extraAmount,
      "totalAmount": totalAmount,
      "balanceAmount": balanceAmount,
      "concessionAmount": concessionAmount,
      "receiveAmount": receiveAmount,
      "details": details,
    };
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .saveHistory(widget.bookingId, bookingMap)
        .whenComplete(() async {
      await Db(id: FirebaseAuth.instance.currentUser!.uid)
          .deleteBooking(widget.bookingId);
    });
  }

  detailsWidget() {
    return Column(
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
              type.toLowerCase() == 'perhead' ? "Per-Head: " : 'Lumpsum: ',
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
        SizedBox(height: advance != '0' ? 10 : 0),

        //Advance
        advance != '0'
            ? Row(
                children: [
                  const Text(
                    'Advance: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Decor.prime,
                    ),
                  ),
                  Text(
                    advance,
                    style: const TextStyle(
                      color: Decor.color,
                    ),
                  ),
                ],
              )
            : Container(),

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
        SizedBox(height: extraInfo != '' ? 10 : 0),

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
        const SizedBox(height: 20),
        TextFormField(
          maxLines: 5,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Description about utils or services'),
          onChanged: (val) {
            details = val;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Utils or service Charges (if-any)'),
          onChanged: (val) {
            extraAmount = val;
          },
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        const SizedBox(height: 10),

        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Concession(if-any)',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          onChanged: (val) {
            concessionAmount = val;
          },
        ),
        const SizedBox(height: 20),
        Center(
          child: OutlinedButton(
            onPressed: () {
              if (type.toLowerCase() == 'perhead') {
                totalAmount =
                    (int.parse(totalPersons) * int.parse(rate)).toString();
              } else {
                totalAmount = rate;
              }
              totalAmount = (int.parse(totalAmount) +
                      int.parse(decorAmount) +
                      int.parse(extraAmount))
                  .toString();
              balanceAmount = (int.parse(totalAmount) -
                      int.parse(concessionAmount) -
                      int.parse(advance))
                  .toString();
              setState(() {
                isTotal = true;
              });
            },
            child: const Text('Check Out'),
          ),
        ),
      ],
    );
  }

  checkOutWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Amount:',
              style: TextStyle(color: Decor.prime, fontWeight: FontWeight.bold),
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
              style: TextStyle(color: Decor.prime, fontWeight: FontWeight.bold),
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
              style: TextStyle(color: Decor.prime, fontWeight: FontWeight.bold),
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
              'Balance:',
              style: TextStyle(color: Decor.prime, fontWeight: FontWeight.bold),
            ),
            Text(
              balanceAmount,
              style: const TextStyle(
                  color: Decor.color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'Receied Amount'),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          onChanged: (val) {
            receiveAmount = val;
          },
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  isTotal = false;
                });
              },
              child: const Text('Back'),
            ),
            OutlinedButton(
              onPressed: () {
                concessionAmount =
                    ((int.parse(balanceAmount) - int.parse(receiveAmount)) +
                            int.parse(concessionAmount))
                        .toString();
                balanceAmount = '0';
                saveHistory();
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Congrats'),
                        content:
                            Text('Your function has been successfully closed!'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  Routes.allBookings, (route) => false);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    });
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ],
    );
  }
}
