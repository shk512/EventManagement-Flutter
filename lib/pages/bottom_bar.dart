import 'package:event_management/pages/profile.dart';
import 'package:event_management/pages/select_hall.dart';
import 'package:event_management/utils/routes.dart';
import 'package:event_management/widgets/drawer.dart';
import 'package:event_management/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/decor.dart';
import 'accounts.dart';
import 'posts.dart';
import 'booking.dart';
import 'home.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedPage = 0;
  final _pages = [
    Home(),
    HallSelect(),
    Posts(),
    Accounts(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Event Management",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                showSnackbar(context, Colors.green, "Notif clicked");
              },
              child: Icon(Icons.notifications),
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: _pages[selectedPage],
      floatingActionButton: selectedPage == 2
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, Routes.create);
              },
              label: Text('Create New Post'),
              icon: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
        backgroundColor: Colors.white24,
        currentIndex: selectedPage,
        selectedItemColor: Decor.prime,
        unselectedItemColor: Colors.black87,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note_sharp), label: 'Add Booking'),
          BottomNavigationBarItem(
              icon: Icon(Icons.post_add_outlined), label: 'My Posts'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.graph_square_fill), label: 'Accounts'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_alt_circle), label: 'Profile'),
        ],
      ),
    );
  }
}
