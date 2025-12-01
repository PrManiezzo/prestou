import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:prestou/app/features/auth/data/auth_local_storage.dart';
import 'package:prestou/app/settings/settings_bloc.dart';
import 'package:prestou/app/settings/settings_event.dart';
import 'package:prestou/app/settings/settings_state.dart';
import 'package:prestou/app/config/app_localizations.dart';
import 'package:prestou/app/widgets/layout/responsive_page_container.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settings) {
        final lang = settings.languageCode;
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: () => context.pop()),
            title: const Text('Perfil'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          body: ResponsivePageContainer(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/icons/icon.png',
                      width: 140,
                      height: 140,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar perfil'),
                      onPressed: () => context.go('/profile/edit'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      AppLocalizations.text(lang, 'appName'),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.text(lang, 'settings'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: Text(AppLocalizations.text(lang, 'darkTheme')),
                    value: settings.isDarkTheme,
                    onChanged: (_) =>
                        context.read<SettingsBloc>().add(ChangeThemeEvent()),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.text(lang, 'language'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: settings.languageCode,
                    items: [
                      DropdownMenuItem(
                        value: 'pt',
                        child: Text(AppLocalizations.text(lang, 'portuguese')),
                      ),
                      DropdownMenuItem(
                        value: 'en',
                        child: Text(AppLocalizations.text(lang, 'english')),
                      ),
                      DropdownMenuItem(
                        value: 'es',
                        child: Text(AppLocalizations.text(lang, 'spanish')),
                      ),
                    ],
                    onChanged: (code) {
                      if (code != null) {
                        context.read<SettingsBloc>().add(
                              ChangeLanguageEvent(code),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final storage = AuthLocalStorage();
                        await storage.clear();
                        // ignore: use_build_context_synchronously
                        context.go('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                      child: Text(
                        AppLocalizations.text(lang, 'logout'),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
