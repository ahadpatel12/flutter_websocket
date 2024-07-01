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
    emit(state.copyWith(responseState: ResponseState.loading));

    var roomList = await AppLocalDB().getRoomList;
    var room = roomList.get(event.roomId);
    emit(state.copyWith(
        responseState: ResponseState.success,
        room: room,
        chatList: room?.chats));
  }

  Future<void> sendMessage(
      AddMessageEvent event, Emitter<ChatState> emit) async {
    // var room = await AppLocalDB().getRoom(event.message.roomId);
    var roomList = await AppLocalDB().getRoomList;

    var room = roomList.get(event.message.roomId);
    // room.chats.add(value)
    print("room json ${room?.toJson()}");
    // print("room keys list ${roomList.keys.toList()}");
    room?.chats.add(event.message);
    room?.save();

    print("chat list ${room?.chats.map((e) => e.toJson())}");
  }
}
