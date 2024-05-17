part of 'room_bloc.dart';

class RoomState extends Equatable {
  final ResponseState responseState;
  final String? message;
  final List<Room> rooms;
  const RoomState(
      {this.responseState = ResponseState.initial,
      this.message,
      this.rooms = const []});

  @override
  List<Object?> get props => [responseState, message, rooms];

  RoomState copyWith({
    ResponseState? responseState,
    String? message,
    List<Room>? rooms,
  }) {
    return RoomState(
      responseState: responseState ?? this.responseState,
      message: message,
      rooms: rooms ?? this.rooms,
    );
  }
}
