import 'package:flutter/material.dart';
import 'package:flutter_web/core/routes/app_route_keys.dart';
import 'package:flutter_web/core/routes/navigation_service.dart';
import 'package:flutter_web/core/utils/app_dimens.dart';
import 'package:flutter_web/features/chat/data/models/chat.dart';
import 'package:go_router/go_router.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// class ChatPage extends StatelessWidget {
//   const ChatPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var controller = TextEditingController();
  late Uri wsUrl;
  late WebSocketChannel channel;

  List<Chat> messages = [];

  Future<void> _init() async {
    print("Init called");
    wsUrl = Uri.parse('wss://echo.websocket.org/');
    channel = WebSocketChannel.connect(wsUrl);
    await channel.ready;
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print(GoRouterState.of(context).uri.queryParameters);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void _onSendClicked(String value) {
    print("on Send clicked");
    var params = GoRouterState.of(context).uri.queryParameters;
    var chat =
        Chat(roomId: params['roomId'] ?? '', message: value, sentByMe: false);

    channel.sink.add(chat.copyWith(sentByMe: true));
    channel.sink.add(chat);
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
        padding: const EdgeInsets.all(AppDimens.defaultPadding),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration:
                    InputDecoration(enabledBorder: OutlineInputBorder()),
                controller: controller,
                onFieldSubmitted: _onSendClicked,
              ),
            ),
            IconButton(
                onPressed: () => _onSendClicked(controller.text),
                icon: Icon(Icons.send))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextFormField(
            //         decoration:
            //             InputDecoration(enabledBorder: OutlineInputBorder()),
            //         controller: controller,
            //         onFieldSubmitted: _onSendClicked,
            //       ),
            //     ),
            //     IconButton(
            //         onPressed: () => _onSendClicked(controller.text),
            //         icon: Icon(Icons.send))
            //   ],
            // ),
            Expanded(
              child: StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    messages.add(snapshot.data);
                  }
                  print("snapshot data ${snapshot.data}");
                  return ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Text(messages[index].message),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
