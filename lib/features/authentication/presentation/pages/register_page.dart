import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web/core/config/app_colors.dart';
import 'package:flutter_web/core/config/app_font_style.dart';
import 'package:flutter_web/core/config/shim_db.dart';
import 'package:flutter_web/core/extensions/text_style_extension.dart';
import 'package:flutter_web/core/routes/app_route_keys.dart';
import 'package:flutter_web/core/routes/navigation_service.dart';
import 'package:flutter_web/core/user/user.dart';
import 'package:flutter_web/core/config/app_dimens.dart';
import 'package:flutter_web/core/utils/app_snackbar.dart';
import 'package:flutter_web/core/utils/common_functions.dart';
import 'package:flutter_web/core/widgets/app_button.dart';
import 'package:flutter_web/core/widgets/app_text_form_field.dart';
import 'package:flutter_web/features/authentication/presentation/manager/authentication_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  var nameCTRL = TextEditingController();
  var passwordCTRL = TextEditingController();
  var confirmPassCTRL = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(),
      lazy: false,
      child: Scaffold(
        body: Center(
          child: Flexible(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppDimens.defaultMaxWidth),
              child: Card(
                color: AppColors.grey78,
                margin: const EdgeInsets.symmetric(
                    horizontal: AppDimens.defaultPadding),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.defaultPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Register',
                        style: context.h28.withBlack.withOpacity(0.5),
                      ),
                      const Gap(AppDimens.space8),
                      AppTextFormField(
                        label: 'User Name',
                        hint: 'User Name',
                        filled: true,
                        fillColor: AppColors.black.withOpacity(0.5),
                        borderColor: AppColors.transparent,
                        controller: nameCTRL,
                      ),
                      AppTextFormField(
                        obscureText: true,
                        maxLines: 1,
                        label: 'Password',
                        hint: 'Password',
                        filled: true,
                        fillColor: AppColors.black.withOpacity(0.5),
                        borderColor: AppColors.transparent,
                        controller: passwordCTRL,
                      ),
                      AppTextFormField(
                        obscureText: true,
                        maxLines: 1,
                        label: 'Confirm Password',
                        hint: 'Confirm Password',
                        filled: true,
                        fillColor: AppColors.black.withOpacity(0.5),
                        borderColor: AppColors.transparent,
                        controller: confirmPassCTRL,
                      ),
                      // const Gap(AppDimens.space8),
                      // ElevatedButton(
                      //     onPressed: () async {
                      //       await AppLocalDB.deleteAll();
                      //     },
                      //     child: Text('Clear All ')),
                      const Gap(AppDimens.space8),
                      BlocConsumer<AuthenticationBloc, AuthenticationState>(
                        listener: (context, state) {
                          if (state.responseState == ResponseState.success) {
                            context.goNamed(AppRoutes.home);
                          }

                          if (state.responseState == ResponseState.failure) {
                            AppSnackBars.showSnackBar(
                                alertType: AlertType.error,
                                message: state.message!);
                          }
                        },
                        bloc: context.read(),
                        builder: (context, state) => AppButton(
                          buttonType: ButtonType.elevated,
                          buttonColor: AppColors.secondary,
                          borderColor: AppColors.transparent,
                          onTap: () async {
                            var user = User(
                                name: nameCTRL.text.trim(),
                                password: passwordCTRL.text.trim());

                            context
                                .read<AuthenticationBloc>()
                                .add(RegisterEvent(user: user));

                            // var list = await User.getUserList();
                            // var currentUser = await User.getUser();
                            // print("User List = ${list}");
                            // print("Current User = $currentUser");

                            // print("User is $user");
                          },
                          buttonName: 'Submit',
                        ),
                      ),
                      const Gap(AppDimens.space16),
                      Text.rich(
                          TextSpan(style: context.sm12.withGreyD9, children: [
                        const TextSpan(text: "Don't have an account? "),
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
                                style: context.sm12.withPrimary,
                              )),
                        ))
                      ])),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
