// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ViewModel on _ViewModelBase, Store {
  Computed<ThemeData>? _$appThemeComputed;

  @override
  ThemeData get appTheme =>
      (_$appThemeComputed ??= Computed<ThemeData>(() => super.appTheme,
              name: '_ViewModelBase.appTheme'))
          .value;
  Computed<Locale>? _$localeComputed;

  @override
  Locale get locale => (_$localeComputed ??=
          Computed<Locale>(() => super.locale, name: '_ViewModelBase.locale'))
      .value;

  final _$isDarkModelAtom = Atom(name: '_ViewModelBase.isDarkModel');

  @override
  bool get isDarkModel {
    _$isDarkModelAtom.reportRead();
    return super.isDarkModel;
  }

  @override
  set isDarkModel(bool value) {
    _$isDarkModelAtom.reportWrite(value, super.isDarkModel, () {
      super.isDarkModel = value;
    });
  }

  final _$isENLocalAtom = Atom(name: '_ViewModelBase.isENLocal');

  @override
  bool get isENLocal {
    _$isENLocalAtom.reportRead();
    return super.isENLocal;
  }

  @override
  set isENLocal(bool value) {
    _$isENLocalAtom.reportWrite(value, super.isENLocal, () {
      super.isENLocal = value;
    });
  }

  final _$viewStateAtom = Atom(name: '_ViewModelBase.viewState');

  @override
  ViewState get viewState {
    _$viewStateAtom.reportRead();
    return super.viewState;
  }

  @override
  set viewState(ViewState value) {
    _$viewStateAtom.reportWrite(value, super.viewState, () {
      super.viewState = value;
    });
  }

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

  final _$homePageControllerAtom =
      Atom(name: '_ViewModelBase.homePageController');

  @override
  PageController get homePageController {
    _$homePageControllerAtom.reportRead();
    return super.homePageController;
  }

  @override
  set homePageController(PageController value) {
    _$homePageControllerAtom.reportWrite(value, super.homePageController, () {
      super.homePageController = value;
    });
  }

  final _$homeScaffoldMessengerKeyAtom =
      Atom(name: '_ViewModelBase.homeScaffoldMessengerKey');

  @override
  GlobalKey<ScaffoldMessengerState> get homeScaffoldMessengerKey {
    _$homeScaffoldMessengerKeyAtom.reportRead();
    return super.homeScaffoldMessengerKey;
  }

  @override
  set homeScaffoldMessengerKey(GlobalKey<ScaffoldMessengerState> value) {
    _$homeScaffoldMessengerKeyAtom
        .reportWrite(value, super.homeScaffoldMessengerKey, () {
      super.homeScaffoldMessengerKey = value;
    });
  }

  final _$startGameReactionAtom =
      Atom(name: '_ViewModelBase.startGameReaction');

  @override
  ReactionDisposer? get startGameReaction {
    _$startGameReactionAtom.reportRead();
    return super.startGameReaction;
  }

  @override
  set startGameReaction(ReactionDisposer? value) {
    _$startGameReactionAtom.reportWrite(value, super.startGameReaction, () {
      super.startGameReaction = value;
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

  final _$takenNumbersMapAtom = Atom(name: '_ViewModelBase.takenNumbersMap');

  @override
  Map<int, bool> get takenNumbersMap {
    _$takenNumbersMapAtom.reportRead();
    return super.takenNumbersMap;
  }

  @override
  set takenNumbersMap(Map<int, bool> value) {
    _$takenNumbersMapAtom.reportWrite(value, super.takenNumbersMap, () {
      super.takenNumbersMap = value;
    });
  }

  final _$takenNumberReactionAtom =
      Atom(name: '_ViewModelBase.takenNumberReaction');

  @override
  ReactionDisposer? get takenNumberReaction {
    _$takenNumberReactionAtom.reportRead();
    return super.takenNumberReaction;
  }

  @override
  set takenNumberReaction(ReactionDisposer? value) {
    _$takenNumberReactionAtom.reportWrite(value, super.takenNumberReaction, () {
      super.takenNumberReaction = value;
    });
  }

  final _$allNumbersListAtom = Atom(name: '_ViewModelBase.allNumbersList');

  @override
  List<int> get allNumbersList {
    _$allNumbersListAtom.reportRead();
    return super.allNumbersList;
  }

  @override
  set allNumbersList(List<int> value) {
    _$allNumbersListAtom.reportWrite(value, super.allNumbersList, () {
      super.allNumbersList = value;
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

  final _$takenNumbersListAtom = Atom(name: '_ViewModelBase.takenNumbersList');

  @override
  List<int> get takenNumbersList {
    _$takenNumbersListAtom.reportRead();
    return super.takenNumbersList;
  }

  @override
  set takenNumbersList(List<int> value) {
    _$takenNumbersListAtom.reportWrite(value, super.takenNumbersList, () {
      super.takenNumbersList = value;
    });
  }

  final _$takenNumbersListFromDatabaseAtom =
      Atom(name: '_ViewModelBase.takenNumbersListFromDatabase');

  @override
  List<int> get takenNumbersListFromDatabase {
    _$takenNumbersListFromDatabaseAtom.reportRead();
    return super.takenNumbersListFromDatabase;
  }

  @override
  set takenNumbersListFromDatabase(List<int> value) {
    _$takenNumbersListFromDatabaseAtom
        .reportWrite(value, super.takenNumbersListFromDatabase, () {
      super.takenNumbersListFromDatabase = value;
    });
  }

  final _$formKeyMessageWaitingAtom =
      Atom(name: '_ViewModelBase.formKeyMessageWaiting');

  @override
  GlobalKey<FormState> get formKeyMessageWaiting {
    _$formKeyMessageWaitingAtom.reportRead();
    return super.formKeyMessageWaiting;
  }

  @override
  set formKeyMessageWaiting(GlobalKey<FormState> value) {
    _$formKeyMessageWaitingAtom.reportWrite(value, super.formKeyMessageWaiting,
        () {
      super.formKeyMessageWaiting = value;
    });
  }

  final _$messageControllerWaitingAtom =
      Atom(name: '_ViewModelBase.messageControllerWaiting');

  @override
  TextEditingController? get messageControllerWaiting {
    _$messageControllerWaitingAtom.reportRead();
    return super.messageControllerWaiting;
  }

  @override
  set messageControllerWaiting(TextEditingController? value) {
    _$messageControllerWaitingAtom
        .reportWrite(value, super.messageControllerWaiting, () {
      super.messageControllerWaiting = value;
    });
  }

  final _$formKeyMessageGameCardAtom =
      Atom(name: '_ViewModelBase.formKeyMessageGameCard');

  @override
  GlobalKey<FormState> get formKeyMessageGameCard {
    _$formKeyMessageGameCardAtom.reportRead();
    return super.formKeyMessageGameCard;
  }

  @override
  set formKeyMessageGameCard(GlobalKey<FormState> value) {
    _$formKeyMessageGameCardAtom
        .reportWrite(value, super.formKeyMessageGameCard, () {
      super.formKeyMessageGameCard = value;
    });
  }

  final _$messageControllerGameCardAtom =
      Atom(name: '_ViewModelBase.messageControllerGameCard');

  @override
  TextEditingController? get messageControllerGameCard {
    _$messageControllerGameCardAtom.reportRead();
    return super.messageControllerGameCard;
  }

  @override
  set messageControllerGameCard(TextEditingController? value) {
    _$messageControllerGameCardAtom
        .reportWrite(value, super.messageControllerGameCard, () {
      super.messageControllerGameCard = value;
    });
  }

  final _$messageListAtom = Atom(name: '_ViewModelBase.messageList');

  @override
  ObservableList<MessageModel>? get messageList {
    _$messageListAtom.reportRead();
    return super.messageList;
  }

  @override
  set messageList(ObservableList<MessageModel>? value) {
    _$messageListAtom.reportWrite(value, super.messageList, () {
      super.messageList = value;
    });
  }

  final _$messageModelAtom = Atom(name: '_ViewModelBase.messageModel');

  @override
  MessageModel get messageModel {
    _$messageModelAtom.reportRead();
    return super.messageModel;
  }

  @override
  set messageModel(MessageModel value) {
    _$messageModelAtom.reportWrite(value, super.messageModel, () {
      super.messageModel = value;
    });
  }

  final _$cardNumbersListAtom = Atom(name: '_ViewModelBase.cardNumbersList');

  @override
  List<int> get cardNumbersList {
    _$cardNumbersListAtom.reportRead();
    return super.cardNumbersList;
  }

  @override
  set cardNumbersList(List<int> value) {
    _$cardNumbersListAtom.reportWrite(value, super.cardNumbersList, () {
      super.cardNumbersList = value;
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

  final _$rangeOf1and15NumbersAtom =
      Atom(name: '_ViewModelBase.rangeOf1and15Numbers');

  @override
  List<int>? get rangeOf1and15Numbers {
    _$rangeOf1and15NumbersAtom.reportRead();
    return super.rangeOf1and15Numbers;
  }

  @override
  set rangeOf1and15Numbers(List<int>? value) {
    _$rangeOf1and15NumbersAtom.reportWrite(value, super.rangeOf1and15Numbers,
        () {
      super.rangeOf1and15Numbers = value;
    });
  }

  final _$rangeOf16and30NumbersAtom =
      Atom(name: '_ViewModelBase.rangeOf16and30Numbers');

  @override
  List<int>? get rangeOf16and30Numbers {
    _$rangeOf16and30NumbersAtom.reportRead();
    return super.rangeOf16and30Numbers;
  }

  @override
  set rangeOf16and30Numbers(List<int>? value) {
    _$rangeOf16and30NumbersAtom.reportWrite(value, super.rangeOf16and30Numbers,
        () {
      super.rangeOf16and30Numbers = value;
    });
  }

  final _$rangeOf31and45NumbersAtom =
      Atom(name: '_ViewModelBase.rangeOf31and45Numbers');

  @override
  List<int>? get rangeOf31and45Numbers {
    _$rangeOf31and45NumbersAtom.reportRead();
    return super.rangeOf31and45Numbers;
  }

  @override
  set rangeOf31and45Numbers(List<int>? value) {
    _$rangeOf31and45NumbersAtom.reportWrite(value, super.rangeOf31and45Numbers,
        () {
      super.rangeOf31and45Numbers = value;
    });
  }

  final _$rangeOf46and60NumbersAtom =
      Atom(name: '_ViewModelBase.rangeOf46and60Numbers');

  @override
  List<int>? get rangeOf46and60Numbers {
    _$rangeOf46and60NumbersAtom.reportRead();
    return super.rangeOf46and60Numbers;
  }

  @override
  set rangeOf46and60Numbers(List<int>? value) {
    _$rangeOf46and60NumbersAtom.reportWrite(value, super.rangeOf46and60Numbers,
        () {
      super.rangeOf46and60Numbers = value;
    });
  }

  final _$rangeOf61and75NumbersAtom =
      Atom(name: '_ViewModelBase.rangeOf61and75Numbers');

  @override
  List<int>? get rangeOf61and75Numbers {
    _$rangeOf61and75NumbersAtom.reportRead();
    return super.rangeOf61and75Numbers;
  }

  @override
  set rangeOf61and75Numbers(List<int>? value) {
    _$rangeOf61and75NumbersAtom.reportWrite(value, super.rangeOf61and75Numbers,
        () {
      super.rangeOf61and75Numbers = value;
    });
  }

  final _$rangeOf76and90NumbersAtom =
      Atom(name: '_ViewModelBase.rangeOf76and90Numbers');

  @override
  List<int>? get rangeOf76and90Numbers {
    _$rangeOf76and90NumbersAtom.reportRead();
    return super.rangeOf76and90Numbers;
  }

  @override
  set rangeOf76and90Numbers(List<int>? value) {
    _$rangeOf76and90NumbersAtom.reportWrite(value, super.rangeOf76and90Numbers,
        () {
      super.rangeOf76and90Numbers = value;
    });
  }

  final _$rangeOf91and99NumbersAtom =
      Atom(name: '_ViewModelBase.rangeOf91and99Numbers');

  @override
  List<int>? get rangeOf91and99Numbers {
    _$rangeOf91and99NumbersAtom.reportRead();
    return super.rangeOf91and99Numbers;
  }

  @override
  set rangeOf91and99Numbers(List<int>? value) {
    _$rangeOf91and99NumbersAtom.reportWrite(value, super.rangeOf91and99Numbers,
        () {
      super.rangeOf91and99Numbers = value;
    });
  }

  final _$gameCardScaffoldMessengerKeyAtom =
      Atom(name: '_ViewModelBase.gameCardScaffoldMessengerKey');

  @override
  GlobalKey<ScaffoldMessengerState> get gameCardScaffoldMessengerKey {
    _$gameCardScaffoldMessengerKeyAtom.reportRead();
    return super.gameCardScaffoldMessengerKey;
  }

  @override
  set gameCardScaffoldMessengerKey(GlobalKey<ScaffoldMessengerState> value) {
    _$gameCardScaffoldMessengerKeyAtom
        .reportWrite(value, super.gameCardScaffoldMessengerKey, () {
      super.gameCardScaffoldMessengerKey = value;
    });
  }

  final _$firstWinnerReactionAtom =
      Atom(name: '_ViewModelBase.firstWinnerReaction');

  @override
  ReactionDisposer? get firstWinnerReaction {
    _$firstWinnerReactionAtom.reportRead();
    return super.firstWinnerReaction;
  }

  @override
  set firstWinnerReaction(ReactionDisposer? value) {
    _$firstWinnerReactionAtom.reportWrite(value, super.firstWinnerReaction, () {
      super.firstWinnerReaction = value;
    });
  }

  final _$secondWinnerReactionAtom =
      Atom(name: '_ViewModelBase.secondWinnerReaction');

  @override
  ReactionDisposer? get secondWinnerReaction {
    _$secondWinnerReactionAtom.reportRead();
    return super.secondWinnerReaction;
  }

  @override
  set secondWinnerReaction(ReactionDisposer? value) {
    _$secondWinnerReactionAtom.reportWrite(value, super.secondWinnerReaction,
        () {
      super.secondWinnerReaction = value;
    });
  }

  final _$thirdWinnerReactionAtom =
      Atom(name: '_ViewModelBase.thirdWinnerReaction');

  @override
  ReactionDisposer? get thirdWinnerReaction {
    _$thirdWinnerReactionAtom.reportRead();
    return super.thirdWinnerReaction;
  }

  @override
  set thirdWinnerReaction(ReactionDisposer? value) {
    _$thirdWinnerReactionAtom.reportWrite(value, super.thirdWinnerReaction, () {
      super.thirdWinnerReaction = value;
    });
  }

  final _$isGameAutoTakeNumberAtom =
      Atom(name: '_ViewModelBase.isGameAutoTakeNumber');

  @override
  bool get isGameAutoTakeNumber {
    _$isGameAutoTakeNumberAtom.reportRead();
    return super.isGameAutoTakeNumber;
  }

  @override
  set isGameAutoTakeNumber(bool value) {
    _$isGameAutoTakeNumberAtom.reportWrite(value, super.isGameAutoTakeNumber,
        () {
      super.isGameAutoTakeNumber = value;
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
  Future<void> setPlayerStatus({required bool playerStatus}) {
    return _$setPlayerStatusAsyncAction
        .run(() => super.setPlayerStatus(playerStatus: playerStatus));
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

  final _$sendMessageAsyncAction = AsyncAction('_ViewModelBase.sendMessage');

  @override
  Future<bool> sendMessage() {
    return _$sendMessageAsyncAction.run(() => super.sendMessage());
  }

  final _$winnerControlAsyncAction =
      AsyncAction('_ViewModelBase.winnerControl');

  @override
  Future<bool> winnerControl(int i) {
    return _$winnerControlAsyncAction.run(() => super.winnerControl(i));
  }

  final _$setWinnerAsyncAction = AsyncAction('_ViewModelBase.setWinner');

  @override
  Future<bool> setWinner(int i) {
    return _$setWinnerAsyncAction.run(() => super.setWinner(i));
  }

  final _$deleteGameAsyncAction = AsyncAction('_ViewModelBase.deleteGame');

  @override
  Future<bool> deleteGame() {
    return _$deleteGameAsyncAction.run(() => super.deleteGame());
  }

  final _$_ViewModelBaseActionController =
      ActionController(name: '_ViewModelBase');

  @override
  void playersStream() {
    final _$actionInfo = _$_ViewModelBaseActionController.startAction(
        name: '_ViewModelBase.playersStream');
    try {
      return super.playersStream();
    } finally {
      _$_ViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void roomStream() {
    final _$actionInfo = _$_ViewModelBaseActionController.startAction(
        name: '_ViewModelBase.roomStream');
    try {
      return super.roomStream();
    } finally {
      _$_ViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void messageStream() {
    final _$actionInfo = _$_ViewModelBaseActionController.startAction(
        name: '_ViewModelBase.messageStream');
    try {
      return super.messageStream();
    } finally {
      _$_ViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void createGameCard() {
    final _$actionInfo = _$_ViewModelBaseActionController.startAction(
        name: '_ViewModelBase.createGameCard');
    try {
      return super.createGameCard();
    } finally {
      _$_ViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reInit() {
    final _$actionInfo = _$_ViewModelBaseActionController.startAction(
        name: '_ViewModelBase.reInit');
    try {
      return super.reInit();
    } finally {
      _$_ViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isDarkModel: ${isDarkModel},
isENLocal: ${isENLocal},
viewState: ${viewState},
formKeyUserName: ${formKeyUserName},
formKeyJoin: ${formKeyJoin},
homePageController: ${homePageController},
homeScaffoldMessengerKey: ${homeScaffoldMessengerKey},
startGameReaction: ${startGameReaction},
roomModel: ${roomModel},
playerModel: ${playerModel},
playersList: ${playersList},
takenNumbersMap: ${takenNumbersMap},
takenNumberReaction: ${takenNumberReaction},
allNumbersList: ${allNumbersList},
takenNumber: ${takenNumber},
takenNumbersList: ${takenNumbersList},
takenNumbersListFromDatabase: ${takenNumbersListFromDatabase},
formKeyMessageWaiting: ${formKeyMessageWaiting},
messageControllerWaiting: ${messageControllerWaiting},
formKeyMessageGameCard: ${formKeyMessageGameCard},
messageControllerGameCard: ${messageControllerGameCard},
messageList: ${messageList},
messageModel: ${messageModel},
cardNumbersList: ${cardNumbersList},
randomColor: ${randomColor},
rangeOf1and15Numbers: ${rangeOf1and15Numbers},
rangeOf16and30Numbers: ${rangeOf16and30Numbers},
rangeOf31and45Numbers: ${rangeOf31and45Numbers},
rangeOf46and60Numbers: ${rangeOf46and60Numbers},
rangeOf61and75Numbers: ${rangeOf61and75Numbers},
rangeOf76and90Numbers: ${rangeOf76and90Numbers},
rangeOf91and99Numbers: ${rangeOf91and99Numbers},
gameCardScaffoldMessengerKey: ${gameCardScaffoldMessengerKey},
firstWinnerReaction: ${firstWinnerReaction},
secondWinnerReaction: ${secondWinnerReaction},
thirdWinnerReaction: ${thirdWinnerReaction},
isGameAutoTakeNumber: ${isGameAutoTakeNumber},
appTheme: ${appTheme},
locale: ${locale}
    ''';
  }
}
