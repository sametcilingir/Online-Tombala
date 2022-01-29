import 'dart:math';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:tombala/utils/theme/app_theme.dart';
import '../models/message_model/message_model.dart';
import '../models/player_model/player_model.dart';
import '../models/room_model/room_model.dart';
import '../../utils/services/firebase_database_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/locator/locator.dart';

part 'view_model.g.dart';

enum ViewState { Idle, Busy }

class ViewModel = _ViewModelBase with _$ViewModel;

abstract class _ViewModelBase with Store {

  
  final FirebaseDatabaseService _firebaseDatabaseService =
      locator<FirebaseDatabaseService>();

  @observable
  bool isDarkModel = true;

  @computed
  ThemeData get appTheme => AppTheme().theme;

  @observable
  bool isENLocal = false;

  @computed
  Locale get locale => isENLocal
      ? AppLocalizations.supportedLocales.first
      : AppLocalizations.supportedLocales.last;

  @observable
  ViewState viewState = ViewState.Idle;

  @observable
  GlobalKey<FormState> formKeyUserName = GlobalKey<FormState>();

  @observable
  GlobalKey<FormState> formKeyJoin = GlobalKey<FormState>();

  @observable
  PageController homePageController = PageController(initialPage: 0);

  @observable
  GlobalKey<ScaffoldMessengerState> homeScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @observable
  ReactionDisposer? startGameReaction;

  @observable
  RoomModel roomModel = RoomModel(
    roomFirstWinner: "",
    roomSecondWinner: "",
    roomThirdWinner: "",
    roomTakenNumber: 0,
    roomStatus: "wait",
    roomCode: "",
    roomCreator: "",
    roomId: "",
  );

  @observable
  PlayerModel playerModel = PlayerModel(
    userId: "",
    userName: "",
    userStatus: false,
  );

  @action
  Future<bool> createRoom() async {
    try {
      viewState = ViewState.Busy;
      reInit();
      //creating random room code
      roomModel.roomCode = Random().nextInt(100000).toString();
      var newUserName = isENLocal
          ? "Game Creator - "
          : "Oyun Kurucu - " + playerModel.userName.toString();
      playerModel.userName = newUserName;
      roomModel.roomCreator = playerModel.userName;
      //getting room Id
      roomModel.roomId = await _firebaseDatabaseService.createRoom(roomModel);

      bool isJoined = await joinRoom();

      return isJoined;
    } catch (e) {
      print("sorun oda oluşturmada" + e.toString());
      return false;
    } finally {
      viewState = ViewState.Idle;
    }
  }

  @observable
  ObservableList<PlayerModel>? playersList = ObservableList<PlayerModel>();

  @action
  playersStream() {
    _firebaseDatabaseService.playersStream(roomModel).forEach((event) {
      playersList = event.docs
          .map((e) => PlayerModel.fromJson(e.data()))
          .toList()
          .asObservable();
    });
  }

  @observable
  Map<int, bool> takenNumbersMap = <int, bool>{};

  @observable
  ReactionDisposer? takenNumberReaction;

  @action
  roomStream() {
    _firebaseDatabaseService.roomStream(roomModel).listen((event) {
      roomModel = RoomModel.fromJson(event.data());
      //taken number event
      if (!takenNumbersListFromDatabase.contains(roomModel.roomTakenNumber)) {
        takenNumber = roomModel.roomTakenNumber!;
        takenNumbersListFromDatabase.add(roomModel.roomTakenNumber!);
      }
    });
  }

  @action
  Future<void> setPlayerStatus(bool playerStatus) async {
    playerModel.userStatus = playerStatus;
    await _firebaseDatabaseService.setPlayerStatus(roomModel, playerModel);
  }

