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
import '../confirm_account/bloc/confirm_account_bloc.dart';
import '../confirm_account/bloc/confirm_account_event.dart';
import '../confirm_account/bloc/confirm_account_state.dart';

class ConfirmAccountPage extends StatelessWidget {
  final String? initialWhatsapp;
  ConfirmAccountPage({super.key, this.initialWhatsapp});

  final TextEditingController whatsappCtrl = TextEditingController();
  final TextEditingController codeCtrl = TextEditingController();

  void _submit(BuildContext context, String lang) {
    final whatsappRaw = whatsappCtrl.text.trim();
    final code = codeCtrl.text.trim();
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
    if (code.isEmpty || !RegExp(r'^\d+$').hasMatch(code)) {
      AppMessage.show(
        context,
        AppLocalizations.text(lang, 'enterCode'),
        type: AppMessageType.error,
        minimal: true,
      );
      return;
    }
    context.read<ConfirmAccountBloc>().add(
      ConfirmAccountSubmit(whatsapp: digits, code: code),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (initialWhatsapp != null && whatsappCtrl.text.isEmpty) {
      whatsappCtrl.text = initialWhatsapp!;
    }
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settings) {
        final lang = settings.languageCode;
        return BlocProvider(
          create: (_) => ConfirmAccountBloc(),
          child: Scaffold(
            body: BlocConsumer<ConfirmAccountBloc, ConfirmAccountState>(
              listener: (context, state) {
                if (state is ConfirmAccountSuccess) {
                  AppMessage.show(
                    context,
                    state.message,
                    type: AppMessageType.success,
                    minimal: true,
                  );
                  context.go('/login');
                } else if (state is ConfirmAccountError) {
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
                            AppLocalizations.text(lang, 'confirmAccountDesc'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 24),
                        AppInputField(
                          label: AppLocalizations.text(lang, 'whatsapp'),
                          type: InputType.phone,
                          controller: whatsappCtrl,
                        ),
                        const SizedBox(height: 16),
                        AppInputField(
                          label: AppLocalizations.text(lang, 'code'),
                          type: InputType.text,
                          controller: codeCtrl,
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          label: AppLocalizations.text(lang, 'confirmAccount'),
                          isLoading: state is ConfirmAccountLoading,
                          onPressed: () => _submit(context, lang),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: AppButton(
                            label: AppLocalizations.text(lang, 'resendCode'),
                            isLink: true,
                            onPressed: () {
                              final digits = whatsappCtrl.text.replaceAll(
                                RegExp(r'\D'),
                                '',
                              );
                              context.go('/resend-code', extra: digits);
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
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
