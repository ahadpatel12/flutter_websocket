import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_web/core/config/shim_db.dart';
import 'package:flutter_web/core/utils/common_functions.dart';
import 'package:flutter_web/features/chat/data/models/chat.dart';
import 'package:flutter_web/features/chat/data/models/room.dart';
import 'package:hive/hive.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState(responseState: ResponseState.initial)) {
    on<GetAllChatsEvent>(getAllChats);
    on<AddMessageEvent>(sendMessage);
  }

  Future<void> getAllChats(
      GetAllChatsEvent event, Emitter<ChatState> emit) async {
    emit.call(state.copyWith(responseState: ResponseState.loading));

    var roomList = await AppLocalDB().getRoomList;
    var room = roomList.get(event.roomId);
    emit.call(state.copyWith(
        responseState: ResponseState.success,
        room: room,
        chatList: room?.chats));
  }

  Future<void> sendMessage(
      AddMessageEvent event, Emitter<ChatState> emit) async {
    try {
      // List<Chat> chats = <Chat>[]..addAll(state.room?.chats ?? []);
      print("before ${state.room?.chats}");
      List<Chat> chats =
          state.room?.chats.map((e) => Chat.fromJson(e.toJson())).toList() ??
              [];
      chats.add(event.chat);
      if (chats.length > 1) {
        chats.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      }

      await state.room?.save();
      var room = state.room;
      print("messages updated ${event.chat.message}");
      print("All chats $chats");

      emit.call(state.copyWith(
          responseState: ResponseState.success,
          chatList: [...chats],
          room: room));
    } catch (e) {
      print("error on adding message $e");
    }
  }
}
