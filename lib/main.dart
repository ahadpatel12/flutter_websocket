import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web/core/config/shim_db.dart';
import 'package:flutter_web/core/routes/route_utils.dart';
import 'package:flutter_web/core/user/user.dart';
import 'package:flutter_web/core/utils/app_theme.dart';
import 'package:flutter_web/service_locator.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  usePathUrlStrategy();
  setupLocator();
  await AppLocalDB.init();
  // User().isLoggedIn;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      child: MaterialApp.router(
        title: 'Flutter web socket',
        debugShowCheckedModeBanner: false,
        theme: AppThemeData.theme,
        routerConfig: RouteUtils().goRouter,
      ),
    );
  }
}
