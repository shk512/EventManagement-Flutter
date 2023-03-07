import 'package:event_management/services/spf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/decor.dart';
import '../utils/routes.dart';
import '../utils/signature.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String phone = '';
  String name = '';
  @override
  void initState() {
    super.initState();
    getMailAndPhone();
  }

  getMailAndPhone() async {
    await SPF.getName().then((value) {
      setState(() {
        name = value!.toString();
      });
    });
    await SPF.getPhone().then((value) {
      setState(() {
        phone = value!.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              currentAccountPictureSize: Size.square(80),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black54,
                radius: 30,
                child: Icon(
                  Icons.person,
                  size: 60,
                  // color: Colors.white,
                ),
              ),
              accountName: Text(
                phone,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          //BOOKINGS
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.allBookings);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.view_stream_sharp,
                    color: Decor.color,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Bookings',
                    style: TextStyle(
                        color: Decor.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
          ),

          //HISTORY
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.myhistory);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    color: Decor.color,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'History',
                    style: TextStyle(
                        color: Decor.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
          ),

          //ADD HALLS
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.addHall);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Decor.color,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Add Hall',
                    style: TextStyle(
                        color: Decor.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
          ),

          //ACCOUNT SETTINGS
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.accountSettings);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: Decor.color,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Account Settings',
                    style: TextStyle(
                        color: Decor.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
          ),

          //LOGOUT
          InkWell(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.login, (route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Decor.color,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(
                        color: Decor.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Signature,
        ],
      ),
    );
  }
}
