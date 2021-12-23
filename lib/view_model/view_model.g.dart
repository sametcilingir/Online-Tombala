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

  final _$createRoomAsyncAction = AsyncAction('_ViewModelBase.createRoom');

  @override
  Future<bool> createRoom() {
    return _$createRoomAsyncAction.run(() => super.createRoom());
  }

  final _$joinRoomAsyncAction = AsyncAction('_ViewModelBase.joinRoom');

  @override
  Future<bool> joinRoom() {
    return _$joinRoomAsyncAction.run(() => super.joinRoom());
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
  String toString() {
    return '''
formKeyUserName: ${formKeyUserName},
formKeyRoomId: ${formKeyRoomId},
userName: ${userName},
roomId: ${roomId}
    ''';
  }
}
