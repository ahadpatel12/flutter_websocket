import 'package:flutter/material.dart';
import 'package:flutter_web/core/config/app_colors.dart';
import 'package:flutter_web/core/extensions/text_style_extension.dart';
import 'package:flutter_web/core/utils/app_dimens.dart';
import 'package:flutter_web/core/utils/app_size.dart';

enum ButtonType {
  elevated,
  outline,
  elvatedWithIcon,
  outLineWithIcon,
}

class AppButton extends StatelessWidget {
  final ButtonType buttonType;
  final String? buttonName;
  final Color? buttonColor;
  final VoidCallback? onTap;
  final double fontSize;
  final Color? fontColor;
  final Color? outlineColor;
  final Color borderColor;
  final BorderRadius? borderRadius;
  final Widget? childWidget;
  final Widget? icon;
  final double? width;
  final double? height;
  final IconAlignment iconAlignment;

  final EdgeInsetsGeometry? padding;

  const AppButton({required this.onTap,
    required this.buttonType,
    this.iconAlignment = IconAlignment.start,
    this.buttonName,
    this.buttonColor = AppColors.primary,
    this.fontSize = 14,
    this.fontColor,
    this.borderColor = AppColors.primary,
    this.outlineColor = AppColors.primary,
    this.borderRadius,
    this.childWidget,
    this.icon,
    this.padding,
    this.width,
    this.height,
    super.key});

  @override
  Widget build(BuildContext context) {
    Widget child = childWidget ??
        Text(buttonName ?? '',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: context.md14.weigh400.copyWith(
                color: fontColor ?? defaultTextColor,
                overflow: TextOverflow.ellipsis));

    Widget widget = switch (buttonType) {
      ButtonType.elevated =>
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                disabledBackgroundColor: buttonColor,
                elevation: 0,
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: buttonColor,
                padding: padding,
                shape: ContinuousRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(20),
                  side: BorderSide(color: borderColor),
                ),
                foregroundColor: fontColor),
            onPressed: onTap,
            child: child,
          ),
      ButtonType.outline =>
          TextButton(
            style: TextButton.styleFrom(
                shape: ContinuousRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(20),
                  side: BorderSide(color: borderColor, width: 1),
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact),
            onPressed: onTap,
            child: child,
          ),
      ButtonType.elvatedWithIcon =>
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                disabledBackgroundColor: buttonColor,
                elevation: 0,
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: buttonColor,
                padding: padding,
                shape: ContinuousRectangleBorder(
                  borderRadius: borderRadius ??
                      BorderRadius.circular(AppDimens.borderRadius15),
                  side: BorderSide(color: borderColor),
                ),
                foregroundColor: fontColor),
            onPressed: onTap,
            icon: icon,
            iconAlignment: iconAlignment,
            label: child,
          ),
      ButtonType.outLineWithIcon =>
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                disabledBackgroundColor: buttonColor,
                elevation: 0,
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: padding,
                shape: ContinuousRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(20),
                  side: BorderSide(color: borderColor),
                ),
                side: BorderSide(color: borderColor),
                foregroundColor: fontColor),
            onPressed: onTap,
            icon: icon,
            iconAlignment: iconAlignment,
            label: child,
          ),
    };
    return SizedBox(
      height: height ?? context.h(40),
      width: width,
      child: widget,
    );
  }

  Color get defaultTextColor {
    return switch (buttonType) {
      ButtonType.elvatedWithIcon || ButtonType.elevated => AppColors.white,
      ButtonType.outLineWithIcon || ButtonType.outline => AppColors.primary,
    };
  }
}
