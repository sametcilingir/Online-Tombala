import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDatabaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createRoom({String? userName}) async {
    String roomId = Random().nextInt(10000000).toString();
    DocumentReference documentReference =
        _firestore.collection("rooms").doc(roomId);
    await documentReference.set({
      "roomCreator": userName,
    });
    return roomId;
  }

  Future<bool> joinRoom({String? roomId, String? userName}) async {
    var value = await _firestore.collection("rooms").doc(roomId!).get();
    if (value.exists) {
      await _firestore
          .collection("rooms")
          .doc(roomId)
          .collection("players")
          .doc()
          .set({
        "userName": userName,
      });
      return true;
    } else {
      return false;
    }
  }

  Stream<QuerySnapshot> playersStream({String? roomId}) {
    CollectionReference a =
        _firestore.collection("rooms").doc(roomId!).collection("players");
    return a.snapshots();
  }
}
