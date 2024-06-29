import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/core/config/app_colors.dart';
import 'package:flutter_web/core/extensions/text_style_extension.dart';
import 'package:flutter_web/core/routes/app_route_keys.dart';
import 'package:flutter_web/core/routes/navigation_service.dart';
import 'package:flutter_web/core/utils/app_dimens.dart';
import 'package:flutter_web/core/utils/app_size.dart';
import 'package:flutter_web/core/widgets/app_icon_button.dart';
import 'package:flutter_web/core/widgets/app_textform_field.dart';
import 'package:flutter_web/features/chat/data/models/chat.dart';
import 'package:flutter_web/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
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
final String? roomId;
  const ChatPage({super.key, this.roomId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var controller = TextEditingController();
  late Uri wsUrl;

  late WebSocketChannel channel;

  ValueNotifier<List<Chat>> messages = ValueNotifier([]);

  Future<void> _init() async {
    print("Init called");
    wsUrl = Uri.parse('wss://echo.websocket.org/');
    channel = WebSocketChannel.connect(wsUrl);
    await channel.ready;

    channel.stream.listen((event) {
      print(event);
      _addDataToList(event);
    });
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
        Chat(roomId: params['RoomId'] ?? '', message: value, sentByMe: true);

    channel.sink.add(chat.toJson());
    var chat2 = chat.copyWith(
        id: const Uuid().v1(),
        sentByMe: false,
        createdAt: DateTime.now().add(Duration(milliseconds: 100)));
    print(chat.toJson());
    print(chat2.toJson());
    channel.sink.add(chat2.toJson());
  }

  void _addDataToList(String event) {
    try {
      messages.value.add(Chat.fromJson(event));
      messages.value.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      messages.notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(AppDimens.defaultBorderRadius))
        ),
        backgroundColor: AppColors.black.withOpacity(0.5),
        toolbarHeight: context.h(75),
        title:

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.borderRadius40),
            border: Border.all(color: AppColors.grey78)
          ),
          padding: EdgeInsets.all( AppDimens.space5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            CircleAvatar(
                  backgroundImage: NetworkImage('https://picsum.photos/500/500'),
                  maxRadius: AppDimens.borderRadius20,
                ),
              Gap(AppDimens.space5),
              Text(widget.roomId??'', style: context.sm12.withGreyD9,),
              Gap(AppDimens.space16),
            ],
          ),
        ),
        actions: [
          // ElevatedButton(
          //     onPressed: () {
          //       NavigationService()
          //           .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
          //     },
          //     child: Icon(Icons.logout))
        ],
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(AppDimens.defaultPadding),
      //   child: Row(
      //     children: [
      //       Expanded(
      //         child: TextFormField(
      //           decoration:
      //               InputDecoration(enabledBorder: OutlineInputBorder()),
      //           controller: controller,
      //           onFieldSubmitted: _onSendClicked,
      //         ),
      //       ),
      //       IconButton(
      //           onPressed: () => _onSendClicked(controller.text),
      //           icon: Icon(Icons.send))
      //     ],
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: messages,
                builder: (context, value, child) {
                  return ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: messages.value.length,
                    itemBuilder: (context, index) {
                      return ChatBubble(chat: messages.value[index]);
                    },
                  );
                },
              ),
            ),
            AppTextFormField(
              controller: controller,
              hint: "Write a message ...",
              fillColor: AppColors.black.withOpacity(0.5),
              filled: true,
              suffixIcon: AppIconButton.send(
                iconColor: AppColors.primary,
                onPressed: () {
                  _onSendClicked(controller.text);
                },),
            ),
          ],
        ),
      ),
    );
  }
}
