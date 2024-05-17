import 'package:flutter/material.dart';
import 'package:flutter_web/core/routes/app_route_keys.dart';
import 'package:flutter_web/core/routes/navigation_service.dart';
import 'package:flutter_web/core/utils/app_dimens.dart';
import 'package:flutter_web/features/chat/data/models/room.dart';
import 'package:go_router/go_router.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            NavigationService().pushNamedAndRemoveUntil(
                AppRoutes.chat, (route) => false,
                args: {"RoomId": "1"});
          },
          child: Text('Start Chatting'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                var room = Room().toJson();
                context
                    .goNamed(AppRoutes.chat, queryParameters: {"RoomId": "1"});
              },
              child: Text('Start Chatting'),
            ),
          ],
        ),
      ),
    );
  }
}
