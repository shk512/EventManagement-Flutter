import 'package:cloud_firestore/cloud_firestore.dart';

class Db {
  String id;

  Db({required this.id});

  //REFERENCE COLLECTION
  final adminCollection = FirebaseFirestore.instance.collection('admin');
  final postCollection = FirebaseFirestore.instance.collection('posts');
  final forumCollection = FirebaseFirestore.instance.collection('forum');

  //Save Data
  Future saveData(String email, String phone, String name, String city,
      String address, String dp) async {
    await adminCollection.doc(id).set({
      "UserId": id,
      'email': email,
      'dp': dp,
      'phone': phone,
      'name': name,
      'city': city,
      'address': address,
      'catterAmount': '0',
      'chickenAmount': '0',
      'muttonAmount': '0',
      'totalShares': '0',
      'bookings': [],
      'partners': [],
      'accounts': [],
      'token': [],
    });
    return true;
  }

  //get User Data
  getData() {
    return adminCollection.doc(id).get();
  }

  //get All Posts
  getAllPost() {
    return postCollection.snapshots();
  }

  //Delete Data
  deleteData() async {
    await adminCollection.doc(id).delete();
  }

  //update User Data Profile
  Future updateData(String email, String phone, String name, String city,
      String address, String dp) async {
    await adminCollection.doc(id).update({
      'email': email,
      'dp': dp,
      'phone': phone,
      'name': name,
      'city': city,
      'address': address,
    });
    return true;
  }

  //Upload Post
  Future uploadPost(String postId, String name, String address, String image,
      String desc) async {
    await postCollection.doc(postId).set({
      'createBy': id,
      'postId': postId,
      'name': name,
      'address': address,
      'image': image,
      'desc': desc,
      'time': FieldValue.serverTimestamp(),
    });
    return true;
  }

  //SEARCH DATE, HALL AND TIME
  Future searchDateHallAndTime(String bookingId) async {
    DocumentReference reference = adminCollection.doc(id);
    DocumentSnapshot snapshot = await reference.get();
    List<dynamic> check = await snapshot['bookings'];
    if (check.contains(bookingId)) {
      return false;
    } else {
      return true;
    }
  }

  //SAVE BOOKING
  Future saveBooking(String bookingId, Map<String, dynamic> bookingMap) async {
    await adminCollection
        .doc(id)
        .collection("bookings")
        .doc(bookingId)
        .set(bookingMap)
        .whenComplete(() async {
      await adminCollection.doc(id).update({
        "bookings": FieldValue.arrayUnion([bookingId]),
      });
    });
    return true;
  }

  //saveHistory
  Future saveHistory(String bookingId, Map<String, dynamic> bookingMap) async {
    await adminCollection
        .doc(id)
        .collection("history")
        .doc(bookingId)
        .set(bookingMap);
  }

  //Get Booking Info
  getBookingInfo(String bookingId) async {
    return await adminCollection
        .doc(id)
        .collection("bookings")
        .doc(bookingId)
        .get();
  }

  //GET all bookings
  getBookings() async {
    return adminCollection
        .doc(id)
        .collection("bookings")
        .orderBy("date", descending: false)
        .snapshots();
  }

  //Delete Booking
  deleteBooking(String bookingId) async {
    await adminCollection
        .doc(id)
        .collection("bookings")
        .doc(bookingId)
        .delete()
        .whenComplete(() async {
      adminCollection.doc(id).update({
        "bookings": FieldValue.arrayRemove([bookingId]),
      });
    });
  }

  //get Halls Info
  getHallsInfo() async {
    return adminCollection.doc(id).collection("halls").snapshots();
  }

  //SAVE HALL
  Future saveHall(String name, String floor, String capacity, String imageurl,
      String hallId) async {
    await adminCollection.doc(id).collection("halls").doc(hallId).set({
      'hallId': hallId,
      'hallName': name,
      'hallFloor': floor,
      'hallCapacity': capacity,
      'imageUrl': imageurl,
    });
    return true;
  }

  //DELETE HALL
  deleteHall(String hallId) async {
    await adminCollection
        .doc(id)
        .collection("halls")
        .doc(hallId)
        .delete()
        .then((value) {
      return true;
    });
  }

  //GET PARTNERS
  getPartners() async {
    return adminCollection.doc(id).collection("partners").snapshots();
  }

