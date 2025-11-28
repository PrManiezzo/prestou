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
import '../resend_code/bloc/resend_code_bloc.dart';
import '../resend_code/bloc/resend_code_event.dart';
import '../resend_code/bloc/resend_code_state.dart';

class ResendCodePage extends StatelessWidget {
  final String? initialWhatsapp;
  ResendCodePage({super.key, this.initialWhatsapp});

  final TextEditingController whatsappCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (initialWhatsapp != null && whatsappCtrl.text.isEmpty) {
      whatsappCtrl.text = initialWhatsapp!;
    }
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settings) {
        final lang = settings.languageCode;
        return BlocProvider(
          create: (_) => ResendCodeBloc(),
          child: Scaffold(
            body: BlocConsumer<ResendCodeBloc, ResendCodeState>(
              listener: (context, state) {
                if (state is ResendCodeSuccess) {
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
                  context.go('/confirm-account', extra: digits);
                } else if (state is ResendCodeError) {
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
                            AppLocalizations.text(lang, 'resendCodeDesc'),
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
                          label: AppLocalizations.text(lang, 'resendCode'),
                          isLoading: state is ResendCodeLoading,
                          onPressed: () {
                            final whatsapp = whatsappCtrl.text.trim();
                            final digits = whatsapp.replaceAll(
                              RegExp(r'\D'),
                              '',
                            );
                            if (digits.length < 11) {
                              AppMessage.show(
                                context,
                                AppLocalizations.text(lang, 'invalidWhatsapp'),
                                type: AppMessageType.error,
                                minimal: true,
                              );
                              return;
                            }
                            context.read<ResendCodeBloc>().add(
                              ResendCodeSubmit(digits),
                            );
                          },
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
