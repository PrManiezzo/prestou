import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:prestou/app/core/router/app_router.dart';
import 'package:prestou/app/features/auth/presentation/auth/bloc/auth_bloc.dart';
import 'package:prestou/app/core/services/dio_client.dart';

import 'package:prestou/app/settings/settings_bloc.dart';
import 'package:prestou/app/settings/settings_state.dart';
import 'package:prestou/app/config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  DioClient.setup();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<SettingsBloc>(create: (_) => SettingsBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settings) {
        return MaterialApp.router(
          title: 'Prestou',
          debugShowCheckedModeBanner: false,
          theme: settings.isDarkTheme ? AppTheme.dark : AppTheme.light,
          locale: Locale(settings.languageCode),
          routerConfig: appRouter,
        );
      },
    );
  }
}