  //DELETE PARTNER
  deletePartner(String partnerId, String name, String percent) async {
    DocumentReference reference = adminCollection.doc(id);
    DocumentSnapshot snapshot = await reference.get();
    String totalShare = snapshot['totalShares'];
    totalShare = (int.parse(totalShare) - int.parse(percent)).toString();
    await adminCollection
        .doc(id)
        .collection("partners")
        .doc(partnerId)
        .delete()
        .whenComplete(() async {
      await adminCollection.doc(id).update({
        "partners": FieldValue.arrayRemove([name]),
        "totalShares": totalShare,
      });
    });
  }

  //CHECK PARTNER
  checkPartner(String name) async {
    DocumentReference reference = adminCollection.doc(id);
    DocumentSnapshot snapshot = await reference.get();
    List<dynamic> list = await snapshot['partners'];
    if (list.contains(name)) {
      return true;
    } else {
      return false;
    }
  }

  //SAVE PARTNER
  Future savePartner(String name, String percent, String partnerId) async {
    DocumentReference reference = adminCollection.doc(id);
    DocumentSnapshot snapshot = await reference.get();
    String totalShare = snapshot['totalShares'];
    if (int.parse(totalShare) + int.parse(percent) > 100) {
      return 'Total shares value exceeds 100%';
    } else {
      await adminCollection.doc(id).collection("partners").doc(partnerId).set({
        "name": name,
        "percentage": percent,
        "id": partnerId,
      }).whenComplete(() async {
        await adminCollection.doc(id).update({
          'partners': FieldValue.arrayUnion([name]),
          'totalShares': (int.parse(totalShare) + int.parse(percent)).toString()
        });
      });
      return 'Saved Successfully';
    }
  }

  //Update Shares
  Future updateShares(
      String partnerId, String percent, String newPercent) async {
    DocumentReference reference = adminCollection.doc(id);
    DocumentSnapshot snapshot = await reference.get();
    String totalShare = snapshot['totalShares'];
    await adminCollection.doc(id).collection("partners").doc(partnerId).update({
      "percentage": newPercent,
    }).whenComplete(() async {
      await adminCollection.doc(id).update({
        "totalShares": ((int.parse(totalShare) - int.parse(percent)) +
                int.parse(newPercent))
            .toString(),
      });
    });
  }

  //Save Account
  Future saveAccount(String accountId, String account, String branchCode,
      String accountName, String bankName) async {
    DocumentReference reference = adminCollection.doc(id);
    DocumentSnapshot snapshot = await reference.get();
    List<dynamic> accountList = snapshot['accounts'];
    if (accountList.contains(accountId)) {
      return "Account no. already exist";
    } else {
      await adminCollection.doc(id).collection("accounts").doc(accountId).set({
        "id": accountId,
        "branchCode": branchCode,
        "account": account,
        "accountName": accountName,
        "bank": bankName,
      }).whenComplete(() async {
        await adminCollection.doc(id).update({
          "accounts": FieldValue.arrayUnion([accountId]),
        });
      });
      return "Saved Succesfully";
    }
  }

  //Get Accounts
  getAccounts() async {
    return adminCollection.doc(id).collection("accounts").snapshots();
  }

  //Delete Account
  Future deleteAccount(String accountId) async {
    await adminCollection
        .doc(id)
        .collection("accounts")
        .doc(accountId)
        .delete()
        .whenComplete(() async {
      await adminCollection.doc(id).update({
        "accounts": FieldValue.arrayRemove([accountId]),
      });
    });
  }

  //get History
  getHistory() async {
    return adminCollection
        .doc(id)
        .collection("history")
        .orderBy("date", descending: true)
        .snapshots();
  }

  //Get History Info
  getHistoryInfo(String bookingId) async {
    return await adminCollection
        .doc(id)
        .collection("history")
        .doc(bookingId)
        .get();
  }

  //save Porposal
  Future savePorposal(String porposalId, String forumId, String name,
      String address, String contact, String porposal) async {
    await forumCollection
        .doc(forumId)
        .collection("porposals")
        .doc(porposalId)
        .set({
      "porposalId": porposalId,
      "porposal": porposal,
      "createrName": name,
      "createBy": id,
      "createContact": contact,
      "createAddress": address,
      "time": FieldValue.serverTimestamp(),
    });
  }

  //Get Pendings
  getPendings() {
    return adminCollection.doc(id).collection("pending").snapshots();
  }
}
