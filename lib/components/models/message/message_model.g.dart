// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return MessageModel(
    messageSenderName: json['messageSenderName'] as String?,
    messageText: json['messageText'] as String?,
    messageSentTime:
        getDateFromTimeStamp(json['messageSentTime'] as Timestamp?),
  );
}

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'messageSenderName': instance.messageSenderName,
      'messageText': instance.messageText,
      'messageSentTime': getTimeStampFromDate(instance.messageSentTime),
    };
