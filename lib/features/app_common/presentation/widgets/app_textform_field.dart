import 'package:flutter/material.dart';
import 'package:flutter_web/core/config/app_colors.dart';
import 'package:flutter_web/core/utils/app_dimens.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final EdgeInsets padding;
  final String label;
  const AppTextFormField({
    super.key,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.padding = const EdgeInsets.all(AppDimens.defaultPadding),
    this.label = '',
  });

  InputBorder get outlineBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      );

  InputBorder get errorOutlineBorder => OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error),
        borderRadius: BorderRadius.circular(10),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        decoration: InputDecoration(
            label: Text(label),
            hintText: label,
            border: outlineBorder,
            enabledBorder: outlineBorder,
            focusedBorder: outlineBorder,
            errorBorder: errorOutlineBorder,
            focusedErrorBorder: errorOutlineBorder),
      ),
    );
  }
}
