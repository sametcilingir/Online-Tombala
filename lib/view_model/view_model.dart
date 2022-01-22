import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/model/message_model.dart';
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
  String? userName = "";

  @observable
  RoomModel roomModel = RoomModel(
    roomFirstWinner: "",
    roomSecondWinner: "",
    roomThirdWinner: "",
    roomTakenNumber: 0,
    roomStatus: "wait",
  );

  @action
  Future<bool> createRoom() async {
    try {
      roomModel.roomCode = Random().nextInt(100000).toString();
      var newUserName = "Oyun kurucu - " + userName.toString();
      userName = newUserName;
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

        /* playersList!.forEach((element) {
          print(element.userName);
        });*/
      });
    } catch (e) {
      print("Oda kullanici bulma hata oluştu: $e");
    }
  }

  @observable
  Map<int, bool> takenNumbersMap = <int, bool>{};

  @action
  roomStream() {
    try {
      _firebaseDatabaseService.roomStream(roomModel).forEach((element) {
        roomModel = RoomModel.fromJson(element.data());
        print("tekrar sayısı üst");

        if (!takenNumbersListFromDatabase.contains(roomModel.roomTakenNumber)) {
          print("tekrar sayısı listeye dahil deği lise");

          takenNumber = roomModel.roomTakenNumber!;
          takenNumbersListFromDatabase.add(roomModel.roomTakenNumber!);
          
          //takenNumbersMap[takenNumber] = false;
          //print(takenNumbersMap);
          //takenNumbersMap.update(number.toString(), (value) => value = true);

          print("taken number from database: ${takenNumber}");
          print(
              "taken number from takenNumbersListFromDatabase: ${takenNumbersListFromDatabase}");
        }
      });

      /* _firebaseDatabaseService.roomStream(roomModel).listen((event) {
        roomModel = RoomModel.fromJson(event.data());
        print("tekrar sayısı");
        if (!takenNumbersListFromDatabase.contains(roomModel.roomTakenNumber)) {
          takenNumbersListFromDatabase.add(roomModel.roomTakenNumber!);
          takenNumber = roomModel.roomTakenNumber!;
        }
      });*/

      //roomModel = RoomModel.fromJson(event.docChanges.first.doc.data());

    } catch (e) {
      print("Oda döküman hata oluştu: $e");
    }
  }

  @observable
  PlayerModel playerModel = PlayerModel(
    userId: "",
    userName: "",
    userStatus: false,
  );

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
  String? roomCode = "";

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
  List<int> numbersList = List<int>.generate(99, (i) => i + 1);
  @observable
  int takenNumber = 0;
  @observable
  List<int> takenNumbersList = [];

  @observable
  List<int> takenNumbersListFromDatabase = [];

  @action
  Future<bool> takeNumber() async {
    try {
      takenNumber = (numbersList..shuffle()).first;
      numbersList.remove(takenNumber);
      takenNumbersList.add(takenNumber);
      roomModel.roomTakenNumber = takenNumber;
      await _firebaseDatabaseService.takeNumber(roomModel);

      return true;
    } catch (e) {
      print("Taş çekmede hata oluştu: $e");
      return false;
    }
  }

  @observable
  bool? isChatOpen = false;

  @observable
  String? singleMessage = "";

  @observable
  GlobalKey<FormState> formKeyMessageWaiting = GlobalKey<FormState>();

  @observable
  TextEditingController? messageController = TextEditingController();

  @observable
  ObservableList<MessageModel>? messageList = ObservableList<MessageModel>();

  @action
  messageStream() {
    try {
      _firebaseDatabaseService.messageStream(roomModel).forEach((event) {
        messageList = event.docs
            .map((e) => MessageModel.fromJson(e.data()))
            .toList()
            .asObservable();
      });
    } catch (e) {
      print("Mesaj stream  hata oluştu: $e");
    }
  }

  @action
  Future<bool> sendMessage() async {
    try {
      MessageModel messageModel = MessageModel(
        messageText: singleMessage,
        messageSenderName: playerModel.userName,
        messageSentTime: Timestamp.now().toDate(),
      );
      await _firebaseDatabaseService.sendMessage(roomModel, messageModel);
      return true;
    } catch (e) {
      print("mesaj göndermede hata oluştu: $e");
      return false;
    }
  }

  @action
  dispose() {
    userName = null;
    roomModel = RoomModel();
    playersList = ObservableList<PlayerModel>();
    playerModel = PlayerModel();
    roomCode = null;
    takenNumbersList = [];
    messageList = ObservableList<MessageModel>();
    cardNumbersList = [];
  }

  @observable
  List<int> cardNumbersList = [];

  @observable
  Color randomColor = Colors.transparent;

  @action
  createGameCard() {
    randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    print("randomColor: $randomColor");

    if (cardNumbersList.isNotEmpty) {
      cardNumbersList.clear();
    }

    final rangeOf1and15Numbers = List<int>.generate(15, (i) => i + 1);
    print("rangeOf1and15Numbers: $rangeOf1and15Numbers");
    final rangeOf16and30Numbers = List<int>.generate(15, (i) => i + 16);
    print("rangeOf16and30Numbers: $rangeOf16and30Numbers");
    final rangeOf31and45Numbers = List<int>.generate(15, (i) => i + 31);
    print("rangeOf31and45Numbers: $rangeOf31and45Numbers");
    final rangeOf46and60Numbers = List<int>.generate(15, (i) => i + 46);
    print("rangeOf46and60Numbers: $rangeOf46and60Numbers");
    final rangeOf61and75Numbers = List<int>.generate(15, (i) => i + 61);
    print("rangeOf61and75Numbers: $rangeOf61and75Numbers");
    final rangeOf76and90Numbers = List<int>.generate(15, (i) => i + 76);
    print("rangeOf76and90Numbers: $rangeOf76and90Numbers");
    final rangeOf91and99Numbers = List<int>.generate(9, (i) => i + 91);
    print("rangeOf91and99Numbers: $rangeOf91and99Numbers");

    for (var i = 0; i < 2; i++) {
      var randomNumber = (rangeOf1and15Numbers..shuffle()).first;
      cardNumbersList.add(randomNumber);
      rangeOf1and15Numbers.remove(randomNumber);
      var randomNumber2 = (rangeOf16and30Numbers..shuffle()).first;
      cardNumbersList.add(randomNumber2);
      rangeOf16and30Numbers.remove(randomNumber2);
      var randomNumber3 = (rangeOf31and45Numbers..shuffle()).first;
      cardNumbersList.add(randomNumber3);
      rangeOf31and45Numbers.remove(randomNumber3);
      var randomNumber4 = (rangeOf46and60Numbers..shuffle()).first;
      cardNumbersList.add(randomNumber4);
      rangeOf46and60Numbers.remove(randomNumber4);
      var randomNumber5 = (rangeOf61and75Numbers..shuffle()).first;
      cardNumbersList.add(randomNumber5);
      rangeOf61and75Numbers.remove(randomNumber5);
      var randomNumber6 = (rangeOf76and90Numbers..shuffle()).first;
      cardNumbersList.add(randomNumber6);
      rangeOf76and90Numbers.remove(randomNumber6);
      var randomNumber7 = (rangeOf91and99Numbers..shuffle()).first;
      cardNumbersList.add(randomNumber7);
      rangeOf91and99Numbers.remove(randomNumber7);
    }
    print("cardNumbersList: $cardNumbersList");
    //numaraları sıralıyoruz
    cardNumbersList.sort();
    takenNumbersMap = Map<int, bool>.fromIterable(
      cardNumbersList,
      key: (e) => e,
      value: (e) => false,
    );
    print("takenNumbersMap: $takenNumbersMap");
    print("sıralı: $cardNumbersList");
  }

  @observable
  bool firstWinnerAnnouncement = false;
  @observable
  bool secondWinnerAnnouncement = false;
  @observable
  bool thirdWinnerAnnouncement = false;

}
