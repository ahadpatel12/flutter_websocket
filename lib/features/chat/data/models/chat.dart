import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:uuid/uuid.dart';

class Chat {
  final String? id;
  final String roomId;
  final String message;
  final bool sentByMe;
  final DateTime? createdAt;

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
    DateTime? createdAt,
  }) =>
      Chat(
        id: id ?? this.id,
        message: message ?? this.message,
        roomId: roomId ?? this.roomId,
        sentByMe: sentByMe ?? this.sentByMe,
        createdAt: createdAt ?? this.createdAt,
        // DateTime.now().add(const Duration(seconds: 1)).toIso8601String(),
      );

  factory Chat.fromJson(String str) => Chat.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Chat.fromMap(Map<String, dynamic> json) => Chat(
        id: json["id"],
        message: json["message"],
        roomId: json["roomId"],
        sentByMe: json["sentByMe"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id ?? Uuid().v1(),
        "message": message,
        "roomId": roomId,
        "sentByMe": sentByMe,
        "createdAt":
            createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      };
}
