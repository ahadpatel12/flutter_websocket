import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_web/core/config/shim_db.dart';
import 'package:flutter_web/core/utils/common_functions.dart';
import 'package:flutter_web/features/chat/data/models/room.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  RoomBloc()
      : super(RoomState(responseState: ResponseState.initial, rooms: [])) {
    on<GetAllRoomsEvent>(getAllRooms);
    on<CreateRoomEvent>(createRoom);
  }

  Future<void> getAllRooms(
      GetAllRoomsEvent event, Emitter<RoomState> emit) async {
    emit.call(state.copyWith(responseState: ResponseState.loading));
    Box<Room> rooms = await AppLocalDB().getRoomList;

    if (rooms.isNotEmpty) {
      List<Room> list = rooms.values.toList();

      list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      emit.call(
          state.copyWith(responseState: ResponseState.success, rooms: list));
      return;
    }
    emit.call(state.copyWith(
        responseState: ResponseState.failure, message: "No Rooms Found"));
  }

  Future<void> createRoom(
      CreateRoomEvent event, Emitter<RoomState> emit) async {
    try {
      var room = Room(id: const Uuid().v1(), createdAt: DateTime.now());
      Box<Room> rooms = await AppLocalDB().getRoomList;
      rooms.put(room.id, room);

      emit.call(state.copyWith(
          responseState: ResponseState.created,
          rooms: [...rooms.values],
          createdRoom: room));
    } catch (e) {
      emit.call(state.copyWith(
          responseState: ResponseState.failure, message: e.toString()));
    }
  }
}
