import 'package:json_annotation/json_annotation.dart';

part 'room_model.g.dart';

@JsonSerializable()
class RoomModel {
  String? roomId;
  String? roomCreator;
  String? roomCode;
  String? roomStatus;
  String? roomFirstWinner;
  String? roomSecondWinner;
  String? roomThirdWinner;
  int? roomTakenNumber;

  RoomModel({
    this.roomId,
    this.roomCreator,
    this.roomCode,
    this.roomStatus,
    this.roomFirstWinner,
    this.roomSecondWinner,
    this.roomThirdWinner,
    this.roomTakenNumber,
  });

  factory RoomModel.fromJson(Map<String, dynamic>? json) =>
      _$RoomModelFromJson(json!);

  Map<String, dynamic> toJson() {
    return _$RoomModelToJson(this);
  }
}
