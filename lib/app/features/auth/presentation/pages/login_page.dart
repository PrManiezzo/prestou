import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prestou/app/widgets/buttons/app_button.dart';
import 'package:prestou/app/widgets/inputDefaut/app_input_field.dart';
import 'package:prestou/app/widgets/layout/responsive_page_container.dart';
import 'package:prestou/app/config/app_localizations.dart';
import 'package:prestou/app/settings/settings_bloc.dart';
import 'package:prestou/app/settings/settings_state.dart';
import 'package:prestou/app/widgets/feedback/app_message.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';

class LoginPage extends StatelessWidget {
  final whatsappCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settings) {
        final lang = settings.languageCode;
        return Scaffold(
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                context.go("/home");
              } else if (state is AuthError) {
                AppMessage.show(
                  context,
                  state.message,
                  type: AppMessageType.error,
                  minimal: true,
                );
              }
            },
            builder: (context, state) {
              return ResponsivePageContainer(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔥 ÍCONE DO APP
                      Image.asset(
                        'assets/icons/icon.png', // AJUSTE O CAMINHO SE NECESSÁRIO
                        width: 220,
                        height: 220,
                      ),

                      const SizedBox(height: 16),

                      // 🔥 TEXTO "Prestou"
                      Text(
                        AppLocalizations.text(lang, 'appName'),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // WHATSAPP
                      AppInputField(
                        label: AppLocalizations.text(lang, 'whatsapp'),
                        type: InputType.phone,
                        controller: whatsappCtrl,
                      ),

                      const SizedBox(height: 16),

                      // SENHA
                      AppInputField(
                        label: AppLocalizations.text(lang, 'password'),
                        type: InputType.password,
                        controller: passwordCtrl,
                      ),

                      const SizedBox(height: 26),
                      AppButton(
                        label: AppLocalizations.text(lang, 'login'),
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            AuthLoginEvent(
                              whatsappCtrl.text,
                              passwordCtrl.text,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        label: AppLocalizations.text(lang, 'forgotPassword'),
                        isLink: true,
                        onPressed: () {
                          context.go("/recover");
                        },
                      ),
                      // Link para confirmar senha removido; fluxo inicia após solicitar redefinição
                      const SizedBox(height: 24),
                      AppButton(
                        label: AppLocalizations.text(lang, 'createAccount'),
                        isLink: true,
                        onPressed: () {
                          context.go("/register");
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
