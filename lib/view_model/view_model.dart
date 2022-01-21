import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/model/player_model.dart';
import 'package:tombala/model/room_model.dart';
import 'package:tombala/services/firebase_database_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

part 'view_model.g.dart';

class ViewModel = _ViewModelBase with _$ViewModel;

abstract class _ViewModelBase with Store {
  final FirebaseDatabaseService _firebaseDatabaseService =
      locator<FirebaseDatabaseService>();

  @observable
  GlobalKey<FormState> formKeyUserName = GlobalKey<FormState>();

  @observable
  GlobalKey<FormState> formKeyJoin = GlobalKey<FormState>();

  @observable
  PageController pageController = PageController(initialPage: 0);

  @observable
  String? userName;

  @observable
  RoomModel roomModel = RoomModel();

  @action
  Future<bool> createRoom() async {
    try {
      roomModel.roomCode = Random().nextInt(100000).toString();
      roomModel.roomCreator = userName;
      roomModel.roomId = await _firebaseDatabaseService.createRoom(roomModel);
      return true;
    } catch (e) {
      print("Oda oluşturmada hata oluştu: $e");
      return false;
    }
  }

  @observable
  late ObservableList<PlayerModel>? playersList = ObservableList<PlayerModel>();

  @action
  playersStream() {
    try {
      _firebaseDatabaseService.playersStream(roomModel).forEach((event) {
        playersList = event.docs
            .map((e) => PlayerModel.fromJson(e.data()))
            .toList()
            .asObservable();

        playersList!.forEach((element) {
          print(element.userName);
        });
      });
    } catch (e) {
      print("Oda kullanici bulma hata oluştu: $e");
    }
  }

  @action
  roomStream() {
    try {
      _firebaseDatabaseService.roomStream(roomModel).forEach((element) {
        roomModel = RoomModel.fromJson(element.data());
      });

      //roomModel = RoomModel.fromJson(event.docChanges.first.doc.data());

    } catch (e) {
      print("Oda döküman hata oluştu: $e");
    }
  }

  @observable
  PlayerModel playerModel = PlayerModel();

  @action
  Future<void> setPlayerStatus(bool playerStatus) async {
    try {
      playerModel.userStatus = playerStatus;
      await _firebaseDatabaseService.setPlayerStatus(roomModel, playerModel);
    } catch (e) {
      print("setPlayerStatus hata oluştu: $e");
    }
  }

  @observable
  String? roomCode;

