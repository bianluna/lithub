import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litapp/core/routing/app_router.dart';
import 'package:litapp/core/theme/lit_theme.dart';

class LitApp extends ConsumerWidget {
  const LitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'LitApp',
      theme: buildLitTheme(),
      routerConfig: router,
    );
  }
}
