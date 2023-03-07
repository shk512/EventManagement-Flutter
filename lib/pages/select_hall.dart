import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_management/pages/booking.dart';
import 'package:event_management/utils/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/db.dart';
import '../utils/decor.dart';
import '../utils/routes.dart';
import '../widgets/snack_bar.dart';

class HallSelect extends StatefulWidget {
  const HallSelect({Key? key}) : super(key: key);

  @override
  State<HallSelect> createState() => _HallSelectState();
}

class _HallSelectState extends State<HallSelect> {
  Stream<QuerySnapshot>? halls;
  String selectedHall = '';

  @override
  void initState() {
    super.initState();
    getHallsInfo();
  }

  getHallsInfo() async {
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .getHallsInfo()
        .then((val) {
      setState(() {
        halls = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        hallsList(),
        Center(
            child: Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  if (selectedHall.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Booking(
                                  hallName: selectedHall,
                                )));
                  } else {
                    showSnackbar(context, Colors.red, "Oops! No hall selected");
                  }
                },
                child: Container(
                  width: 120,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Decor.prime,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    selectedHall == '' ? 'Select Hall' : 'Done',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        )),
      ],
    );
  }

  hallsList() {
    return StreamBuilder(
        stream: halls,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error'),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    setState(() {
                      selectedHall = snapshot.data.docs[index]['hallName'];
                    });
                  },
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Warning',
                              style: TextStyle(color: Colors.red),
                            ),
                            content: Text('Are your sure to remove this hall?'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  deleteHall(
                                      snapshot.data.docs[index]["hallId"]);
                                  Navigator.pop(context);
                                },
                                child: Text('Done'),
                              )
                            ],
                          );
                        });
                  },
                  leading: CircleAvatar(
                    radius: 30,
                    child: snapshot.data.docs[index]['imageUrl'].isNotEmpty
                        ? Image.network(
                            '${snapshot.data.docs[index]['imageUrl']}')
                        : Icon(Icons.image),
                  ),
                  title: Text(
                      '${snapshot.data.docs[index]['hallName']} - ${snapshot.data.docs[index]['hallFloor']} Floor'
                          .toUpperCase()),
                  subtitle: Text(
                      'Sitting Capacity: ${snapshot.data.docs[index]['hallCapacity']} persons'),
                  trailing: Radio(
                    value: snapshot.data.docs[index]['hallName'],
                    groupValue: selectedHall,
                    onChanged: (value) {
                      setState(() {
                        selectedHall = value;
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Alas! No hall added yet',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.addHall);
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.add,
                          size: 30,
                          color: Decor.lightBlack,
                        ),
                        Text('Add Hall'),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        });
  }

  deleteHall(String hallId) async {
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .deleteHall(hallId)
        .then((value) {
      if (value != true) {
        showSnackbar(context, Colors.green, "Removed");
        setState(() {});
      }
    });
  }
}
