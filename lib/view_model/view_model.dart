import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
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
  Future<bool> createRoom() async {
    try {
      var isRoomCreated =
          await _firebaseDatabaseService.createRoom(userName: userName);
      if (isRoomCreated) {
        roomId = _firebaseDatabaseService.roomId;
        return true;
      } else {
        return false;
      }
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
        showToastWidget(
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              margin: EdgeInsets.all(20),
              child: Text(
                'Oda katiliminda hata oluştu',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          position: StyledToastPosition.top,
          duration: Duration(seconds: 2),
          context: context,
          animation: StyledToastAnimation.slideFromTop,
          reverseAnimation: StyledToastAnimation.slideToTop,
        );
        return false;
      }
    } catch (e) {
      showToastWidget(
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            margin: EdgeInsets.all(20),
            child: Text(
              'Oda katiliminda hata oluştu',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        position: StyledToastPosition.top,
        duration: Duration(seconds: 2),
        context: context,
        animation: StyledToastAnimation.slideFromTop,
        reverseAnimation: StyledToastAnimation.slideToTop,
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

  /*@action
  Future<void> gameDocumentFuture() async {
    try {
      var a = await _firebaseDatabaseService.gameDocumentFuture(roomId: roomId);
      var data = a.data!.get("allNumbersList");
      allNumbersListDatabase = data;
    } catch (e) {
      print("gameDocumentFuture hata oluştu: $e");
    }
  }*/

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

  @observable
  int? randomNumber;


  @action
  Future<bool> takeNumber({required BuildContext context}) async {
    try {
      if (allNumbersListTable.isNotEmpty) {
         randomNumber = (allNumbersListDatabase..shuffle()).first;
        //print("randomNumber: $randomNumber");
        await _firebaseDatabaseService.takeNumber(
            roomId: roomId, number: randomNumber);

        AwesomeDialog(
          context: context,
          dialogType: DialogType.NO_HEADER,
          animType: AnimType.SCALE,
          autoHide: Duration(seconds: 5),
          dialogBackgroundColor: Colors.green,
          
          body: Container(
            height: 200,
            width: 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
            ),
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
  List<int> randomNumbersForCards = [];

  @observable
  Color randomColor = Colors.transparent;

  @observable
  Map<String, dynamic>? playerNumbersMap;

  @action
  Future<bool> createGameCard() async {
    try {
      randomNumbersForCards.clear();
      var a0 = [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
      ];
      var a1 = (a0..shuffle()).first;
      a0.remove(a1);
      var a2 = (a0..shuffle()).first;
      a0.remove(a2);
      var a3 = (a0..shuffle()).first;
      a0.remove(a3);
      var a4 = (a0..shuffle()).first;

      var b0 = [
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30,
      ];
      var b1 = (b0..shuffle()).first;
      b0.remove(b1);
      var b2 = (b0..shuffle()).first;
      b0.remove(b2);
      var b3 = (b0..shuffle()).first;
      b0.remove(b3);
      var b4 = (b0..shuffle()).first;

      var c0 = [
        31,
        32,
        33,
        34,
        35,
        36,
        37,
        38,
        39,
        40,
        41,
        42,
        43,
        44,
        45,
      ];
      var c1 = (c0..shuffle()).first;
      c0.remove(c1);
      var c2 = (c0..shuffle()).first;
      c0.remove(c2);
      var c3 = (c0..shuffle()).first;
      c0.remove(c3);
      var c4 = (c0..shuffle()).first;

      var d0 = [46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60];
      var d1 = (d0..shuffle()).first;
      d0.remove(d1);
      var d2 = (d0..shuffle()).first;
      d0.remove(d2);
      var d3 = (d0..shuffle()).first;
      d0.remove(d3);
      var d4 = (d0..shuffle()).first;

      var e0 = [
        61,
        62,
        63,
        64,
        65,
        66,
        67,
        68,
        69,
        70,
        71,
        72,
        73,
        74,
        75,
      ];
      var e1 = (e0..shuffle()).first;
      e0.remove(e1);
      var e2 = (e0..shuffle()).first;
      e0.remove(e2);
      var e3 = (e0..shuffle()).first;
      e0.remove(e3);
      var e4 = (e0..shuffle()).first;

      var f0 = [76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90];
      var f1 = (f0..shuffle()).first;
      f0.remove(f1);
      var f2 = (f0..shuffle()).first;
      f0.remove(f2);
      var f3 = (f0..shuffle()).first;
      f0.remove(f3);
      var f4 = (f0..shuffle()).first;

      var g0 = [91, 92, 93, 94, 95, 96, 97, 98, 99];
      var g1 = (g0..shuffle()).first;
      g0.remove(g1);
      var g2 = (g0..shuffle()).first;
      g0.remove(g2);
      var g3 = (g0..shuffle()).first;

      randomNumbersForCards.addAll(
        [
          a1,
          a2,
          a3,
          a4,
          b1,
          b2,
          b3,
          b4,
          c1,
          c2,
          c3,
          c4,
          d1,
          d2,
          d3,
          d4,
          e1,
          e2,
          e3,
          e4,
          f1,
          f2,
          f3,
          f4,
          g1,
          g2,
          g3,
        ],
      );

      randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

      print(randomNumbersForCards);

      playerNumbersMap = {
        a1.toString(): false,
        a3.toString(): false,
        b1.toString(): false,
        b3.toString(): false,
        c1.toString(): false,
        c3.toString(): false,
        d1.toString(): false,
        d3.toString(): false,
        e1.toString(): false,
        e3.toString(): false,
        f1.toString(): false,
        f3.toString(): false,
        g1.toString(): false,
        g3.toString(): false,
      };

      await _firebaseDatabaseService.createGameCard(
        roomId: roomId,
        userName: userName,
        playerRandomNumbersForCards: playerNumbersMap,
      );

      print(playerNumbersMap.toString());

      return true;
    } catch (e) {
      print("GameCard oluturmada hata oluştu: $e");
      return false;
    }
  }

  @observable
  bool isMyNumberShown = false;

  @observable
  bool isMyNumberChecked = false;

  @observable
  List<dynamic>? takenNumbersListDatabase = <dynamic>[];

  @observable
  List<dynamic>? playerNumbersListDatabase = <dynamic>[];

  @action
  Future<bool> checkMyNumber(BuildContext context, int number) async {
    print("checkMyNumber: $number");
    print(takenNumbersListDatabase);
    if (takenNumbersListDatabase!.contains(number)) {
      playerNumbersMap!.update(number.toString(), (value) => value = true);

      print("değiştirilen map" + playerNumbersMap.toString());

      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        autoHide: Duration(seconds: 1),
        title: 'Tebrikler',
        desc: 'Tebrikler, sayınız doğru',
      ).show();

      try {
        await _firebaseDatabaseService.setMyNumberTrue(
          roomId: roomId,
          userName: userName,
          playerNumbersMap: playerNumbersMap,
        );
        return true;
      } catch (e) {
        print("check my number hatası: $e");
        return false;
      }
    } else {
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

  @action
  getColor(index) {
    if (playerNumbersMap![randomNumbersForCards[index].toString()] == true) {
      return Colors.greenAccent[400];
    } else {
      return Colors.white.withOpacity(0.5);
    }
  }

  @observable
  String? gameCreator;

  @observable
  bool isFirstAnounced = false;

  @observable
  bool isSecondAnounced = false;

  @observable
  bool isThirdAnounced = false;

  @observable
  String? firstWinner;
  @observable
  String? secondWinner;
  @observable
  String? thirdWinner;

  @observable
  bool isGameFinished = false;

  @action
  Future<void> birinciCinkoIlanEt(BuildContext context) async {
    try {
      if (playerNumbersMap![randomNumbersForCards[0].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[6].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[12].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[18].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[24].toString()] == true ||
          playerNumbersMap![randomNumbersForCards[3].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[9].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[15].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[11].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[27].toString()] == true ||
          playerNumbersMap![randomNumbersForCards[5].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[11].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[17].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[23].toString()] == true) {
        String anouncedInformation = await _firebaseDatabaseService
            .setFirstWinner(roomId: roomId, userName: userName);
        if (anouncedInformation == "Ok") {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            autoHide: Duration(seconds: 1),
            title: 'Tebrikler',
            desc: 'Tebrikler, ilk çinkoyu yaptınız',
          ).show();
        } else if (anouncedInformation == "Already Announced") {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            autoHide: Duration(seconds: 1),
            title: 'Üzgünüm',
            desc: 'Üzgünüm, ilk çinkoyu zaten yapıldı.',
          ).show();
        }
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          animType: AnimType.BOTTOMSLIDE,
          autoHide: Duration(seconds: 1),
          title: 'Üzgünüm',
          desc: 'Üzgünüm, çinko yapamadınız',
        ).show();
      }
    } catch (e) {
      print("birinci hatası: $e");
    }
  }

  @action
  Future<void> ikinciCinkoIlanEt(BuildContext context) async {
    print("1,2  1 3  , 2 3");
    try {
      if (playerNumbersMap![randomNumbersForCards[0].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[6].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[12].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[18].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[24].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[3].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[9].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[15].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[11].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[27].toString()] == true ||
          playerNumbersMap![randomNumbersForCards[0].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[6].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[12].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[18].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[24].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[5].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[11].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[17].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[23].toString()] == true ||
          playerNumbersMap![randomNumbersForCards[3].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[9].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[15].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[11].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[27].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[5].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[11].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[17].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[23].toString()] == true) {
        String anouncedInformation = await _firebaseDatabaseService
            .setSecondWinner(roomId: roomId, userName: userName);
        if (anouncedInformation == "Ok") {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            autoHide: Duration(seconds: 1),
            title: 'Tebrikler',
            desc: 'Tebrikler, ikinci çinkoyu yaptınız',
          ).show();
        } else if (anouncedInformation == "Already Announced") {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            autoHide: Duration(seconds: 1),
            title: 'Üzgünüm',
            desc: 'Üzgünüm, ikinci çinkoyu zaten yapıldı.',
          ).show();
        }
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          animType: AnimType.BOTTOMSLIDE,
          autoHide: Duration(seconds: 1),
          title: 'Üzgünüm',
          desc: 'Üzgünüm, ikinci çinko yapamadınız',
        ).show();
      }
    } catch (e) {
      print("ikinci hatası: $e");
    }
  }

  @action
  Future<void> tomabalaIlanEt(BuildContext context) async {
    try {
      if (playerNumbersMap![randomNumbersForCards[0].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[6].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[12].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[18].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[24].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[3].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[9].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[15].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[11].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[27].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[5].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[11].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[17].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[23].toString()] == true) {
        String anouncedInformation = await _firebaseDatabaseService.setBingo(
            roomId: roomId, userName: userName);
        if (anouncedInformation == "Ok") {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            autoHide: Duration(seconds: 1),
            title: 'Tebrikler',
            desc: 'Tebrikler, bingoyu kazandınız',
          ).show();
        } else if (anouncedInformation == "Already Announced") {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            autoHide: Duration(seconds: 1),
            title: 'Üzgünüm',
            desc: 'Üzgünüm,  bingo zaten yapıldı.',
          ).show();
        }
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          animType: AnimType.BOTTOMSLIDE,
          autoHide: Duration(seconds: 1),
          title: 'Üzgünüm',
          desc: 'Üzgünüm, bingo yapamadınız',
        ).show();
      }
    } catch (e) {
      print("bingo hatası: $e");
    }
  }

  @observable
  int playersNumber = 1;

  @observable
  String? roomCreator;
}
