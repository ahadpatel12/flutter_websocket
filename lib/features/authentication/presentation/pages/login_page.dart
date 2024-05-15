import 'package:flutter/material.dart';
import 'package:flutter_web/core/utils/app_dimens.dart';
import 'package:flutter_web/features/authentication/presentation/widgets/app_textform_field.dart';
import 'package:gap/gap.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(AppDimens.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Sign In'),
            Gap(AppDimens.space8),
            AppTextFormField(
              controller: nameController,
            ),
            AppTextFormField(
              controller: passwordController,
            )
          ],
        ),
      ),
    );
  }
}
