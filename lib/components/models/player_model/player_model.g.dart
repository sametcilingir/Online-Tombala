// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) {
  return PlayerModel(
    userId: json['userId'] as String?,
    userName: json['userName'] as String?,
    userStatus: json['userStatus'] as bool?,
  );
}

Map<String, dynamic> _$PlayerModelToJson(PlayerModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'userStatus': instance.userStatus,
    };
