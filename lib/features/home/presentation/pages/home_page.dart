import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web/core/config/app_assets.dart';
import 'package:flutter_web/core/config/app_colors.dart';
import 'package:flutter_web/core/config/app_font_style.dart';
import 'package:flutter_web/core/config/shim_db.dart';
import 'package:flutter_web/core/extensions/text_style_extension.dart';
import 'package:flutter_web/core/routes/app_route_keys.dart';
import 'package:flutter_web/core/routes/navigation_service.dart';
import 'package:flutter_web/core/config/app_dimens.dart';
import 'package:flutter_web/core/user/user.dart';
import 'package:flutter_web/core/utils/app_size.dart';
import 'package:flutter_web/core/utils/app_snackbar.dart';
import 'package:flutter_web/core/utils/common_functions.dart';
import 'package:flutter_web/core/widgets/app_button.dart';
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
            AppButton(
              buttonType: ButtonType.outLineWithIcon,
              icon: Icon(Icons.logout),
              iconAlignment: IconAlignment.end,
              buttonName: "Logout",
              onTap: () {
                User.logout();
                NavigationService()
                    .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
              },
            ),
            Gap(AppDimens.space5),
            AppButton(
              buttonType: ButtonType.elevated,
              buttonName: "Delete All rooms",
              onTap: () {
                AppLocalDB.roomBox.clear();
              },
            ),
          ],
        ),
        body: BlocBuilder<RoomBloc, RoomState>(
          bloc: bloc..add(GetAllRoomsEvent()),
          builder: (ctx, state) {
            print(context.isPC);
            if (state.responseState == ResponseState.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${state.message}'),
                    BlocListener<RoomBloc, RoomState>(
                      bloc: bloc,
                      listener: (context, state) {
                        if (state.responseState == ResponseState.created) {
                          AppSnackBars.showSnackBar(
                              alertType: AlertType.success,
                              message: "New Room Created");
                          context.goNamed(AppRoutes.chat, queryParameters: {
                            "roomId": state.createdRoom!.id
                          });
                        }
                      },
                      child: AppButton(
                        buttonType: ButtonType.outline,
                        onTap: () async {
                          bloc.add(const CreateRoomEvent());
                        },
                        buttonName: 'Start New Chat',
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state.responseState == ResponseState.success) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spacer(),
                  Flexible(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: AppDimens.defaultMaxWidth),
                      child: Card(
                        color: AppColors.chatBackground,
                        margin: const EdgeInsets.all(AppDimens.defaultPadding),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(AppDimens.space16),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'All Messages',
                                          style: context.xl18,
                                        ),
                                      ),
                                      BlocListener<RoomBloc, RoomState>(
                                        bloc: bloc,
                                        listener: (context, state) {
                                          if (state.responseState ==
                                              ResponseState.created) {
                                            AppSnackBars.showSnackBar(
                                                alertType: AlertType.success,
                                                message: "New Room Created");
                                            context.goNamed(AppRoutes.chat,
                                                queryParameters: {
                                                  "roomId":
                                                      state.createdRoom!.id
                                                });
                                          }
                                        },
                                        child: AppButton(
                                          buttonType: ButtonType.outline,
                                          onTap: () async {
                                            bloc.add(const CreateRoomEvent());
                                          },
                                          buttonName: 'Start New Chat',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(AppDimens.space16),
                                  AppSearchField(
                                    hint: 'Search',
                                  ),
                                  Gap(AppDimens.space16),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: state.rooms.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  color: AppColors.grey78,
                                  height: 0,
                                ),
                                itemBuilder: (context, index) {
                                  return ValueListenableBuilder(
                                      valueListenable: selectedRoom,
                                      builder:
                                          (context, selectedRoomValue, child) {
                                        return RoomListItem(
                                            selected: selectedRoomValue ==
                                                state.rooms[index].id,
                                            networkImage:
                                                'https://picsum.photos/500/${100 * index}/',
                                            onTap: () {
                                              selectedRoom.value =
                                                  state.rooms[index].id;
                                              if (!context.isPC)
                                                context.goNamed(AppRoutes.chat,
                                                    queryParameters: {
                                                      "roomId":
                                                          state.rooms[index].id
                                                    });
                                            },
                                            room: state.rooms[index]);
                                      });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (context.isPC)
                    Expanded(
                        flex: 3,
                        child: ValueListenableBuilder(
                            valueListenable: selectedRoom,
                            builder: (context, selectedRoomValue, child) {
                              return ChatPage(
                                roomId: selectedRoomValue,
                              );
                            }))
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
