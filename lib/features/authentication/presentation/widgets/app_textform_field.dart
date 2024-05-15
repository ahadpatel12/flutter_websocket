import 'package:flutter/material.dart';
import 'package:flutter_web/core/config/app_colors.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  const AppTextFormField({
    super.key,
    this.controller,
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
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: outlineBorder,
          enabledBorder: outlineBorder,
          focusedBorder: outlineBorder,
          errorBorder: errorOutlineBorder,
          focusedErrorBorder: errorOutlineBorder),
    );
  }
}
