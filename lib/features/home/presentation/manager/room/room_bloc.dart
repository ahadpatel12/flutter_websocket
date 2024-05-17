import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_web/core/utils/common_functions.dart';
import 'package:flutter_web/features/chat/data/models/room.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  RoomBloc()
      : super(RoomState(responseState: ResponseState.initial, rooms: [])) {
    on<GetAllRoomsEvent>(getAllRooms);
    on<AddRoomEvent>(addRoom);
  }

  Future<void> getAllRooms(
      GetAllRoomsEvent event, Emitter<RoomState> emit) async {
    emit.call(state.copyWith(responseState: ResponseState.loading));
  }

  Future<void> addRoom(AddRoomEvent event, Emitter<RoomState> emit) async {}
}
