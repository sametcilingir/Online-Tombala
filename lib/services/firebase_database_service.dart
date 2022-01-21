import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tombala/model/player_model.dart';
import 'package:tombala/model/room_model.dart';

class FirebaseDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  "takenNumbersList": FieldValue.arrayUnion([]),

  Future<String?> createRoom(RoomModel roomModel) async {
    var documentRef = _firestore.collection("rooms").doc();
    roomModel.roomId = documentRef.id;
    await documentRef.set(
      roomModel.toJson(),
    );
    return roomModel.roomId;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> playersStream(
      RoomModel roomModel) {
    final playersList = _firestore
        .collection("rooms")
        .doc(roomModel.roomId)
        .collection("players")
        .snapshots();

    return playersList;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> roomStream(
      RoomModel roomModel) {
    final roomStream =
        _firestore.collection("rooms").doc(roomModel.roomId).snapshots();
    return roomStream;
  }

  Future<void> setPlayerStatus(
      RoomModel roomModel, PlayerModel playerModel) async {
    var documentRef = _firestore
        .collection("rooms")
        .doc(roomModel.roomId)
        .collection("players")
        .doc(playerModel.userId);

    await documentRef.update(playerModel.toJson());
  }

  Future<List> joinRoom(String roomCode, String userName) async {
    var querySnapshot = await _firestore
        .collection("rooms")
        .where("roomCode", isEqualTo: roomCode)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      RoomModel roomModel = RoomModel();
      //querySnapshot.docs.forEach((element) {
      for (var element in querySnapshot.docs) {
        roomModel = RoomModel.fromJson(element.data());
      }
      var documentReferance = _firestore
          .collection("rooms")
          .doc(roomModel.roomId)
          .collection("players")
          .doc();
      PlayerModel playerModel = PlayerModel(
        userId: documentReferance.id,
        userName: userName,
        userStatus: false,
      );
      await documentReferance.set(
        playerModel.toJson(),
      );
      return [playerModel, roomModel];
    } else {
      return [PlayerModel(), RoomModel()];
    }
  }

  Future<void> startGame(RoomModel roomModel) async {
    await _firestore
        .collection("rooms")
        .doc(roomModel.roomId)
        .update(roomModel.toJson());
  }

  Future<void> takeNumber(RoomModel roomModel) async {
    await _firestore
        .collection("rooms")
        .doc(roomModel.roomId,)
        .update(roomModel.toJson());
  }

  Future<void> deleteGame(RoomModel roomModel) async {
    await _firestore
        .collection("rooms")
        .doc(
          roomModel.roomId,
        )
        .delete();
  }
}
