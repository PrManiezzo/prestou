import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prestou/app/config/app_localizations.dart';
import 'package:prestou/app/settings/settings_bloc.dart';
import 'package:prestou/app/settings/settings_state.dart';
import 'package:prestou/app/widgets/buttons/app_button.dart';
import 'package:prestou/app/widgets/inputDefaut/app_input_field.dart';
import 'package:prestou/app/widgets/layout/responsive_page_container.dart';
import 'package:prestou/app/widgets/feedback/app_message.dart';
import '../register/bloc/register_bloc.dart';
import '../register/bloc/register_event.dart';
import '../register/bloc/register_state.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController whatsappCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController ageCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController pass2Ctrl = TextEditingController();

  void _submit(BuildContext context, String lang) {
    final whatsappRaw = whatsappCtrl.text.trim();
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final ageStr = ageCtrl.text.trim();
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
    if (name.isEmpty) {
      AppMessage.show(
        context,
        AppLocalizations.text(lang, 'enterName'),
        type: AppMessageType.error,
        minimal: true,
      );
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      AppMessage.show(
        context,
        AppLocalizations.text(lang, 'invalidEmail'),
        type: AppMessageType.error,
        minimal: true,
      );
      return;
    }
    final age = int.tryParse(ageStr);
    if (age == null || age < 1 || age > 120) {
      AppMessage.show(
        context,
        AppLocalizations.text(lang, 'invalidAge'),
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

    context.read<RegisterBloc>().add(
      RegisterSubmit(
        whatsapp: digits,
        name: name,
        password: pass,
        email: email,
        age: age,
      ),
    );
  }

  // Removed legacy SnackBar helper in favor of AppMessage.show

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settings) {
        final lang = settings.languageCode;
        return BlocProvider(
          create: (_) => RegisterBloc(),
          child: Scaffold(
            body: BlocConsumer<RegisterBloc, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccess) {
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
                } else if (state is RegisterError) {
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
                            AppLocalizations.text(lang, 'registerTitle'),
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
                          label: AppLocalizations.text(lang, 'name'),
                          type: InputType.text,
                          controller: nameCtrl,
                        ),
                        const SizedBox(height: 16),
                        AppInputField(
                          label: AppLocalizations.text(lang, 'email'),
                          type: InputType.email,
                          controller: emailCtrl,
                        ),
                        const SizedBox(height: 16),
                        AppInputField(
                          label: AppLocalizations.text(lang, 'age'),
                          type: InputType.age,
                          controller: ageCtrl,
                        ),
                        const SizedBox(height: 16),
                        AppInputField(
                          label: AppLocalizations.text(lang, 'password'),
                          type: InputType.password,
                          controller: passCtrl,
                        ),
                        const SizedBox(height: 16),
                        AppInputField(
                          label: AppLocalizations.text(lang, 'confirmPassword'),
                          type: InputType.password,
                          controller: pass2Ctrl,
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          label: AppLocalizations.text(lang, 'createAccount'),
                          isLoading: state is RegisterLoading,
                          onPressed: () => _submit(context, lang),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: AppButton(
                            label: AppLocalizations.text(
                              lang,
                              'alreadyHaveCode',
                            ),
                            isLink: true,
                            onPressed: () {
                              final digits = whatsappCtrl.text.replaceAll(
                                RegExp(r'\D'),
                                '',
                              );
                              context.go('/confirm-account', extra: digits);
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: AppButton(
                            label: AppLocalizations.text(
                              lang,
                              'alreadyHaveAccount',
                            ),
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
