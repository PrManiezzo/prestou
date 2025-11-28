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
import '../confirm/bloc/confirm_password_bloc.dart';
import '../confirm/bloc/confirm_password_event.dart';
import '../confirm/bloc/confirm_password_state.dart';

class ConfirmPasswordPage extends StatelessWidget {
  final String? initialWhatsapp;
  ConfirmPasswordPage({super.key, this.initialWhatsapp});

  final TextEditingController whatsappCtrl = TextEditingController();
  final TextEditingController codeCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController pass2Ctrl = TextEditingController();

  void _submit(BuildContext context, String lang) {
    final whatsappRaw = whatsappCtrl.text.trim();
    final code = codeCtrl.text.trim();
    final pass = passCtrl.text.trim();
    final pass2 = pass2Ctrl.text.trim();

    final digits = whatsappRaw.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 11) {
      AppMessage.show(
        context,
        AppLocalizations.text(lang, 'invalidWhatsapp'),
        type: AppMessageType.error,
        minimal: true,
      );
      return;
    }
    if (code.isEmpty) {
      AppMessage.show(
        context,
        AppLocalizations.text(lang, 'enterCode'),
        type: AppMessageType.error,
        minimal: true,
      );
      return;
    }
    if (!RegExp(r'^\d+$').hasMatch(code)) {
      AppMessage.show(
        context,
        AppLocalizations.text(lang, 'enterCode'),
        type: AppMessageType.error,
        minimal: true,
      );
      return;
    }
    if (pass.length < 6) {
      AppMessage.show(
        context,
        AppLocalizations.text(lang, 'passwordMin6'),
        type: AppMessageType.error,
        minimal: true,
      );
      return;
    }
    if (pass != pass2) {
      AppMessage.show(
        context,
        AppLocalizations.text(lang, 'passwordsMismatch'),
        type: AppMessageType.error,
        minimal: true,
      );
      return;
    }

    context.read<ConfirmPasswordBloc>().add(
      ConfirmPasswordSubmit(whatsapp: digits, code: code, password: pass),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Prefill whatsapp once if provided
    if (initialWhatsapp != null && whatsappCtrl.text.isEmpty) {
      whatsappCtrl.text = initialWhatsapp!;
    }
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settings) {
        final lang = settings.languageCode;
        return BlocProvider(
          create: (_) => ConfirmPasswordBloc(),
          child: Scaffold(
            body: BlocConsumer<ConfirmPasswordBloc, ConfirmPasswordState>(
              listener: (context, state) {
                if (state is ConfirmPasswordSuccess) {
                  AppMessage.show(
                    context,
                    state.message,
                    type: AppMessageType.success,
                    minimal: true,
                  );
                  context.go('/login');
                } else if (state is ConfirmPasswordError) {
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/icons/icon.png',
                            width: 180,
                            height: 180,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            AppLocalizations.text(lang, 'appName'),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            AppLocalizations.text(lang, 'confirmPasswordDesc'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AppInputField(
                          label: AppLocalizations.text(lang, 'whatsapp'),
                          type: InputType.phone,
                          controller: whatsappCtrl,
                        ),
                        const SizedBox(height: 16),
                        AppInputField(
                          label: AppLocalizations.text(lang, 'code'),
                          // Reutiliza tipo texto normal para código
                          type: InputType.text,
                          controller: codeCtrl,
                        ),
                        const SizedBox(height: 16),
                        AppInputField(
                          label: AppLocalizations.text(lang, 'newPassword'),
                          type: InputType.password,
                          controller: passCtrl,
                        ),
                        const SizedBox(height: 16),
                        AppInputField(
                          label: AppLocalizations.text(
                            lang,
                            'confirmNewPassword',
                          ),
                          type: InputType.password,
                          controller: pass2Ctrl,
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          label: AppLocalizations.text(lang, 'confirm'),
                          isLoading: state is ConfirmPasswordLoading,
                          onPressed: () => _submit(context, lang),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: AppButton(
                            label: AppLocalizations.text(lang, 'backToLogin'),
                            isLink: true,
                            onPressed: () => context.go('/login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
