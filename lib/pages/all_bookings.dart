import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_management/pages/function_details.dart';
import 'package:event_management/services/db.dart';
import 'package:event_management/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllBooking extends StatefulWidget {
  const AllBooking({Key? key}) : super(key: key);

  @override
  State<AllBooking> createState() => _AllBookingState();
}

class _AllBookingState extends State<AllBooking> {
  Stream<QuerySnapshot>? bookings;
  Stream? pendings;
  bool isPending = false;

  @override
  void initState() {
    super.initState();
    getBooking();
    getPendings();
  }

  getPendings() async {
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .getPendings()
        .then((val) {
      setState(() {
        pendings = val;
      });
    });
  }

  getBooking() async {
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .getBookings()
        .then((value) {
      setState(() {
        bookings = value;
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
        title: Text(isPending ? 'Pending Bookings' : 'Confirm Bookings'),
      ),
      body: isPending ? pendingBooking() : confirmBooking(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.swap_horiz),
          label: Text(!isPending ? 'Pending Bookings' : 'Confirm Bookings')),
    );
  }

  confirmBooking() {
    return StreamBuilder(
        stream: bookings,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FunctionDetails(
                                  bookingId:
                                      "${snapshot.data.docs[index]["bookingId"]}")));
                    },
                    title: Text("${snapshot.data.docs[index]["bookingId"]}"
                        .toUpperCase()),
                    subtitle: Text(
                        "Hoted By: ${snapshot.data.docs[index]["name"]} _ Contact: ${snapshot.data.docs[index]["contact"]}"),
                    trailing: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  'Warning',
                                  style: TextStyle(color: Colors.red),
                                ),
                                content: const Text(
                                    'Are your sure to remove this hall?'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      deleteBooking(snapshot.data.docs[index]
                                          ["bookingId"]);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete'),
                                  )
                                ],
                              );
                            });
                      },
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
              child: Text('No Booking'),
            );
          }
        });
  }

  pendingBooking() {
    return StreamBuilder(
        stream: pendings,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FunctionDetails(
                                  bookingId:
                                      "${snapshot.data.docs[index]["bookingId"]}")));
                    },
                    title: Text("${snapshot.data.docs[index]["bookingId"]}"
                        .toUpperCase()),
                    subtitle: Text(
                        "Hoted By: ${snapshot.data.docs[index]["name"]} _ Contact: ${snapshot.data.docs[index]["contact"]}"),
                    trailing: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  'Warning',
                                  style: TextStyle(color: Colors.red),
                                ),
                                content: const Text(
                                    'Are your sure to remove this hall?'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      deleteBooking(snapshot.data.docs[index]
                                          ["bookingId"]);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete'),
                                  )
                                ],
                              );
                            });
                      },
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
              child: Text('No Booking'),
            );
          }
        });
  }

  deleteBooking(String bookingId) async {
    bool del = await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .deleteBooking(bookingId);
    if (del) {
      showSnackbar(context, Colors.green, "Deleted");
      setState(() {});
    } else {
      showSnackbar(context, Colors.red, "Error");
    }
  }
}
