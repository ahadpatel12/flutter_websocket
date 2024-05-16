import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:uuid/uuid.dart';

class Chat {
  final String? id;
  final String roomId;
  final String message;
  final bool sentByMe;
  final String? createdAt;

  Chat({
    this.id,
    required this.roomId,
    required this.message,
    required this.sentByMe,
    this.createdAt,
  });

  Chat copyWith({
    String? id,
    String? roomId,
    String? message,
    bool? sentByMe,
    String? createdAt,
  }) =>
      Chat(
        id: id ?? this.id,
        message: message ?? this.message,
        roomId: roomId ?? this.roomId,
        sentByMe: sentByMe ?? this.sentByMe,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Chat.fromJson(String str) => Chat.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Chat.fromMap(Map<String, dynamic> json) => Chat(
        id: json["id"],
        message: json["message"],
        roomId: json["roomId"],
        sentByMe: json["sentByMe"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toMap() => {
        "id": Uuid().v1(),
        "message": message,
        "roomId": roomId,
        "sentByMe": sentByMe,
        "createdAt": DateTime.now().toIso8601String(),
      };
}
