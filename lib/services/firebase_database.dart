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
      "takenNumbersList": FieldValue.arrayUnion([]),
      "isGameStarted": false,
      "isfirstAnounced": false,
      "firstWinner": "",
      "isSecondAnounced": false,
      "secondWinner": "",
      "isThirdAnounced": false,
      "thirdWinner": "",
    });
    return roomId;
  }

  Future<bool> joinRoom({String? roomId, String? userName}) async {
    var value = await _firestore.collection("rooms").doc(roomId).get();

    if (value.exists) {
      print(value.data()!["isGameStarted"]);

      if (value.data()!["isGameStarted"] == false) {
        await _firestore
            .collection("rooms")
            .doc(roomId)
            .collection("players")
            .doc(userName)
            .set({
          "userName": userName,
          "playerNumbersList": [],
        });
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Stream<QuerySnapshot> playersStream({String? roomId}) {
    CollectionReference a =
        _firestore.collection("rooms").doc(roomId!).collection("players");
    return a.snapshots();
  }

  Stream<DocumentSnapshot> gameDocumentStream({String? roomId}) {
    DocumentReference a = _firestore.collection("rooms").doc(roomId!);
    return a.snapshots();
  }

  Future<dynamic> gameDocumentFuture({String? roomId}) async {
    dynamic b;
    DocumentReference a = _firestore.collection("rooms").doc(roomId!);
    await a.get().then((value) => b = value.data());
    return b;
  }

  Future<bool> startGame({String? roomId, String? userName}) async {
    var allNumbersList = List<int>.generate(99, (i) => i + 1);
    var value = await _firestore.collection("rooms").doc(roomId!).get();
    if (value.exists) {
      await _firestore.collection("rooms").doc(roomId).update({
        "isGameStarted": true,
        "allNumbersList": allNumbersList,
      });

      return true;
    } else {
      return false;
    }
  }

  Future<bool> takeNumber({String? roomId, int? number}) async {
    var value = await _firestore.collection("rooms").doc(roomId).get();
    if (value.exists) {
      await _firestore.collection("rooms").doc(roomId).update({
        "allNumbersList": FieldValue.arrayRemove([number]),
        "takenNumbersList": FieldValue.arrayUnion([number]),
      });

      return true;
    } else {
      return false;
    }
  }

  Future<bool> createGameCard(
      {String? roomId,
      String? userName,
      Map<String, dynamic>? playerRandomNumbersForCards}) async {
    var value = await _firestore
        .collection("rooms")
        .doc(roomId!)
        .collection("players")
        .doc(userName)
        .get();
    if (value.exists) {
      await _firestore
          .collection("rooms")
          .doc(roomId)
          .collection("players")
          .doc(userName)
          .update({
        "playerNumbersList": playerRandomNumbersForCards!,
      });

      return true;
    } else {
      return false;
    }
  }

  Future<bool> setMyNumberTrue(
      {String? roomId, String? userName,  Map<String, dynamic>? playerNumbersMap}) async {
    var value = await _firestore
        .collection("rooms")
        .doc(roomId!)
        .collection("players")
        .doc(userName)
        .get();
    if (value.exists) {
      
      await _firestore
          .collection("rooms")
          .doc(roomId)
          .collection("players")
          .doc(userName)
          .update({
        "playerNumbersList": playerNumbersMap!,
      });
      return true;
    } else {
      return false;
    }
  }
}
