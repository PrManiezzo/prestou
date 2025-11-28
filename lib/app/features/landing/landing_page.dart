import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prestou/app/config/app_localizations.dart';
import 'package:prestou/app/settings/settings_bloc.dart';
import 'package:prestou/app/settings/settings_state.dart';
import 'package:prestou/app/widgets/layout/responsive_page_container.dart';
import 'package:prestou/app/features/auth/presentation/auth/bloc/auth_bloc.dart';
import 'package:prestou/app/features/auth/presentation/auth/bloc/auth_state.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settings) {
        final lang = settings.languageCode;
        return Scaffold(
          body: BlocListener<AuthBloc, AuthState>(
            listener: (context, authState) {
              if (authState is AuthLogged) {
                context.go('/home');
              }
            },
            child: ResponsivePageContainer(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Semantics(
                      label: 'Logo Prestou',
                      child: Center(
                        child: Image.asset(
                          'assets/icons/icon.png',
                          width: 180,
                          height: 180,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Semantics(
                      header: true,
                      child: Center(
                        child: Text(
                          AppLocalizations.text(lang, 'landingTitle'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Semantics(
                      label: 'Descrição',
                      child: Center(
                        child: Text(
                          AppLocalizations.text(lang, 'landingSubtitle'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _FeatureItem(
                      icon: Icons.verified_user,
                      text: AppLocalizations.text(lang, 'landingFeature1'),
                    ),
                    _FeatureItem(
                      icon: Icons.lock_reset,
                      text: AppLocalizations.text(lang, 'landingFeature2'),
                    ),
                    _FeatureItem(
                      icon: Icons.devices,
                      text: AppLocalizations.text(lang, 'landingFeature3'),
                    ),
                    const SizedBox(height: 40),
                    Semantics(
                      button: true,
                      label: AppLocalizations.text(lang, 'landingGetStarted'),
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () => context.go('/login'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.text(lang, 'landingGetStarted'),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Semantics(
            label: 'Feature icon',
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Semantics(
              label: text,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
