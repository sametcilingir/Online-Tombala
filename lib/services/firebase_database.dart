import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDatabaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? roomId;

  Future<bool> createRoom({String? userName}) async {
    roomId = Random().nextInt(10000000).toString();
    var value = await _firestore.collection("rooms").doc(roomId).get();
    if (value.exists) {
      return false;
    } else {
      await _firestore.collection("rooms").doc(roomId).set({
        "roomCreator": userName,
        "takenNumbersList": FieldValue.arrayUnion([]),
        "isGameStarted": false,
        "isFirstAnounced": false,
        "firstWinner": "",
        "isSecondAnounced": false,
        "secondWinner": "",
        "isThirdAnounced": false,
        "thirdWinner": "",
        "isGameFinished": false,
      });
      return true;
    }
  }

  Future<bool> joinRoom({String? roomId, String? userName}) async {
    var value = await _firestore.collection("rooms").doc(roomId).get();

    if (value.exists) {
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
      //print(value.data()!["isGameStarted"]);

      /*  if (value.data()!["isGameStarted"] == false) {
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
      }*/
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

  Future<bool> deleteGame({String? roomId}) async {
    
    var value = await _firestore.collection("rooms").doc(roomId!).get();
    if (value.exists) {
      await _firestore.collection("rooms").doc(roomId).delete();
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
      {String? roomId,
      String? userName,
      Map<String, dynamic>? playerNumbersMap}) async {
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

  Future<String> setFirstWinner({
    String? roomId,
    String? userName,
  }) async {
    var value = await _firestore.collection("rooms").doc(roomId!).get();

    if (value.exists) {
      bool isfirstAnounced = value.data()!["isFirstAnounced"];
      if (isfirstAnounced == false) {
        try {
          await _firestore.collection("rooms").doc(roomId).update({
            "isFirstAnounced": true,
            "firstWinner": userName,
          });

          return "Ok";
        } catch (e) {
          print("setFirstWinner" + e.toString());
          return "Error";
        }
      } else {
        return "Already Announced";
      }
    } else {
      return "Error";
    }
  }

  Future<String> setSecondWinner({
    String? roomId,
    String? userName,
  }) async {
    var value = await _firestore.collection("rooms").doc(roomId!).get();

    if (value.exists) {
      bool isSecondAnounced = value.data()!["isSecondAnounced"];
      if (isSecondAnounced == false) {
        try {
          await _firestore.collection("rooms").doc(roomId).update({
            "isSecondAnounced": true,
            "secondWinner": userName,
          });

          return "Ok";
        } catch (e) {
          print("setSecondWinner" + e.toString());
          return "Error";
        }
      } else {
        return "Already Announced";
      }
    } else {
      return "Error";
    }
  }

  Future<String> setBingo({
    String? roomId,
    String? userName,
  }) async {
    var value = await _firestore.collection("rooms").doc(roomId!).get();

    if (value.exists) {
      bool isThirdAnounced = value.data()!["isThirdAnounced"];
      if (isThirdAnounced == false) {
        try {
          await _firestore.collection("rooms").doc(roomId).update({
            "isThirdAnounced": true,
            "thirdWinner": userName,
            "isGameFinished": true,
          });

          return "Ok";
        } catch (e) {
          print("setThirdWinner" + e.toString());
          return "Error";
        }
      } else {
        return "Already Announced";
      }
    } else {
      return "Error";
    }
  }
}
