import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDatabaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createRoom({String? userName}) async {
    String roomId = Random().nextInt(100000).toString();
    DocumentReference documentReference = _firestore.collection("rooms").doc();
    await documentReference.set({
      "documentId": documentReference.id,
      "roomId": roomId,
      "userName": userName,
    });
    return roomId;
  }

  Future<void> joinRoom({String? roomId, String? userName}) async {
    DocumentReference documentReference = await _firestore
        .collection("rooms")
        .doc(roomId!)
        .collection("players")
        .doc();
    documentReference.set({
      "userName": userName,
      "documentId": documentReference.id,
      "joinTime": FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> playersStream({String? roomId}) {
    CollectionReference a =
        _firestore.collection("rooms").doc(roomId!).collection("players");
    return a.snapshots();
  }
}
