part of 'room_bloc.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();
}

class GetAllRoomsEvent extends RoomEvent {
  @override
  List<Object?> get props => [];
}

class AddRoomEvent extends RoomEvent {
  final Room room;

  const AddRoomEvent({required this.room});
  @override
  List<Object?> get props => [room];
}
