import 'package:flutter/material.dart';
import 'package:flutter_web/core/config/shim_db.dart';
import 'package:flutter_web/core/utils/app_dimens.dart';
import 'package:flutter_web/features/app_common/presentation/widgets/app_textform_field.dart';
import 'package:gap/gap.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
            const Text('Sign In'),
            const Gap(AppDimens.space8),
            Padding(
              padding: const EdgeInsets.all(AppDimens.defaultPadding),
              child: AppTextFormField(
                controller: nameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.defaultPadding),
              child: AppTextFormField(
                controller: passwordController,
              ),
            ),
            const Gap(AppDimens.space8),
            ElevatedButton(
                onPressed: () async {
                  var user = await AppLocalDB.read(AppLocalKeys.user);

                  print("User is $user");
                },
                child: Text('Submit')),
          ],
        ),
      ),
    );
  }
}
