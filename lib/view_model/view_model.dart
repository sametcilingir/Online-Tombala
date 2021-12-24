import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/services/firebase_database.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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

  @observable
  bool? isGameStarted = false;

  //ObservableList<dynamic>? allNumbersListDatabaseObservable = ObservableList();

  //@observable
  //ObservableList<dynamic>? allNumbersListTableObservable = ObservableList();

  @observable
  List<dynamic> allNumbersListDatabase = <dynamic>[];

  @observable
  List<dynamic> allNumbersListTable =
      List<dynamic>.generate(100, (i) => i + 1).map((i) => i).toList();

  @action
  Future<bool> createRoom({required BuildContext context}) async {
    try {
      await _firebaseDatabaseService
          .createRoom(userName: userName)
          .then((value) => roomId = value);

      joinRoom(context: context);

      return true;
    } catch (e) {
      print("Oda oluşturmada hata oluştu: $e");
      return false;
    }
  }

  @action
  Future<bool> joinRoom({required BuildContext context}) async {
    try {
      bool isRoomExist = await _firebaseDatabaseService.joinRoom(
          roomId: roomId, userName: userName);
      if (isRoomExist) {
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Oda katiliminda hata oluştu",
            ),
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
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

  @action
  Stream<DocumentSnapshot> gameDocumentStream() {
    try {
      return _firebaseDatabaseService.gameDocumentStream(roomId: roomId);
    } catch (e) {
      print("gameDocumentStream hata oluştu: $e");
      return Stream<DocumentSnapshot>.empty();
    }
  }

  @action
  Future<void> gameDocumentFuture() async {
    try {
      var a = await _firebaseDatabaseService.gameDocumentFuture(roomId: roomId);
      var data = a.data!.get("allNumbersList");
      allNumbersListDatabase = data;
    } catch (e) {
      print("gameDocumentFuture hata oluştu: $e");
    }
  }

  @action
  Future<bool> startGame() async {
    try {
      await _firebaseDatabaseService.startGame(roomId: roomId);

      return true;
    } catch (e) {
      print("Oyuna girmede hata oluştu: $e");
      return false;
    }
  }

  //@observable
  //ObservableList<dynamic>? takenNumber;

  @action
  Future<bool> takeNumber({required BuildContext context}) async {
    try {
      if (allNumbersListTable.isNotEmpty) {
        var randomNumber = (allNumbersListDatabase..shuffle()).first;
        //takenNumber!.addAll([randomNumber]);

        print("randomNumber: $randomNumber");
        await _firebaseDatabaseService.takeNumber(
            roomId: roomId, number: randomNumber);

        AwesomeDialog(
          context: context,
          dialogType: DialogType.NO_HEADER,
          animType: AnimType.SCALE,
          autoHide: Duration(seconds: 5),
          dialogBackgroundColor: Colors.green,
          body: Column(
            children: [
              Text(
                randomNumber.toString(),
                style: TextStyle(fontSize: 42),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Çekilen sayi',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ).show();

        return true;
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Oyun Bitti',
          desc: 'Tekrar oynamak ister misiniz?',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        )..show();

        print("List bitti");
        return false;
      }
    } catch (e) {
      print("Taş ÇEkmede hata oluştu: $e");
      return false;
    }
  }

  @observable
  List randomNumbersForCards = [];

  @observable
  Color randomColor = Colors.transparent;

  @action
  Future<bool> createGameCard() async {
    try {
      randomNumbersForCards.clear();
      var a0 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      var a1 = (a0..shuffle()).first;
      a0.remove(a1);
      var a2 = (a0..shuffle()).first;
      a0.remove(a2);
      var a3 = (a0..shuffle()).first;

      var b0 = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
      var b1 = (b0..shuffle()).first;
      b0.remove(b1);
      var b2 = (b0..shuffle()).first;
      b0.remove(b2);
      var b3 = (b0..shuffle()).first;

      var c0 = [21, 22, 23, 24, 25, 26, 27, 28, 29, 30];
      var c1 = (c0..shuffle()).first;
      c0.remove(c1);
      var c2 = (c0..shuffle()).first;
      c0.remove(c2);
      var c3 = (c0..shuffle()).first;

      var d0 = [31, 32, 33, 34, 35, 36, 37, 38, 39, 40];
      var d1 = (d0..shuffle()).first;
      d0.remove(d1);
      var d2 = (d0..shuffle()).first;
      d0.remove(d2);
      var d3 = (d0..shuffle()).first;

      var e0 = [41, 42, 43, 44, 45, 46, 47, 48, 49, 50];
      var e1 = (e0..shuffle()).first;
      e0.remove(e1);
      var e2 = (e0..shuffle()).first;
      e0.remove(e2);
      var e3 = (e0..shuffle()).first;

      var f0 = [51, 52, 53, 54, 55, 56, 57, 58, 59, 60];
      var f1 = (f0..shuffle()).first;
      f0.remove(f1);
      var f2 = (f0..shuffle()).first;
      f0.remove(f2);
      var f3 = (f0..shuffle()).first;

      var g0 = [61, 62, 63, 64, 65, 66, 67, 68, 69, 70];
      var g1 = (g0..shuffle()).first;
      g0.remove(g1);
      var g2 = (g0..shuffle()).first;
      g0.remove(g2);
      var g3 = (g0..shuffle()).first;

      var h0 = [71, 72, 73, 74, 75, 76, 77, 78, 79, 80];
      var h1 = (h0..shuffle()).first;
      h0.remove(h1);
      var h2 = (h0..shuffle()).first;
      h0.remove(h2);
      var h3 = (h0..shuffle()).first;

      var i0 = [81, 82, 83, 84, 85, 86, 87, 88, 89, 90];
      var i1 = (i0..shuffle()).first;
      i0.remove(i1);
      var i2 = (i0..shuffle()).first;
      i0.remove(i2);
      var i3 = (i0..shuffle()).first;

      var j0 = [91, 92, 93, 94, 95, 96, 97, 98, 99];
      var j1 = (j0..shuffle()).first;
      j0.remove(j1);
      var j2 = (j0..shuffle()).first;
      j0.remove(j2);
      var j3 = (j0..shuffle()).first;

      randomNumbersForCards.addAll(
        [
          a1,
          a2,
          a3,
          b1,
          b2,
          b3,
          c1,
          c2,
          c3,
          d1,
          d2,
          d3,
          e1,
          e2,
          e3,
          f1,
          f2,
          f3,
          g1,
          g2,
          g3,
          h1,
          h2,
          h3,
          i1,
          i2,
          i3,
          j1,
          j2,
          j3,
        ],
      );

      randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

      return true;
    } catch (e) {
      print("GameCard oluturmada hata oluştu: $e");
      return false;
    }
  }

  @observable
  bool isMyNumberShown = false;

  @action
  bool checkMyNumber(BuildContext context) {
    if (allNumbersListTable.contains(randomNumbersForCards)) {
      isMyNumberShown = true;
      // if (randomNumber == myNumber) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        autoHide: Duration(seconds: 1),
        title: 'Tebrikler',
        desc: 'Tebrikler, sayınız doğru',
      ).show();
      return true;
    } else {
      isMyNumberShown = false;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        autoHide: Duration(seconds: 1),
        title: 'Üzgünüm',
        desc: 'Üzgünüm, sayınız yanlış',
      ).show();
      return false;
    }
  }
}
