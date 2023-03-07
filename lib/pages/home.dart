import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../services/db.dart';
import '../utils/decor.dart';
import '../widgets/snack_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController proposalCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String currentAddress = '';
  Position? _currentposition;
  late List<Placemark> placemark;
  String name = '';
  String contact = '';
  String address = '';
  @override
  void initState() {
    super.initState();
    getLocation();
    getData();
  }

  getData() async {
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .getData()
        .then((snapshot) {
      setState(() {
        name = snapshot['name'];
        contact = snapshot['phone'];
        address = '${snapshot['address']} - ${snapshot['city']}';
      });
    });
  }

  getLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentposition = position;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool servideEnabled;
    LocationPermission permission;

    servideEnabled = await Geolocator.isLocationServiceEnabled();
    if (!servideEnabled) {
      showSnackbar(context, Colors.red, "Location Disable. Please Enable It");
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackbar(context, Colors.red, "Permission Denied");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showSnackbar(context, Colors.red, "Permission Denied Permanently");
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      return;
    }
    await getLocation();
    _getAddressFromLatLng(_currentposition!);
  }

  Future<void> _getAddressFromLatLng(Position? currentposition) async {
    await placemarkFromCoordinates(
            _currentposition!.latitude, _currentposition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
            '${place.street},${place.subAdministrativeArea},${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("forum")
              .orderBy("time", descending: true)
              .snapshots(),
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
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data.docs[index]['name'],
                                  style: const TextStyle(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                    color: Decor.color,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Divider(),
                                const SizedBox(height: 5),
                                const Text(
                                  'Description ',
                                  style: TextStyle(
                                    color: Decor.prime,
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(snapshot.data.docs[index]['desc']),
                                const SizedBox(height: 5),
                                const Divider(),
                                const SizedBox(height: 5),
                                Center(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Porposal'),
                                              content: Form(
                                                key: formKey,
                                                child: TextFormField(
                                                  controller: proposalCtrl,
                                                  maxLines: 5,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    hintText:
                                                        'Write Your Porposal...',
                                                  ),
                                                  validator: (val) {
                                                    return val!.isNotEmpty
                                                        ? null
                                                        : '*Required';
                                                  },
                                                ),
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Cancel"),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      Navigator.pop(context);
                                                      savePorposal(snapshot
                                                              .data.docs[index]
                                                          ['forumId']);
                                                    }
                                                  },
                                                  child: Text("Done"),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Text('Write a porposal'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  });
            } else {
              return const Center(
                child: Text('No Data Added Yet'),
              );
            }
          }),
    );
  }

  savePorposal(String forumId) async {
    Db(id: FirebaseAuth.instance.currentUser!.uid)
        .savePorposal(DateTime.now().millisecondsSinceEpoch.toString(), forumId,
            name, address, contact, proposalCtrl.text)
        .whenComplete(() {
      showSnackbar(
          context, Colors.green, "Your porposal has been sent to the client!");
      setState(() {
        proposalCtrl.text = '';
      });
    });
  }
}
