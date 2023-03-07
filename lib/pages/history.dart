import 'package:event_management/pages/history_preview.dart';
import 'package:event_management/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Stream? history;
  @override
  void initState() {
    getHistory();
    super.initState();
  }

  getHistory() async {
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .getHistory()
        .then((val) {
      setState(() {
        history = val;
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
        title: Text('History'),
      ),
      body: StreamBuilder(
        stream: history,
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HistoryPreview(
                                    bookingId: snapshot.data.docs[index]
                                        ['bookingId'],
                                  )));
                    },
                    title: Text("${snapshot.data.docs[index]["bookingId"]}"
                        .toUpperCase()),
                    subtitle: Text(
                        "Hoted By: ${snapshot.data.docs[index]["name"]} _ Contact: ${snapshot.data.docs[index]["contact"]}"),
                  );
                });
          } else {
            return const Center(
              child: Text('No History'),
            );
          }
        },
      ),
    );
  }
}