  @action
  Future<bool> joinRoom() async {
    try {
      var playerModelAndRoomModel =
          await _firebaseDatabaseService.joinRoom(roomCode!, userName!);
      playerModel = playerModelAndRoomModel[0];
      //roomModeli burada set ediyoruz
      roomModel = playerModelAndRoomModel[1];
      if (playerModel.userId != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Odaya katilimda hata oluştu: $e");
      return false;
    }
  }

  @action
  Future<bool> startGame() async {
    try {
      roomModel.roomStatus = "started";

      await _firebaseDatabaseService.startGame(roomModel);
      return true;
    } catch (e) {
      print("Oyun başlatmada hata oluştu: $e");
      return false;
    }
  }

  /* @action
  Future<bool> deleteGame() async {
    try {
      await _firebaseDatabaseService.deleteGame(roomId: roomId);
      return true;
    } catch (e) {
      print("Oyunu silmede hata oluştu: $e");
      return false;
    }
  }*/

  @observable
  var numbersList = List<int>.generate(99, (i) => i + 1);
  @observable
  int takenNumber = 0;
  @observable
  List<int> takenNumbers = [];

  @action
  Future<bool> takeNumber() async {
    try {
      takenNumber = (numbersList..shuffle()).first;
      numbersList.remove(takenNumber);
      takenNumbers.add(takenNumber);
      await _firebaseDatabaseService.takeNumber(roomModel);

      return true;
    } catch (e) {
      print("Taş çekmede hata oluştu: $e");
      return false;
    }
  }

  @observable
  List<int> cardNumbers = [];

  @observable
  Color randomColor = Colors.transparent;

  @action
  Future<bool> createGameCard() async {
    try {
      randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

      cardNumbers.clear();

      final rangeOf1and15Numbers = List<int>.generate(15, (i) => i + 1);
      final rangeOf16and30Numbers = List<int>.generate(15, (i) => i + 16);
      final rangeOf31and45Numbers = List<int>.generate(15, (i) => i + 31);
      final rangeOf46and60Numbers = List<int>.generate(15, (i) => i + 46);
      final rangeOf61and75Numbers = List<int>.generate(15, (i) => i + 61);
      final rangeOf76and90Numbers = List<int>.generate(15, (i) => i + 76);
      final rangeOf91and99Numbers = List<int>.generate(9, (i) => i + 91);

      for (var i = 0; i < 1; i++) {
        var randomNumber = (rangeOf1and15Numbers..shuffle()).first;
        cardNumbers.add(randomNumber);
        rangeOf1and15Numbers.remove(randomNumber);
        var randomNumber2 = (rangeOf16and30Numbers..shuffle()).first;
        cardNumbers.add(randomNumber2);
        rangeOf16and30Numbers.remove(randomNumber2);
        var randomNumber3 = (rangeOf31and45Numbers..shuffle()).first;
        cardNumbers.add(randomNumber3);
        rangeOf31and45Numbers.remove(randomNumber3);
        var randomNumber4 = (rangeOf46and60Numbers..shuffle()).first;
        cardNumbers.add(randomNumber4);
        rangeOf46and60Numbers.remove(randomNumber4);
        var randomNumber5 = (rangeOf61and75Numbers..shuffle()).first;
        cardNumbers.add(randomNumber5);
        rangeOf61and75Numbers.remove(randomNumber5);
        var randomNumber6 = (rangeOf76and90Numbers..shuffle()).first;
        cardNumbers.add(randomNumber6);
        rangeOf76and90Numbers.remove(randomNumber6);
        var randomNumber7 = (rangeOf91and99Numbers..shuffle()).first;
        cardNumbers.add(randomNumber7);
        rangeOf91and99Numbers.remove(randomNumber7);
      }
      //numaraları sıralıyoruz
      cardNumbers.sort();

      return true;
    } catch (e) {
      print("GameCard oluturmada hata oluştu: $e");
      return false;
    }
  }

  @observable
  bool isMyNumberTaken = false;

  @action
  Future<bool> checkMyNumber(int number) async {
    if (takenNumbers.contains(number)) {
     /* AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        autoHide: Duration(seconds: 1),
        title: 'Tebrikler',
        desc: 'Tebrikler, sayınız doğru',
      ).show();*/

      return true;
    } else {
     /* AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        autoHide: Duration(seconds: 1),
        title: 'Üzgünüm',
        desc: 'Üzgünüm, sayınız yanlış',
      ).show();*/
      return false;
    }
  }

  /* @observable
  Color? setActiveColor = Colors.white.withOpacity(0.5);

  @action
  Color? getColor(index) {
    if (playerNumbersMap![randomNumbersForCards[index].toString()] == true) {
      setActiveColor = Colors.white.withOpacity(0.5);

      return setActiveColor;
    } else {
      setActiveColor = Colors.greenAccent[400];

      return setActiveColor;
    }
  }*/

//  Çinko kontrol etme yeri tam bir fuckfest
//
/*
  @action
  Future<void> birinciCinkoIlanEt(BuildContext context) async {
    try {
      if (playerNumbersMap![randomNumbersForCards[0].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[6].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[12].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[18].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[24].toString()] == true ||
          playerNumbersMap![randomNumbersForCards[4].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[10].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[16].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[22].toString()] == true ||
          playerNumbersMap![randomNumbersForCards[2].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[8].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[14].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[20].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[26].toString()] == true) {
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
          desc: 'Üzgünüm, 1. çinko yapamadınız',
        ).show();
      }
    } catch (e) {
      print("birinci hatası: $e");
    }
  }

  @action
  Future<void> ikinciCinkoIlanEt(BuildContext context) async {
    //print("1,2  1 3  , 2 3");
    print(playerNumbersMap);
    print(randomNumbersForCards);
    try {
      if (playerNumbersMap![randomNumbersForCards[0].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[6].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[12].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[18].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[24].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[4].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[10].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[16].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[22].toString()] == true ||
          playerNumbersMap![randomNumbersForCards[0].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[6].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[12].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[18].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[24].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[2].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[8].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[14].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[20].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[26].toString()] == true ||
          playerNumbersMap![randomNumbersForCards[4].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[10].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[16].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[22].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[2].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[8].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[14].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[20].toString()] == true &&
              playerNumbersMap![randomNumbersForCards[26].toString()] == true) {
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
          playerNumbersMap![randomNumbersForCards[4].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[10].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[16].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[22].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[2].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[8].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[14].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[20].toString()] == true &&
          playerNumbersMap![randomNumbersForCards[26].toString()] == true) {
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
*/
}
