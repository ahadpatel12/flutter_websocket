import 'package:flutter/material.dart';
import 'package:flutter_web/core/config/app_colors.dart';
import 'package:flutter_web/core/config/app_font_style.dart';
import 'package:flutter_web/core/config/shim_db.dart';
import 'package:flutter_web/core/routes/app_route_keys.dart';
import 'package:flutter_web/core/routes/navigation_service.dart';
import 'package:flutter_web/core/user/user.dart';
import 'package:flutter_web/core/utils/app_dimens.dart';
import 'package:flutter_web/features/app_common/presentation/widgets/app_textform_field.dart';
import 'package:gap/gap.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Register'),
            const Gap(AppDimens.space8),
            AppTextFormField(
              label: 'User Name',
              controller: nameController,
            ),
            AppTextFormField(
              label: 'Password',
              obscureText: true,
              controller: passwordController,
            ),
            AppTextFormField(
              label: 'Confirm Password',
              obscureText: true,
              controller: passwordController,
            ),
            const Gap(AppDimens.space8),
            ElevatedButton(
                onPressed: () async {
                  var user = User(
                      name: nameController.text.trim(),
                      password: passwordController.text.trim());
                  await User.save(user);

                  print("User is $user");
                },
                child: Text('Submit')),
            const Gap(AppDimens.space8),
            Text.rich(TextSpan(children: [
              TextSpan(text: "Do you have an account? "),
              WidgetSpan(
                  child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                    onTap: () {
                      NavigationService().pushNamedAndRemoveUntil(
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                    child: Text(
                      'Login Now',
                      style: AppFS.style(AppDimens.space8,
                          fontColor: AppColors.primary),
                    )),
              ))
            ]))
          ],
        ),
      ),
    );
  }
}
