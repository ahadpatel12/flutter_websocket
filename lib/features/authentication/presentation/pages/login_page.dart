import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web/common_libs.dart';
import 'package:flutter_web/core/config/app_colors.dart';
import 'package:flutter_web/core/config/app_font_style.dart';
import 'package:flutter_web/core/config/shim_db.dart';
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
import 'package:idb_shim/sdb/sdb.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var passwordController = TextEditingController();

    return BlocProvider(
      create: (context) => AuthenticationBloc(),
      child: Scaffold(
        backgroundColor: AppColors.black.withOpacity(0.9),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
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
                        children: [
                          Text(
                            'Sign In',
                            style: context.h28.withBlack.withOpacity(0.5),
                          ),
                          const Gap(AppDimens.space8),
                          AppTextFormField(
                            label: 'User Name',
                            hint: 'User Name',
                            filled: true,
                            fillColor: AppColors.black.withOpacity(0.5),
                            borderColor: AppColors.transparent,
                            controller: nameController,
                          ),
                          AppTextFormField(
                            obscureText: true,
                            maxLines: 1,
                            label: 'Password',
                            hint: 'Password',
                            filled: true,
                            fillColor: AppColors.black.withOpacity(0.5),
                            borderColor: AppColors.transparent,
                            controller: passwordController,
                          ),
                          const Gap(AppDimens.space8),
                          // AppButton(
                          //     buttonType: ButtonType.elevated,
                          //     onPressed: () async {
                          //       print("current user ${(await User.getUser())?.toMap()}");
                          //     },
                          //     child: Text("Get user Name")),
                          // const Gap(AppDimens.space8),
                          BlocConsumer<AuthenticationBloc, AuthenticationState>(
                            listener: (context, state) {
                              if (state.responseState ==
                                  ResponseState.success) {
                                context.goNamed(AppRoutes.home);
                              }

                              if (state.responseState ==
                                  ResponseState.failure) {
                                AppSnackBars.showSnackBar(
                                    alertType: AlertType.error,
                                    message: state.message!);
                              }
                            },
                            builder: (context, state) {
                              return AppButton(
                                  buttonType: ButtonType.elevated,
                                  buttonColor: AppColors.secondary,
                                  borderColor: AppColors.transparent,
                                  onTap: () async {
                                    var user = User(
                                        name: nameController.text.trim(),
                                        password:
                                            passwordController.text.trim());
                                    context
                                        .read<AuthenticationBloc>()
                                        .add(LoginEvent(user: user));
                                  },
                                  buttonName: 'Submit');
                            },
                          ),
                          const Gap(AppDimens.space16),
                          Text.rich(TextSpan(
                              style: context.sm12.withGreyD9,
                              children: [
                                const TextSpan(text: "Don't have an account? "),
                                WidgetSpan(
                                    child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                      onTap: () {
                                        NavigationService()
                                            .pushNamedAndRemoveUntil(
                                                AppRoutes.register,
                                                (route) => false);
                                      },
                                      child: Text(
                                        'Register Now',
                                        style: context.sm12.withPrimary,
                                        // AppFS.style(AppDimens.space8,
                                        //     fontColor: AppColors.primary),
                                      )),
                                ))
                              ]))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
