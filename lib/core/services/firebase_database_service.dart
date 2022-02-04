import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/models/message_model/message_model.dart';
import '../../components/models/player_model/player_model.dart';
import '../../components/models/room_model/room_model.dart';
import 'database_service.dart';

class FirebaseDatabaseService implements DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  "takenNumbersList": FieldValue.arrayUnion([]),

  @override
  Future<String?> createRoom(RoomModel roomModel) async {
    final documentRef = _firestore.collection("rooms").doc();
    roomModel.roomId = documentRef.id;
    await documentRef.set(
      roomModel.toJson(),
    );
    return roomModel.roomId;
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> playersStream(
      RoomModel roomModel,) {
    final playersList = _firestore
        .collection("rooms")
        .doc(roomModel.roomId)
        .collection("players")
        .snapshots();

    return playersList;
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> roomStream(
      RoomModel roomModel,) {
    final roomStream =
        _firestore.collection("rooms").doc(roomModel.roomId).snapshots();
    return roomStream;
  }

  @override
  Future<void> setPlayerStatus(
    RoomModel roomModel,
    PlayerModel playerModel,
  ) async {
    final documentRef = _firestore
        .collection("rooms")
        .doc(roomModel.roomId)
        .collection("players")
        .doc(playerModel.userId);

    await documentRef.update(playerModel.toJson());
  }

  @override
  Future<List> joinRoom(String roomCode, String userName) async {
    final querySnapshot = await _firestore
        .collection("rooms")
        .where("roomCode", isEqualTo: roomCode)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      RoomModel roomModel = RoomModel();
      //querySnapshot.docs.forEach((element) {
      for (final element in querySnapshot.docs) {
        roomModel = RoomModel.fromJson(element.data());
      }
      final documentReferance = _firestore
          .collection("rooms")
          .doc(roomModel.roomId)
          .collection("players")
          .doc();
      final playerModel = PlayerModel(
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

  @override
  Future<void> updateGame(RoomModel roomModel) async {
    await _firestore
        .collection("rooms")
        .doc(roomModel.roomId)
        .update(roomModel.toJson());
  }

  @override
  Future<void> deleteGame(RoomModel roomModel) async {
    await _firestore.collection("rooms").doc(roomModel.roomId).delete();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> messageStream(
    RoomModel roomModel,
  ) {
    final messagesList = _firestore
        .collection("rooms")
        .doc(roomModel.roomId)
        .collection("messages")
        .orderBy("messageSentTime", descending: true)
        .snapshots();

    return messagesList;
  }

  @override
  Future<bool> sendMessage(
    RoomModel roomModel,
    MessageModel messageModel,
  ) async {
    final documentRef = _firestore
        .collection("rooms")
        .doc(roomModel.roomId)
        .collection("messages")
        .doc();
    messageModel.messageSentTime = Timestamp.now().toDate();

    await documentRef.set(
      messageModel.toJson(),
    );

    return true;
  }
}