  @action
  Future<bool> joinRoom() async {
    try {
      viewState = ViewState.Busy;

      if (roomModel.roomCreator != playerModel.userName) {
        reInit();
      }

      var playerModelAndRoomModel = await _firebaseDatabaseService.joinRoom(
          roomModel.roomCode!, playerModel.userName!);
      //setting message model username
      messageModel.messageSenderName = playerModel.userName;
      //setting player model
      playerModel = playerModelAndRoomModel[0];
      //setting room model
      roomModel = playerModelAndRoomModel[1];
      if (playerModel.userId != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      viewState = ViewState.Idle;
    }
  }

  @action
  Future<bool> startGame() async {
    try {
      viewState = ViewState.Busy;
      roomModel.roomStatus = "started";
      await _firebaseDatabaseService.updateGame(roomModel);
      return true;
    } catch (e) {
      return false;
    } finally {
      viewState = ViewState.Idle;
    }
  }

  @observable
  List<int> allNumbersList = List<int>.generate(99, (i) => i + 1);

  @observable
  int takenNumber = 0;

  //for game creator
  @observable
  List<int> takenNumbersList = [];

  //for players
  @observable
  List<int> takenNumbersListFromDatabase = [];

  @action
  Future<bool> takeNumber() async {
    try {
      takenNumber = (allNumbersList..shuffle()).first;
      allNumbersList.remove(takenNumber);
      takenNumbersList.add(takenNumber);
      roomModel.roomTakenNumber = takenNumber;
      await _firebaseDatabaseService.updateGame(roomModel);

      return true;
    } catch (e) {
      return false;
    }
  }

  @observable
  bool? isChatOpen = false;

  @observable
  GlobalKey<FormState> formKeyMessageWaiting = GlobalKey<FormState>();

  @observable
  TextEditingController? messageControllerWaiting = TextEditingController();

  @observable
  GlobalKey<FormState> formKeyMessageGameCard = GlobalKey<FormState>();

  @observable
  TextEditingController? messageControllerGameCard = TextEditingController();

  @observable
  ObservableList<MessageModel>? messageList = ObservableList<MessageModel>();

  @action
  messageStream() {
    _firebaseDatabaseService.messageStream(roomModel).forEach((event) {
      messageList = event.docs
          .map((e) => MessageModel.fromJson(e.data()))
          .toList()
          .asObservable();
    });
  }

  @observable
  MessageModel messageModel = MessageModel(
    messageSenderName: "",
    messageText: "",
  );

  @action
  Future<bool> sendMessage() async {
    try {
      await _firebaseDatabaseService.sendMessage(roomModel, messageModel);
      return true;
    } catch (e) {
      return false;
    }
  }

  @observable
  List<int> cardNumbersList = [];

  @observable
  Color randomColor = Colors.transparent;

  @observable
  List<int>? rangeOf1and15Numbers;
  @observable
  List<int>? rangeOf16and30Numbers;
  @observable
  List<int>? rangeOf31and45Numbers;
  @observable
  List<int>? rangeOf46and60Numbers;
  @observable
  List<int>? rangeOf61and75Numbers;
  @observable
  List<int>? rangeOf76and90Numbers;
  @observable
  List<int>? rangeOf91and99Numbers;

  @action
  createGameCard() {
    randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

    rangeOf1and15Numbers = allNumbersList.sublist(0, 15)..shuffle();
    rangeOf16and30Numbers = allNumbersList.sublist(15, 30)..shuffle();
    rangeOf31and45Numbers = allNumbersList.sublist(30, 45)..shuffle();
    rangeOf46and60Numbers = allNumbersList.sublist(45, 60)..shuffle();
    rangeOf61and75Numbers = allNumbersList.sublist(60, 75)..shuffle();
    rangeOf76and90Numbers = allNumbersList.sublist(75, 90)..shuffle();
    rangeOf91and99Numbers = allNumbersList.sublist(90, 99)..shuffle();

    for (var i = 0; i < 2; i++) {
      cardNumbersList.add(rangeOf1and15Numbers![i]);
      cardNumbersList.add(rangeOf16and30Numbers![i]);
      cardNumbersList.add(rangeOf31and45Numbers![i]);
      cardNumbersList.add(rangeOf46and60Numbers![i]);
      cardNumbersList.add(rangeOf61and75Numbers![i]);
      cardNumbersList.add(rangeOf76and90Numbers![i]);
      cardNumbersList.add(rangeOf91and99Numbers![i]);
    }

    cardNumbersList.sort();
    takenNumbersMap = {for (var e in cardNumbersList) e: false};
  }

  @observable
  GlobalKey<ScaffoldMessengerState> gameCardScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @observable
  ReactionDisposer? firstWinnerReaction;
  @observable
  ReactionDisposer? secondWinnerReaction;
  @observable
  ReactionDisposer? thirdWinnerReaction;

  @action
  Future<bool> winnerControl(int i) async {
    if (i == 1 &&
        roomModel.roomFirstWinner == "" &&
        takenNumbersMap[cardNumbersList[0]]! &&
        takenNumbersMap[cardNumbersList[3]]! &&
        takenNumbersMap[cardNumbersList[6]]! &&
        takenNumbersMap[cardNumbersList[9]]! &&
        takenNumbersMap[cardNumbersList[12]]!) {
      await setWinner(1);
      return true;
    } else if (i == 1 &&
        roomModel.roomFirstWinner == "" &&
        takenNumbersMap[cardNumbersList[1]]! &&
        takenNumbersMap[cardNumbersList[4]]! &&
        takenNumbersMap[cardNumbersList[7]]! &&
        takenNumbersMap[cardNumbersList[10]]! &&
        takenNumbersMap[cardNumbersList[13]]!) {
      await setWinner(1);
      return true;
    } else if (i == 1 &&
        roomModel.roomFirstWinner == "" &&
        takenNumbersMap[cardNumbersList[2]]! &&
        takenNumbersMap[cardNumbersList[5]]! &&
        takenNumbersMap[cardNumbersList[8]]! &&
        takenNumbersMap[cardNumbersList[11]]!) {
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
          roomModel.roomFirstWinner = playerModel.userName;
          break;

        case 2:
          roomModel.roomSecondWinner = playerModel.userName;
          break;

        case 3:
          roomModel.roomThirdWinner = playerModel.userName;
          roomModel.roomStatus = "finished";
          break;
        default:
      }

      await _firebaseDatabaseService.updateGame(roomModel);

      return true;
    } catch (e) {
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
      return false;
    }
  }

  @action
  reInit() {
    /* roomModel = RoomModel(
      roomFirstWinner: "",
      roomSecondWinner: "",
      roomThirdWinner: "",
      roomTakenNumber: 0,
      roomStatus: "wait",
      roomCode: "",
      roomCreator: "",
      roomId: "",
    );*/
    /*  playerModel = PlayerModel(
      userId: "",
      userName: "",
      userStatus: false,
    );*/
    roomModel.roomFirstWinner = "";
    roomModel.roomSecondWinner = "";
    roomModel.roomThirdWinner = "";
    roomModel.roomTakenNumber = 0;
    roomModel.roomStatus = "wait";
    roomModel.roomCreator = "";
    roomModel.roomId = "";
    playerModel.userId = "";
    playerModel.userStatus = false;
    playersList = ObservableList<PlayerModel>();
    takenNumbersMap = {};
    takenNumber = 0;
    takenNumbersList = [];
    takenNumbersListFromDatabase = [];
    isChatOpen = false;
    messageList = ObservableList<MessageModel>();
    messageModel = MessageModel(
      messageSenderName: "",
      messageText: "",
    );
    cardNumbersList = [];
    isGameAutoTakeNumber = false;
  }
}
