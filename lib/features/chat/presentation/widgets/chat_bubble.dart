import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web/core/config/app_colors.dart';
import 'package:flutter_web/core/extensions/text_style_extension.dart';
import 'package:flutter_web/core/utils/app_dimens.dart';
import 'package:flutter_web/features/chat/data/models/chat.dart';
import 'package:gap/gap.dart';

class ChatBubble extends StatelessWidget {
  Chat chat;
  ChatBubble({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.defaultPadding),
      child: Align(
        alignment: (chat.sentByMe ? Alignment.topRight : Alignment.topLeft),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!chat.sentByMe) ...[
              CircleAvatar(
                maxRadius: AppDimens.borderRadius15,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: const Icon(Icons.person),
              ),
              const Gap(3),
            ],

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(chat.roomId, style: context.sm12.withWhite),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(chat.sentByMe ?AppDimens.borderRadius5:AppDimens.borderRadius20),
                      topLeft: Radius.circular(chat.sentByMe ? AppDimens.imageSize20 :AppDimens.borderRadius5),

                      bottomLeft: const Radius.circular(AppDimens.borderRadius20),
                      bottomRight: const Radius.circular(AppDimens.borderRadius20),
                    ),
                    color: (chat.sentByMe ? AppColors.black.withOpacity(0.5):AppColors.primary.withOpacity(0.5)  ),
                  ),
                  padding: const EdgeInsets.all(AppDimens.defaultPadding),
                  child: Text(chat.message),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
