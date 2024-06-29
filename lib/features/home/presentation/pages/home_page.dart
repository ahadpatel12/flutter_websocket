import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web/core/config/app_assets.dart';
import 'package:flutter_web/core/config/app_colors.dart';
import 'package:flutter_web/core/config/app_font_style.dart';
import 'package:flutter_web/core/config/shim_db.dart';
import 'package:flutter_web/core/extensions/text_style_extension.dart';
import 'package:flutter_web/core/routes/app_route_keys.dart';
import 'package:flutter_web/core/routes/navigation_service.dart';
import 'package:flutter_web/core/utils/app_dimens.dart';
import 'package:flutter_web/core/utils/app_snackbar.dart';
import 'package:flutter_web/core/utils/common_functions.dart';
import 'package:flutter_web/core/widgets/app_search_field.dart';
import 'package:flutter_web/features/chat/data/models/chat.dart';
import 'package:flutter_web/features/chat/data/models/room.dart';
import 'package:flutter_web/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter_web/features/home/presentation/manager/room/room_bloc.dart';
import 'package:flutter_web/features/home/presentation/widgets/room_list_item.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String?> selectedRoom = ValueNotifier(null);
    var bloc = RoomBloc();
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset(AppAssets.logo),
          title: Text.rich(
            TextSpan(children: [
              TextSpan(text: 'Chit', style: context.lg16.withPrimary),
              TextSpan(text: 'Chat', style: context.lg16.withSecondary),
            ]),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  NavigationService().pushNamedAndRemoveUntil(
                      AppRoutes.login, (route) => false);
                },
                child: Icon(Icons.logout))
          ],
        ),
        bottomNavigationBar: BlocListener<RoomBloc, RoomState>(
          listener: (context, state) {
            if (state.responseState == ResponseState.created) {
              AppSnackBars.showSnackBar(
                  alertType: AlertType.success, message: "New Room Created");
              context.goNamed(AppRoutes.chat,
                  queryParameters: {"roomId": state.createdRoom!.id});
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.space10),
            child: ElevatedButton(
              onPressed: () async {
                bloc.add(const CreateRoomEvent());
              },
              child: Text('Start Chatting'),
            ),
          ),
        ),
        body: BlocBuilder<RoomBloc, RoomState>(
          bloc: bloc..add(GetAllRoomsEvent()),
          // listener: (context, state) {
          //   // TODO: implement listener
          // },
          builder: (context, state) {
            if (state.responseState == ResponseState.failure) {
              return Center(child: Text('Error: ${state.message}'));
            }

            if (state.responseState == ResponseState.success) {
              return Row(
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.chatBackground
                        ),
                        padding: const EdgeInsets.all(AppDimens.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('All Messages', style: context.xl18,),
                          Gap(AppDimens.space16),

                          Gap(AppDimens.space16),
                          const Padding(
                            padding:  EdgeInsets.symmetric(horizontal:AppDimens.space16),
                            child: AppSearchField(hint: 'Search',),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            itemCount: state.rooms.length,
                            separatorBuilder: (context, index) => const Divider(color: AppColors.grey78,height: 0,),
                            itemBuilder: (context, index) {
                              return ValueListenableBuilder(
                                valueListenable: selectedRoom,
                                builder: (context, selectedRoomValue, child) {
                                  return RoomListItem(
                                    selected: selectedRoomValue == state.rooms[index].id,
                                      networkImage:
                                          'https://picsum.photos/500/${100 * index}/',
                                      onTap: () {
                                        selectedRoom.value = state.rooms[index].id;
                                        // context.goNamed(AppRoutes.chat, queryParameters: {
                                        //   "roomId": state.rooms[index].id
                                        // });
                                      },
                                      room: state.rooms[index]);
                                }
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: ValueListenableBuilder(
                    valueListenable: selectedRoom,
                    builder: (context, selectedRoomValue, child) {
                      return ChatPage(roomId: selectedRoomValue,);
                    }
                  ))

                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
