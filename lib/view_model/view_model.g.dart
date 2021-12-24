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

  final _$formKeyRoomIdAtom = Atom(name: '_ViewModelBase.formKeyRoomId');

  @override
  GlobalKey<FormState> get formKeyRoomId {
    _$formKeyRoomIdAtom.reportRead();
    return super.formKeyRoomId;
  }

  @override
  set formKeyRoomId(GlobalKey<FormState> value) {
    _$formKeyRoomIdAtom.reportWrite(value, super.formKeyRoomId, () {
      super.formKeyRoomId = value;
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

  final _$roomIdAtom = Atom(name: '_ViewModelBase.roomId');

  @override
  String? get roomId {
    _$roomIdAtom.reportRead();
    return super.roomId;
  }

  @override
  set roomId(String? value) {
    _$roomIdAtom.reportWrite(value, super.roomId, () {
      super.roomId = value;
    });
  }

  final _$contextAtom = Atom(name: '_ViewModelBase.context');

  @override
  BuildContext? get context {
    _$contextAtom.reportRead();
    return super.context;
  }

  @override
  set context(BuildContext? value) {
    _$contextAtom.reportWrite(value, super.context, () {
      super.context = value;
    });
  }

  final _$isGameStartedAtom = Atom(name: '_ViewModelBase.isGameStarted');

  @override
  bool? get isGameStarted {
    _$isGameStartedAtom.reportRead();
    return super.isGameStarted;
  }

  @override
  set isGameStarted(bool? value) {
    _$isGameStartedAtom.reportWrite(value, super.isGameStarted, () {
      super.isGameStarted = value;
    });
  }

  final _$allNumbersListDatabaseAtom =
      Atom(name: '_ViewModelBase.allNumbersListDatabase');

  @override
  List<dynamic> get allNumbersListDatabase {
    _$allNumbersListDatabaseAtom.reportRead();
    return super.allNumbersListDatabase;
  }

  @override
  set allNumbersListDatabase(List<dynamic> value) {
    _$allNumbersListDatabaseAtom
        .reportWrite(value, super.allNumbersListDatabase, () {
      super.allNumbersListDatabase = value;
    });
  }

  final _$allNumbersListTableAtom =
      Atom(name: '_ViewModelBase.allNumbersListTable');

  @override
  List<dynamic> get allNumbersListTable {
    _$allNumbersListTableAtom.reportRead();
    return super.allNumbersListTable;
  }

  @override
  set allNumbersListTable(List<dynamic> value) {
    _$allNumbersListTableAtom.reportWrite(value, super.allNumbersListTable, () {
      super.allNumbersListTable = value;
    });
  }

  final _$randomNumbersForCardsAtom =
      Atom(name: '_ViewModelBase.randomNumbersForCards');

  @override
  List<dynamic> get randomNumbersForCards {
    _$randomNumbersForCardsAtom.reportRead();
    return super.randomNumbersForCards;
  }

  @override
  set randomNumbersForCards(List<dynamic> value) {
    _$randomNumbersForCardsAtom.reportWrite(value, super.randomNumbersForCards,
        () {
      super.randomNumbersForCards = value;
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

  final _$isMyNumberShownAtom = Atom(name: '_ViewModelBase.isMyNumberShown');

  @override
  bool get isMyNumberShown {
    _$isMyNumberShownAtom.reportRead();
    return super.isMyNumberShown;
  }

  @override
  set isMyNumberShown(bool value) {
    _$isMyNumberShownAtom.reportWrite(value, super.isMyNumberShown, () {
      super.isMyNumberShown = value;
    });
  }

  final _$createRoomAsyncAction = AsyncAction('_ViewModelBase.createRoom');

  @override
  Future<bool> createRoom({required BuildContext context}) {
    return _$createRoomAsyncAction
        .run(() => super.createRoom(context: context));
  }

  final _$joinRoomAsyncAction = AsyncAction('_ViewModelBase.joinRoom');

  @override
  Future<bool> joinRoom({required BuildContext context}) {
    return _$joinRoomAsyncAction.run(() => super.joinRoom(context: context));
  }

  final _$gameDocumentFutureAsyncAction =
      AsyncAction('_ViewModelBase.gameDocumentFuture');

  @override
  Future<void> gameDocumentFuture() {
    return _$gameDocumentFutureAsyncAction
        .run(() => super.gameDocumentFuture());
  }

  final _$startGameAsyncAction = AsyncAction('_ViewModelBase.startGame');

  @override
  Future<bool> startGame() {
    return _$startGameAsyncAction.run(() => super.startGame());
  }

  final _$takeNumberAsyncAction = AsyncAction('_ViewModelBase.takeNumber');

  @override
  Future<bool> takeNumber({required BuildContext context}) {
    return _$takeNumberAsyncAction
        .run(() => super.takeNumber(context: context));
  }

  final _$createGameCardAsyncAction =
      AsyncAction('_ViewModelBase.createGameCard');

  @override
  Future<bool> createGameCard() {
    return _$createGameCardAsyncAction.run(() => super.createGameCard());
  }

  final _$_ViewModelBaseActionController =
      ActionController(name: '_ViewModelBase');

  @override
  Stream<QuerySnapshot<Object?>> playersStream() {
    final _$actionInfo = _$_ViewModelBaseActionController.startAction(
        name: '_ViewModelBase.playersStream');
    try {
      return super.playersStream();
    } finally {
      _$_ViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Stream<DocumentSnapshot<Object?>> gameDocumentStream() {
    final _$actionInfo = _$_ViewModelBaseActionController.startAction(
        name: '_ViewModelBase.gameDocumentStream');
    try {
      return super.gameDocumentStream();
    } finally {
      _$_ViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool checkMyNumber(BuildContext context) {
    final _$actionInfo = _$_ViewModelBaseActionController.startAction(
        name: '_ViewModelBase.checkMyNumber');
    try {
      return super.checkMyNumber(context);
    } finally {
      _$_ViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
formKeyUserName: ${formKeyUserName},
formKeyRoomId: ${formKeyRoomId},
userName: ${userName},
roomId: ${roomId},
context: ${context},
isGameStarted: ${isGameStarted},
allNumbersListDatabase: ${allNumbersListDatabase},
allNumbersListTable: ${allNumbersListTable},
randomNumbersForCards: ${randomNumbersForCards},
randomColor: ${randomColor},
isMyNumberShown: ${isMyNumberShown}
    ''';
  }
}
