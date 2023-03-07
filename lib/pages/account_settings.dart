import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_management/pages/partners.dart';
import 'package:event_management/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/decor.dart';
import '../utils/routes.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  String caterrAmount = '';
  String accounts = '';
  String chickenAmount = '';
  String muttonAmount = '';
  String totalShares = '';
  bool isNagotiate = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await Db(id: FirebaseAuth.instance.currentUser!.uid).getData().then((val) {
      setState(() {
        caterrAmount = val['catterAmount'];
        totalShares = val['totalShares'];
        isNagotiate = val['Nagotiate'];
        chickenAmount = val['chickenAmount'];
        muttonAmount = val['muttonAmount'];
        accounts = val['accounts'].length.toString();
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
          icon: Icon(CupertinoIcons.back),
          color: Colors.white,
        ),
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          //Bank Account
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, Routes.accountsInfo);
            },
            leading: const Icon(
              Icons.credit_card,
            ),
            title: Text(
              'Account Information',
              style: TextStyle(
                color: Decor.color,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle: Text(accounts == 0 ? 'Not Set' : 'Accounts: $accounts'),
          ),

          //PARTNERS
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, Routes.partners);
            },
            leading: const Icon(
              Icons.group,
            ),
            title: Text(
              'Partners',
              style: TextStyle(
                color: Decor.color,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle: Text(
                totalShares == '0' ? 'Not Set' : 'Total Shares: $totalShares'),
          ),

          //CATTERING RATE
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Update'),
                      content: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g.400',
                          labelText: 'Per Head Cattering Amount',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (val) {
                          caterrAmount = val;
                        },
                        validator: (val) {
                          return val!.isNotEmpty ? null : '*Required';
                        },
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel')),
                        ElevatedButton(
                            onPressed: () {
                              update();
                              Navigator.pop(context);
                            },
                            child: Text('Done')),
                      ],
                    );
                  });
            },
            leading: const Icon(
              Icons.edit,
            ),
            title: Text(
              'Cattering Rate',
              style: TextStyle(
                color: Decor.color,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle: Text(caterrAmount.isNotEmpty
                ? "$caterrAmount Rs. per head"
                : 'Not Set'),
          ),

          //Perhead Chicken RATE
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Update'),
                      content: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g.1000',
                          labelText: 'Per Head with Chicken',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (val) {
                          chickenAmount = val;
                        },
                        validator: (val) {
                          return val!.isNotEmpty ? null : '*Required';
                        },
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel')),
                        ElevatedButton(
                            onPressed: () {
                              update();
                              Navigator.pop(context);
                            },
                            child: Text('Done')),
                      ],
                    );
                  });
            },
            leading: const Icon(
              Icons.edit,
            ),
            title: Text(
              'Per-Head With Chicken',
              style: TextStyle(
                color: Decor.color,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle: Text(chickenAmount != '0'
                ? "$chickenAmount Rs. per head"
                : 'Not Set'),
          ),

          //Perhead Mutton Rate
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Update'),
                      content: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g.1500',
                          labelText: 'Per Head with Mutton',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (val) {
                          muttonAmount = val;
                        },
                        validator: (val) {
                          return val!.isNotEmpty ? null : '*Required';
                        },
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel')),
                        ElevatedButton(
                            onPressed: () {
                              update();
                              Navigator.pop(context);
                            },
                            child: Text('Done')),
                      ],
                    );
                  });
            },
            leading: const Icon(
              Icons.edit,
            ),
            title: Text(
              'Per-Head with Mutton',
              style: TextStyle(
                color: Decor.color,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle: Text(muttonAmount != null
                ? "$muttonAmount Rs. per head"
                : 'Not Set'),
          ),

          //NAGOTIABLE CHECK
          CheckboxListTile(
            value: isNagotiate,
            onChanged: (val) {
              setState(() {
                isNagotiate = val as bool;
              });
              update();
            },
            title: Text(
              'Nagotiate',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            subtitle: Text('Check if rates are nagotiable'),
          )
        ],
      ),
    );
  }

  update() async {
    await FirebaseFirestore.instance
        .collection("admin")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "catterAmount": caterrAmount,
      "Nagotiate": isNagotiate,
      "chickenAmount": chickenAmount,
      "muttonAmount": muttonAmount,
    }).whenComplete(() {
      setState(() {});
    });
  }
}
