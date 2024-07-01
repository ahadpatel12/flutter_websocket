part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final ResponseState responseState;
  final Room? room;
  final List<Chat> chatList;
  final String? message;

  const ChatState({
    this.responseState = ResponseState.initial,
    this.room,
    this.chatList = const <Chat>[],
    this.message,
  });

  @override
  List<Object?> get props => [responseState, room, chatList, message];

  ChatState copyWith({
    ResponseState? responseState,
    Room? room,
    List<Chat>? chatList,
    String? message,
  }) {
    return ChatState(
      responseState: responseState ?? this.responseState,
      room: room ?? this.room,
      chatList: chatList ?? this.chatList,
      message: message,
    );
  }
}
