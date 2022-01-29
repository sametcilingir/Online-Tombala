import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  String? messageSenderName;
  String? messageText;
  @JsonKey(fromJson: getDateFromTimeStamp, toJson: getTimeStampFromDate)
  DateTime? messageSentTime;

  MessageModel(
      {this.messageSenderName, this.messageText, this.messageSentTime});

  factory MessageModel.fromJson(Map<String, dynamic>? json) =>
      _$MessageModelFromJson(json!);

  Map<String, dynamic> toJson() {
    return _$MessageModelToJson(this);
  }
}

DateTime? getDateFromTimeStamp(Timestamp? timeStamp) {
  return timeStamp?.toDate();
}

Timestamp? getTimeStampFromDate(DateTime? dateTime) {
  return dateTime != null ? Timestamp.fromDate(dateTime) : null;
}
