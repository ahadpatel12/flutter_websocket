part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
}

class GetAllChatsEvent extends ChatEvent {
  final String roomId;
  const GetAllChatsEvent({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}

class AddMessageEvent extends ChatEvent {
  final Chat message;

  const AddMessageEvent({required this.message});
  @override
  List<Object?> get props => throw UnimplementedError();
}
