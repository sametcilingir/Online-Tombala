import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../models/message/message_model.dart';
import '../models/player/player_model.dart';
import '../models/room/room_model.dart';
import '../../utils/services/firebase_database_service.dart';

import '../../utils/locator/locator.dart';

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

      var playerModelAndRoomModel = await _firebaseDatabaseService.joinRoom(
          roomModel.roomCode!, roomModel.roomCreator!);
      playerModel = playerModelAndRoomModel[0];
      //roomModeli burda oluşturduğumuz için  almaya gerek yok
      //roomModel = playerModelAndRoomModel[1];

      if (playerModel.userId != null) {
        return true;
      } else {
        return false;
      }
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
  @observable
  ReactionDisposer? takenNumberReaction;
  @action
  roomStream() {
    try {
      /* _firebaseDatabaseService.roomStream(roomModel).forEach((element) {
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
      });*/

      _firebaseDatabaseService.roomStream(roomModel).listen((event) {
        roomModel = RoomModel.fromJson(event.data());

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

        /* print("tekrar sayısı");
        if (!takenNumbersListFromDatabase.contains(roomModel.roomTakenNumber)) {
          takenNumbersListFromDatabase.add(roomModel.roomTakenNumber!);
          takenNumber = roomModel.roomTakenNumber!;
        }*/
      });

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

  @action
  Future<bool> joinRoom() async {
    try {
      var playerModelAndRoomModel = await _firebaseDatabaseService.joinRoom(
          roomModel.roomCode!, userName!);
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

      await _firebaseDatabaseService.updateGame(roomModel);
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
      await _firebaseDatabaseService.updateGame(roomModel);

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
  TextEditingController? messageControllerWaiting = TextEditingController();

  @observable
  GlobalKey<FormState> formKeyMessageGameCard = GlobalKey<FormState>();

  @observable
  TextEditingController? messageControllerGameCard = TextEditingController();

  @observable
  GlobalKey<FormState> formKeyMessageGameTable = GlobalKey<FormState>();

  @observable
  TextEditingController? messageControllerGameTable = TextEditingController();

  @observable
  ObservableList<MessageModel>? messageList = ObservableList<MessageModel>();

  @action
  SnackBar snackbar(Color color, String message) {
    return SnackBar(
      dismissDirection: DismissDirection.horizontal,
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      content: Text(message),
    );
  }

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
        messageSenderName: playerModel.userName!.isEmpty
            ? roomModel.roomCreator
            : playerModel.userName,
        messageSentTime: Timestamp.now().toDate(),
      );
      await _firebaseDatabaseService.sendMessage(roomModel, messageModel);
      return true;
    } catch (e) {
      print("mesaj göndermede hata oluştu: $e");
      return false;
    }
  }

  /* @action
  dispose() {
    userName = null;
    roomModel = RoomModel();
    playersList = ObservableList<PlayerModel>();
    playerModel = PlayerModel();
    roomCode = null;
    takenNumbersList = [];
    messageList = ObservableList<MessageModel>();
    cardNumbersList = [];
  }*/

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
    takenNumbersMap = {for (var e in cardNumbersList) e: false};
    print("takenNumbersMap: $takenNumbersMap");
    print("sıralı: $cardNumbersList");
  }

  @observable
  GlobalKey<ScaffoldMessengerState> gameCardScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @observable
  GlobalKey<ScaffoldMessengerState> gameTableScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @observable
  ReactionDisposer? firstWinnerReaction;
  @observable
  ReactionDisposer? secondWinnerReaction;
  @observable
  ReactionDisposer? thirdWinnerReaction;

  @action
  Future<bool> winnerControl(int i) async {
    print(cardNumbersList);
    print(takenNumbersMap);

    if (i == 1 &&
        roomModel.roomFirstWinner == "" &&
        takenNumbersMap[cardNumbersList[0]]! &&
        takenNumbersMap[cardNumbersList[3]]! &&
        takenNumbersMap[cardNumbersList[6]]! &&
        takenNumbersMap[cardNumbersList[9]]! &&
        takenNumbersMap[cardNumbersList[12]]!) {
      //first line
      await setWinner(1);
      return true;
    } else if (i == 1 &&
        roomModel.roomFirstWinner == "" &&
        takenNumbersMap[cardNumbersList[1]]! &&
        takenNumbersMap[cardNumbersList[4]]! &&
        takenNumbersMap[cardNumbersList[7]]! &&
        takenNumbersMap[cardNumbersList[10]]! &&
        takenNumbersMap[cardNumbersList[13]]!) {
      //second line
      await setWinner(1);
      return true;
    } else if (i == 1 &&
        roomModel.roomFirstWinner == "" &&
        takenNumbersMap[cardNumbersList[2]]! &&
        takenNumbersMap[cardNumbersList[5]]! &&
        takenNumbersMap[cardNumbersList[8]]! &&
        takenNumbersMap[cardNumbersList[11]]!) {
      //third line
      await setWinner(1);
      return true;
    } else if (i == 2 &&
        roomModel.roomSecondWinner == "" &&
        takenNumbersMap[cardNumbersList[0]]! &&
        takenNumbersMap[cardNumbersList[3]]! &&
        takenNumbersMap[cardNumbersList[6]]! &&
        takenNumbersMap[cardNumbersList[9]]! &&
        takenNumbersMap[cardNumbersList[12]]! &&
        takenNumbersMap[cardNumbersList[1]]! &&
        takenNumbersMap[cardNumbersList[4]]! &&
        takenNumbersMap[cardNumbersList[7]]! &&
        takenNumbersMap[cardNumbersList[10]]! &&
        takenNumbersMap[cardNumbersList[13]]!) {
      // first and second line
      await setWinner(2);
      return true;
    } else if (i == 2 &&
        roomModel.roomSecondWinner == "" &&
        takenNumbersMap[cardNumbersList[0]]! &&
        takenNumbersMap[cardNumbersList[3]]! &&
        takenNumbersMap[cardNumbersList[6]]! &&
        takenNumbersMap[cardNumbersList[9]]! &&
        takenNumbersMap[cardNumbersList[12]]! &&
        takenNumbersMap[cardNumbersList[2]]! &&
        takenNumbersMap[cardNumbersList[5]]! &&
        takenNumbersMap[cardNumbersList[8]]! &&
        takenNumbersMap[cardNumbersList[11]]!) {
      // first and third line
      await setWinner(2);
      return true;
    } else if (i == 2 &&
        roomModel.roomSecondWinner == "" &&
        takenNumbersMap[cardNumbersList[1]]! &&
        takenNumbersMap[cardNumbersList[4]]! &&
        takenNumbersMap[cardNumbersList[7]]! &&
        takenNumbersMap[cardNumbersList[10]]! &&
        takenNumbersMap[cardNumbersList[13]]! &&
        takenNumbersMap[cardNumbersList[2]]! &&
        takenNumbersMap[cardNumbersList[5]]! &&
        takenNumbersMap[cardNumbersList[8]]! &&
        takenNumbersMap[cardNumbersList[11]]!) {
      // second and third line
      await setWinner(2);
      return true;
    } else if (i == 3 &&
        roomModel.roomThirdWinner == "" &&
        takenNumbersMap[cardNumbersList[0]]! &&
        takenNumbersMap[cardNumbersList[3]]! &&
        takenNumbersMap[cardNumbersList[6]]! &&
        takenNumbersMap[cardNumbersList[9]]! &&
        takenNumbersMap[cardNumbersList[12]]! &&
        takenNumbersMap[cardNumbersList[1]]! &&
        takenNumbersMap[cardNumbersList[4]]! &&
        takenNumbersMap[cardNumbersList[7]]! &&
        takenNumbersMap[cardNumbersList[10]]! &&
        takenNumbersMap[cardNumbersList[13]]! &&
        takenNumbersMap[cardNumbersList[2]]! &&
        takenNumbersMap[cardNumbersList[5]]! &&
        takenNumbersMap[cardNumbersList[8]]! &&
        takenNumbersMap[cardNumbersList[11]]!) {
      // triple line
      await setWinner(3);
      return true;
    }
    return false;
  }

  @action
  Future<bool> setWinner(int i) async {
    try {
      switch (i) {
        case 1:
          roomModel.roomFirstWinner = userName;
          break;

        case 2:
          roomModel.roomSecondWinner = userName;
          break;

        case 3:
          roomModel.roomThirdWinner = userName;
          break;
        default:
      }

      await _firebaseDatabaseService.updateGame(roomModel);

      return true;
    } catch (e) {
      print("setWinner hata oluştu: $e");
      return false;
    }
  }

  @observable
  bool isGameAutoTakeNumber = false;

  @action
  Future<bool> deleteGame() async {
    try {
      await _firebaseDatabaseService.deleteGame(roomModel);

      return true;
    } catch (e) {
      print("delete game hata oluştu: $e");
      return false;
    }
  }
}
