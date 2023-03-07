import 'package:event_management/pages/account_info.dart';
import 'package:event_management/pages/account_settings.dart';
import 'package:event_management/pages/add_hall.dart';
import 'package:event_management/pages/all_bookings.dart';
import 'package:event_management/pages/bottom_bar.dart';
import 'package:event_management/pages/create.dart';
import 'package:event_management/pages/history.dart';
import 'package:event_management/pages/partners.dart';
import 'package:event_management/utils/decor.dart';
import 'package:event_management/pages/login.dart';
import 'package:event_management/pages/signup.dart';
import 'package:event_management/services/spf.dart';
import 'package:event_management/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogIn = false;

  @override
  void initState() {
    super.initState();
    getUserLogInStatus();
  }

  getUserLogInStatus() async {
    await SPF.getLogInStatus().then((value) {
      if (value == true) {
        setState(() {
          isLogIn = value!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Management',
      theme: ThemeData(
        primaryColor: Decor.prime,
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: isLogIn ? Routes.bottomBar : Routes.login,
      routes: {
        Routes.login: (context) => const Login(),
        Routes.signup: (context) => const Signup(),
        Routes.bottomBar: (context) => const BottomBar(),
        Routes.create: (context) => const Create(),
        Routes.addHall: (context) => const Add_Hall(),
        Routes.allBookings: (context) => const AllBooking(),
        Routes.accountSettings: (context) => const AccountSettings(),
        Routes.myhistory: (context) => const History(),
        Routes.partners: (context) => const Partners(),
        Routes.accountsInfo: (context) => const AccountInfo(),
      },
    );
  }
}
