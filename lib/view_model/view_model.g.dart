// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ViewModel on _ViewModelBase, Store {
  final _$formKeyUserNameAtom = Atom(name: '_ViewModelBase.formKeyUserName');

  @override
  GlobalKey<FormState> get formKeyUserName {
    _$formKeyUserNameAtom.reportRead();
    return super.formKeyUserName;
  }

  @override
  set formKeyUserName(GlobalKey<FormState> value) {
    _$formKeyUserNameAtom.reportWrite(value, super.formKeyUserName, () {
      super.formKeyUserName = value;
    });
  }

  final _$formKeyJoinAtom = Atom(name: '_ViewModelBase.formKeyJoin');

  @override
  GlobalKey<FormState> get formKeyJoin {
    _$formKeyJoinAtom.reportRead();
    return super.formKeyJoin;
  }

  @override
  set formKeyJoin(GlobalKey<FormState> value) {
    _$formKeyJoinAtom.reportWrite(value, super.formKeyJoin, () {
      super.formKeyJoin = value;
    });
  }

  final _$pageControllerAtom = Atom(name: '_ViewModelBase.pageController');

  @override
  PageController get pageController {
    _$pageControllerAtom.reportRead();
    return super.pageController;
  }

  @override
  set pageController(PageController value) {
    _$pageControllerAtom.reportWrite(value, super.pageController, () {
      super.pageController = value;
    });
  }

  final _$userNameAtom = Atom(name: '_ViewModelBase.userName');

  @override
  String? get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String? value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  final _$roomModelAtom = Atom(name: '_ViewModelBase.roomModel');

  @override
  RoomModel get roomModel {
    _$roomModelAtom.reportRead();
    return super.roomModel;
  }

  @override
  set roomModel(RoomModel value) {
    _$roomModelAtom.reportWrite(value, super.roomModel, () {
      super.roomModel = value;
    });
  }

  final _$playersListAtom = Atom(name: '_ViewModelBase.playersList');

  @override
  ObservableList<PlayerModel>? get playersList {
    _$playersListAtom.reportRead();
    return super.playersList;
  }

  @override
  set playersList(ObservableList<PlayerModel>? value) {
    _$playersListAtom.reportWrite(value, super.playersList, () {
      super.playersList = value;
    });
  }

  final _$playerModelAtom = Atom(name: '_ViewModelBase.playerModel');

  @override
  PlayerModel get playerModel {
    _$playerModelAtom.reportRead();
    return super.playerModel;
  }

  @override
  set playerModel(PlayerModel value) {
    _$playerModelAtom.reportWrite(value, super.playerModel, () {
      super.playerModel = value;
    });
  }

  final _$roomCodeAtom = Atom(name: '_ViewModelBase.roomCode');

  @override
  String? get roomCode {
    _$roomCodeAtom.reportRead();
    return super.roomCode;
  }

  @override
  set roomCode(String? value) {
    _$roomCodeAtom.reportWrite(value, super.roomCode, () {
      super.roomCode = value;
    });
  }

  final _$numbersListAtom = Atom(name: '_ViewModelBase.numbersList');

  @override
  List<int> get numbersList {
    _$numbersListAtom.reportRead();
    return super.numbersList;
  }

  @override
  set numbersList(List<int> value) {
    _$numbersListAtom.reportWrite(value, super.numbersList, () {
      super.numbersList = value;
    });
  }

  final _$takenNumberAtom = Atom(name: '_ViewModelBase.takenNumber');

  @override
  int get takenNumber {
    _$takenNumberAtom.reportRead();
    return super.takenNumber;
  }

  @override
  set takenNumber(int value) {
    _$takenNumberAtom.reportWrite(value, super.takenNumber, () {
      super.takenNumber = value;
    });
  }

  final _$takenNumbersAtom = Atom(name: '_ViewModelBase.takenNumbers');

  @override
  List<int> get takenNumbers {
    _$takenNumbersAtom.reportRead();
    return super.takenNumbers;
  }

  @override
  set takenNumbers(List<int> value) {
    _$takenNumbersAtom.reportWrite(value, super.takenNumbers, () {
      super.takenNumbers = value;
    });
  }

  final _$cardNumbersAtom = Atom(name: '_ViewModelBase.cardNumbers');

  @override
  List<int> get cardNumbers {
    _$cardNumbersAtom.reportRead();
    return super.cardNumbers;
  }

  @override
  set cardNumbers(List<int> value) {
    _$cardNumbersAtom.reportWrite(value, super.cardNumbers, () {
      super.cardNumbers = value;
    });
  }

  final _$randomColorAtom = Atom(name: '_ViewModelBase.randomColor');

  @override
  Color get randomColor {
    _$randomColorAtom.reportRead();
    return super.randomColor;
  }

  @override
  set randomColor(Color value) {
    _$randomColorAtom.reportWrite(value, super.randomColor, () {
      super.randomColor = value;
    });
  }

  final _$isMyNumberTakenAtom = Atom(name: '_ViewModelBase.isMyNumberTaken');

  @override
  bool get isMyNumberTaken {
    _$isMyNumberTakenAtom.reportRead();
    return super.isMyNumberTaken;
  }

  @override
  set isMyNumberTaken(bool value) {
    _$isMyNumberTakenAtom.reportWrite(value, super.isMyNumberTaken, () {
      super.isMyNumberTaken = value;
    });
  }

  final _$createRoomAsyncAction = AsyncAction('_ViewModelBase.createRoom');

  @override
  Future<bool> createRoom() {
    return _$createRoomAsyncAction.run(() => super.createRoom());
  }

  final _$setPlayerStatusAsyncAction =
      AsyncAction('_ViewModelBase.setPlayerStatus');

  @override
  Future<void> setPlayerStatus(bool playerStatus) {
    return _$setPlayerStatusAsyncAction
        .run(() => super.setPlayerStatus(playerStatus));
  }

  final _$joinRoomAsyncAction = AsyncAction('_ViewModelBase.joinRoom');

  @override
  Future<bool> joinRoom() {
    return _$joinRoomAsyncAction.run(() => super.joinRoom());
  }

  final _$startGameAsyncAction = AsyncAction('_ViewModelBase.startGame');

  @override
  Future<bool> startGame() {
    return _$startGameAsyncAction.run(() => super.startGame());
  }

  final _$takeNumberAsyncAction = AsyncAction('_ViewModelBase.takeNumber');

  @override
  Future<bool> takeNumber() {
    return _$takeNumberAsyncAction.run(() => super.takeNumber());
  }

  final _$createGameCardAsyncAction =
      AsyncAction('_ViewModelBase.createGameCard');

  @override
  Future<bool> createGameCard() {
    return _$createGameCardAsyncAction.run(() => super.createGameCard());
  }

  final _$checkMyNumberAsyncAction =
      AsyncAction('_ViewModelBase.checkMyNumber');

  @override
  Future<bool> checkMyNumber(int number) {
    return _$checkMyNumberAsyncAction.run(() => super.checkMyNumber(number));
  }

  final _$_ViewModelBaseActionController =
      ActionController(name: '_ViewModelBase');

  @override
  dynamic playersStream() {
    final _$actionInfo = _$_ViewModelBaseActionController.startAction(
        name: '_ViewModelBase.playersStream');
    try {
      return super.playersStream();
    } finally {
      _$_ViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic roomStream() {
    final _$actionInfo = _$_ViewModelBaseActionController.startAction(
        name: '_ViewModelBase.roomStream');
    try {
      return super.roomStream();
    } finally {
      _$_ViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
formKeyUserName: ${formKeyUserName},
formKeyJoin: ${formKeyJoin},
pageController: ${pageController},
userName: ${userName},
roomModel: ${roomModel},
playersList: ${playersList},
playerModel: ${playerModel},
roomCode: ${roomCode},
numbersList: ${numbersList},
takenNumber: ${takenNumber},
takenNumbers: ${takenNumbers},
cardNumbers: ${cardNumbers},
randomColor: ${randomColor},
isMyNumberTaken: ${isMyNumberTaken}
    ''';
  }
}
