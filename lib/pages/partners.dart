import 'package:event_management/services/db.dart';
import 'package:event_management/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/decor.dart';

class Partners extends StatefulWidget {
  const Partners({Key? key}) : super(key: key);

  @override
  State<Partners> createState() => _PartnersState();
}

class _PartnersState extends State<Partners> {
  Stream? partners;
  String name = '';
  String percent = '';
  String newPercent = '';
  String totalShares = '';
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getPartners();
    getData();
  }

  getData() async {
    await Db(id: FirebaseAuth.instance.currentUser!.uid).getData().then((val) {
      setState(() {
        totalShares = val['totalShares'];
      });
    });
  }

  getPartners() async {
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .getPartners()
        .then((val) {
      setState(() {
        partners = val;
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
        title: Text('Partners'),
      ),
      body: StreamBuilder(
        stream: partners,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      onTap: () {
                        //EDIT
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    '${snapshot.data.docs[index]['name']}'),
                                content: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'e.g. 50',
                                    labelText: 'Shares',
                                  ),
                                  onChanged: (val) {
                                    newPercent = val;
                                  },
                                  validator: (val) {
                                    return val!.isNotEmpty ? null : '*Required';
                                  },
                                ),
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      if ((int.parse(totalShares) -
                                                  int.parse(
                                                      snapshot.data.docs[index]
                                                          ['percentage'])) +
                                              int.parse(newPercent) <=
                                          100) {
                                        Navigator.pop(context);
                                        await Db(
                                                id: FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .updateShares(
                                                snapshot.data.docs[index]['id'],
                                                snapshot.data.docs[index]
                                                    ['percentage'],
                                                newPercent);

                                        setState(() {
                                          totalShares =
                                              ((int.parse(totalShares) -
                                                          int.parse(snapshot
                                                                  .data
                                                                  .docs[index]
                                                              ['percentage'])) +
                                                      int.parse(newPercent))
                                                  .toString();
                                        });
                                      } else {
                                        showSnackbar(context, Decor.prime,
                                            'Shares are full');
                                      }
                                    },
                                    icon: Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      leading: CircleAvatar(
                        radius: 20,
                        child: Text('${index + 1}'),
                      ),
                      title: Text(
                        '${snapshot.data.docs[index]['name']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                          'Shares: ${snapshot.data.docs[index]['percentage']}%'),
                      trailing: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Warning'),
                                  content: Text('Are you sure to delete'),
                                  actions: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await Db(
                                                id: FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .deletePartner(
                                                snapshot.data.docs[index]['id'],
                                                snapshot.data.docs[index]
                                                    ['name'],
                                                snapshot.data.docs[index]
                                                    ['percentage']);
                                        setState(() {
                                          totalShares =
                                              (int.parse(totalShares) -
                                                      int.parse(snapshot
                                                              .data.docs[index]
                                                          ['percentage']))
                                                  .toString();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ));
                });
          } else {
            return const Center(
              child: Text('No Data to show!'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          totalShares == '100'
              ? showSnackbar(context, Decor.prime, 'Shares are full')
              : showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('New Partner'),
                      content: Container(
                        height: 150,
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Name Should Be Unique',
                                  labelText: 'Name',
                                ),
                                onChanged: (val) {
                                  name = val;
                                },
                                validator: (val) {
                                  return val!.isNotEmpty ? null : '*Required';
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'e.g. 50',
                                  labelText: 'Percentage',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (val) {
                                  percent = val;
                                },
                                validator: (val) {
                                  return val!.isNotEmpty ? null : '*Required';
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel')),
                        ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                checkPartner();
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Save')),
                      ],
                    );
                  });
        },
        child: Icon(Icons.person_add),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Text(
          "Total Shares: ${totalShares}%",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  checkPartner() async {
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .checkPartner(name)
        .then((val) async {
      if (val == false) {
        await Db(id: FirebaseAuth.instance.currentUser!.uid)
            .savePartner(
                name, percent, DateTime.now().millisecondsSinceEpoch.toString())
            .then((value) {
          showSnackbar(context, Decor.prime, value.toString());
          if (value.toString() == 'Saved Successfully') {
            setState(() {
              totalShares =
                  (int.parse(totalShares) + int.parse(percent)).toString();
            });
          }
        });
      } else {
        showSnackbar(context, Colors.red, 'Oops! Name already exist');
      }
    });
  }
}
