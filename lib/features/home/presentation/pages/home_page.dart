import 'package:flutter/material.dart';
import 'package:flutter_web/core/config/shim_db.dart';
import 'package:flutter_web/core/routes/app_route_keys.dart';
import 'package:flutter_web/core/routes/navigation_service.dart';
import 'package:flutter_web/core/utils/app_dimens.dart';
import 'package:flutter_web/features/chat/data/models/chat.dart';
import 'package:flutter_web/features/chat/data/models/room.dart';
import 'package:flutter_web/features/home/presentation/widgets/room_list_item.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var roomList = <Room>[
      Room(id: Uuid().v1(), createdAt: DateTime.now()),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Flutter Web socket'),
        actions: [
          ElevatedButton(
              onPressed: () {
                NavigationService()
                    .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
              },
              child: Icon(Icons.logout))
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppDimens.space10),
        child: ElevatedButton(
          onPressed: () async {
            var room = Room(id: Uuid().v1(), createdAt: DateTime.now());
            Box<Room> rooms = await AppLocalDB().rooms;

            /// rooms.add(room);

            var chat =
                Chat(roomId: room.id!, message: "Testing", sentByMe: true);
            rooms.values.toList().first.chats.addAll([
              chat,
              chat.copyWith(sentByMe: false, message: "another Messgage")
            ]);

            rooms.values.toList().firstWhere((element) =>
                element.id == '6f205880-9d49-1fd4-ba6b-ef9876fbee72');
            // rooms.values.toList().first.chats.add(chat);
            print(rooms.values);

            context
                .goNamed(AppRoutes.chat, queryParameters: {"roomId": room.id});
          },
          child: Text('Start Chatting'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: roomList.length,
          itemBuilder: (context, index) {
            return RoomListItem(room: roomList[index]);
          },
        ),
      ),
    );
  }
}
