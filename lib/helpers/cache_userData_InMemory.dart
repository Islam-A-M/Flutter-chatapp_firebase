import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/username.dart';

class CasheduserData with ChangeNotifier {
  List<Username> data = [];

  Future<Object> findUsernameByUid(String uid) async {
    return await checkAndSetUsers(uid);
  }

  bool chkList(String uid) {
    if (data.indexWhere((element) => element.uid == uid) == -1) {
      print('chkFaa');

      return false;
    } else {
      print('chkTr');

      return true;
    }
  }

  Future<Username> checkAndSetUsers(String uid) async {
    var userData;

    //checklist
    if (uid == null) {
      return null;
    }
    if (!chkList(uid)) {
      var fetchedUserData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      userData = Username(
          uid: uid,
          username: fetchedUserData.data()['username'],
          imageurl: fetchedUserData.data()['image_url']);
    }
    print('test');
    //print(userData);

    if (!chkList(uid) && userData != null) {
      data.add(userData);
      print('added');
    }
    var filterdData = data.firstWhere((element) => element.uid == uid);
    ////print(filterdData);
    print('filterdData');
    //print(userData.length);
    return filterdData == null ? null : filterdData;
  }
}
