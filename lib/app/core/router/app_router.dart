import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:prestou/app/features/home/home_page.dart';
import 'package:prestou/app/features/auth/presentation/pages/login_page.dart';
import 'package:prestou/app/features/profile/profile_page.dart';
import 'package:prestou/app/features/auth/presentation/pages/recover_password_page.dart';
import 'package:prestou/app/features/auth/presentation/pages/confirm_password_page.dart';
import 'package:prestou/app/features/auth/presentation/pages/register_page.dart';
import 'package:prestou/app/features/auth/presentation/pages/confirm_account_page.dart';
import 'package:prestou/app/features/auth/presentation/pages/resend_code_page.dart';
import 'package:prestou/app/features/splash/splash_page.dart';
import 'package:prestou/app/features/landing/landing_page.dart';

final appRouter = GoRouter(
  // Se for web inicia na landing, caso contrário mantém splash
  initialLocation: kIsWeb ? '/' : '/splash',
  routes: [
    // Landing somente web
    GoRoute(path: '/', builder: (context, state) => const LandingPage()),
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
    GoRoute(
      path: '/recover',
      builder: (context, state) => RecoverPasswordPage(),
    ),
    GoRoute(
      path: '/confirm-password',
      builder: (context, state) =>
          ConfirmPasswordPage(initialWhatsapp: state.extra as String?),
    ),
    GoRoute(
      path: '/confirm-account',
      builder: (context, state) =>
          ConfirmAccountPage(initialWhatsapp: state.extra as String?),
    ),
    GoRoute(
      path: '/resend-code',
      builder: (context, state) =>
          ResendCodePage(initialWhatsapp: state.extra as String?),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
  ],
);
