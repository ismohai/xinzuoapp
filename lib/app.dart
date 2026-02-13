import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xinzuo_app/providers/app_provider.dart';
import 'package:xinzuo_app/router/app_router.dart';
import 'package:xinzuo_app/theme/app_theme.dart';

class XinZuoApp extends StatelessWidget {
  const XinZuoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp.router(
        title: '心作',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: appRouter,
      ),
    );
  }
}
