import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

class UserProvider with ChangeNotifier {
  String? uid;
  String? email;
  String? username;
  Users? loginUser;
  List<String>? _wishlist = [];

  List<String> get getWishList {
    return [..._wishlist!];
  }

  bool isBookMarked(String bookId) {
    return _wishlist!.contains(bookId);
  }

  Future<void> createUser(String name) async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    username = name;
    email = FirebaseAuth.instance.currentUser!.email;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(Users(id: uid, email: email, name: name, wishList: []).toJson())
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add User: $error"));
  }

  Future<void> getLoginUser() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    loginUser = Users.fromJson(data.data()!);
    _wishlist = loginUser!.wishList;
  }

  Future<void> addBookIntoWishList(String bookId) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'wishList': FieldValue.arrayUnion([bookId])
    }).then((value) {
      _wishlist!.add(bookId);
      notifyListeners();
    }).catchError((error) => print('Could not add book in wishList'));
  }

  Future<void> removeBookFromWishList(String bookId) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'wishList': FieldValue.arrayRemove([bookId])
    }).then((value) {
      _wishlist!.remove(bookId);
      notifyListeners();
    }).catchError((error) => print('Could not remove book from wishList'));
  }
}
