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
import '../recover/bloc/recover_password_bloc.dart';
import '../recover/bloc/recover_password_event.dart';
import '../recover/bloc/recover_password_state.dart';

class RecoverPasswordPage extends StatelessWidget {
  RecoverPasswordPage({super.key});

  final TextEditingController whatsappCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settings) {
        final lang = settings.languageCode;
        return BlocProvider(
          create: (_) => RecoverPasswordBloc(),
          child: Scaffold(
            body: BlocConsumer<RecoverPasswordBloc, RecoverPasswordState>(
              listener: (context, state) {
                if (state is RecoverPasswordSuccess) {
                  AppMessage.show(
                    context,
                    state.message,
                    type: AppMessageType.success,
                    minimal: true,
                  );
                  final digits = whatsappCtrl.text.replaceAll(
                    RegExp(r'\D'),
                    '',
                  );
                  context.go('/confirm-password', extra: digits);
                } else if (state is RecoverPasswordError) {
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
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            AppLocalizations.text(lang, 'recoverPassword'),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            AppLocalizations.text(lang, 'recoverPasswordDesc'),
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
                        const SizedBox(height: 24),
                        AppButton(
                          label: AppLocalizations.text(lang, 'send'),
                          isLoading: state is RecoverPasswordLoading,
                          onPressed: () {
                            final whatsapp = whatsappCtrl.text.trim();
                            context.read<RecoverPasswordBloc>().add(
                              RecoverPasswordSubmit(whatsapp),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: AppButton(
                            label: AppLocalizations.text(
                              lang,
                              'alreadyHaveCodePassword',
                            ),
                            isLink: true,
                            onPressed: () {
                              final digits = whatsappCtrl.text.replaceAll(
                                RegExp(r'\D'),
                                '',
                              );
                              context.go('/confirm-password', extra: digits);
                            },
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
