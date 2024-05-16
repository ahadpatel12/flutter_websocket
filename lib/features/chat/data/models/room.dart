import 'package:meta/meta.dart';
import 'dart:convert';

import 'chat.dart';

class Room {
  final String? id;
  final List<String> chats;
  final String? createdAt;

  Room({
    this.id,
    this.chats = const [],
    this.createdAt,
  });

  Room copyWith({
    String? id,
    List<String>? chats,
    String? createdAt,
  }) =>
      Room(
        id: id ?? this.id,
        chats: chats ?? this.chats,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Room.fromJson(String str) => Room.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Room.fromMap(Map<String, dynamic> json) => Room(
        id: json["id"],
        chats: List<String>.from(json["chats"].map((x) => x)),
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "chats": List<Chat>.from(chats.map((x) => Chat.fromJson(x))),
        "createdAt": createdAt,
      };
}
