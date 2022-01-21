import 'package:json_annotation/json_annotation.dart';

part 'player_model.g.dart';

@JsonSerializable()
class PlayerModel {
  String? userId;
  String? userName;
  bool? userStatus;

  PlayerModel({this.userId, this.userName, this.userStatus,});

  factory PlayerModel.fromJson(Map<String, dynamic>? json) =>
      _$PlayerModelFromJson(json!);

  Map<String, dynamic> toJson() {
    return _$PlayerModelToJson(this);
  }
}
