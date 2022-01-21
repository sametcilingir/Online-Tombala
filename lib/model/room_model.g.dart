// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) {
  return RoomModel(
    roomId: json['roomId'] as String?,
    roomCreator: json['roomCreator'] as String?,
    roomCode: json['roomCode'] as String?,
    roomStatus: json['roomStatus'] as String?,
    roomFirstWinner: json['roomFirstWinner'] as String?,
    roomSecondWinner: json['roomSecondWinner'] as String?,
    roomThirdWinner: json['roomThirdWinner'] as String?,
    roomTakenNumbers: json['roomTakenNumbers'] as int?,
  );
}

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
      'roomId': instance.roomId,
      'roomCreator': instance.roomCreator,
      'roomCode': instance.roomCode,
      'roomStatus': instance.roomStatus,
      'roomFirstWinner': instance.roomFirstWinner,
      'roomSecondWinner': instance.roomSecondWinner,
      'roomThirdWinner': instance.roomThirdWinner,
      'roomTakenNumbers': instance.roomTakenNumbers,
    };
