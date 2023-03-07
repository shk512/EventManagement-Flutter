import 'package:event_management/services/db.dart';
import 'package:event_management/utils/decor.dart';
import 'package:event_management/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({Key? key}) : super(key: key);

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final formKey = GlobalKey<FormState>();
  String bank = '';
  String accountName = '';
  String branchCode = '';
  String account = '';
  Stream? accountsStream;

  @override
  void initState() {
    getAccountsInfo();
    super.initState();
  }

  getAccountsInfo() async {
    Db(id: FirebaseAuth.instance.currentUser!.uid).getAccounts().then((value) {
      setState(() {
        accountsStream = value;
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
        title: const Text('Account Info'),
      ),
      body: StreamBuilder(
        stream: accountsStream,
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.data.docs[index]['bank'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Warning'),
                                            content: const Text(
                                                'Are you sure to delete?'),
                                            actions: [
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(
                                                    Icons.cancel,
                                                    color: Colors.red,
                                                  )),
                                              IconButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    await Db(
                                                            id: FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                        .deleteAccount(snapshot
                                                            .data
                                                            .docs[index]['id'])
                                                        .whenComplete(() {
                                                      showSnackbar(
                                                          context,
                                                          Colors.green,
                                                          "Deleted");
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.done,
                                                    color: Colors.green,
                                                  ))
                                            ],
                                          );
                                        });
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Decor.lightBlack,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Divider(),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text(
                                  'Branch Code: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data.docs[index]['branchCode'],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text(
                                  'Account no: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data.docs[index]['account'],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text(
                                  'Account Name: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data.docs[index]['accountName'],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return const Center(
              child: Text('No Account Added Yet'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Add Account"),
                  content: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Bank Name',
                          ),
                          onChanged: (val) {
                            bank = val;
                          },
                          validator: (val) {
                            return val!.isNotEmpty ? null : '*Required';
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Account Name',
                          ),
                          onChanged: (val) {
                            accountName = val;
                          },
                          validator: (val) {
                            return val!.isNotEmpty ? null : '*Required';
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Branch Code',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (val) {
                            branchCode = val;
                          },
                          validator: (val) {
                            return val!.isNotEmpty ? null : '*Required';
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Account no.',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (val) {
                            account = val;
                          },
                          validator: (val) {
                            return val!.isNotEmpty ? null : '*Required';
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          saveAccount();
                        }
                      },
                      child: const Text('Done'),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add_card_sharp),
      ),
    );
  }

  saveAccount() async {
    String accountId = "$branchCode-$account";
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .saveAccount(accountId, account, branchCode, accountName, bank)
        .then((value) {
      showSnackbar(context, Decor.prime, value.toString());
    });
  }
}
