import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tombala/components/models/message/message_model.dart';
import 'package:tombala/components/models/player/player_model.dart';
import 'package:tombala/components/models/room/room_model.dart';

abstract class DatabaseService {
  Future<String?> createRoom(RoomModel roomModel);
  Stream<QuerySnapshot<Map<String, dynamic>>> playersStream(
      RoomModel roomModel);
  Stream<DocumentSnapshot<Map<String, dynamic>>> roomStream(
      RoomModel roomModel);
  Future<void> setPlayerStatus(RoomModel roomModel, PlayerModel playerModel);
  Future<List> joinRoom(String roomCode, String userName);
  Future<void> updateGame(RoomModel roomModel);
  Future<void> deleteGame(RoomModel roomModel);
  Stream<QuerySnapshot<Map<String, dynamic>>> messageStream(
      RoomModel roomModel);
  Future<bool> sendMessage(RoomModel roomModel, MessageModel messageModel);
}
