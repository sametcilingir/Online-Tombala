import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/services/firebase_database.dart';

part 'view_model.g.dart';

class ViewModel = _ViewModelBase with _$ViewModel;

abstract class _ViewModelBase with Store {
  final FirebaseDatabaseService _firebaseDatabaseService =
      locator<FirebaseDatabaseService>();

  @observable
  GlobalKey<FormState> formKeyUserName = GlobalKey<FormState>();

  @observable
  GlobalKey<FormState> formKeyRoomId = GlobalKey<FormState>();

  @observable
  String? userName;

  @observable
  String? roomId;

  @observable
  BuildContext? context;

  @action
  Future<bool> createRoom() async {
    try {
      await _firebaseDatabaseService
          .createRoom(userName: userName)
          .then((value) => roomId = value);

      joinRoom();

      return true;
    } catch (e) {
      print("Oda oluşturmada hata oluştu: $e");
      return false;
    }
  }

  @action
  Future<bool> joinRoom() async {
    try {
      bool isRoomExist = await _firebaseDatabaseService.joinRoom(
          roomId: roomId, userName: userName);
      if (isRoomExist) {
        return true;
      } else {
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(
            content: Text(
              "Oda katiliminda hata oluştu",
            ),
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text(
            "Oda katiliminda hata oluştu",
          ),
        ),
      );

      print("Odaya katilimda hata oluştu: $e");
      return false;
    }
  }

  @action
  Stream<QuerySnapshot> playersStream() {
    try {
      return _firebaseDatabaseService.playersStream(roomId: roomId);
    } catch (e) {
      print("Oda kullanici bulma hata oluştu: $e");
      return Stream<QuerySnapshot>.empty();
    }
  }
}
