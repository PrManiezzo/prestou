import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:prestou/app/config/app_localizations.dart';
import 'package:prestou/app/settings/settings_bloc.dart';
import 'package:prestou/app/settings/settings_state.dart';

enum InputType { text, email, phone, password, cpf, cnpj, cep, date, age }

class AppInputField extends StatefulWidget {
  final String label;
  final InputType type;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const AppInputField({
    super.key,
    required this.label,
    required this.type,
    this.controller,
    this.onChanged,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late TextEditingController displayController; // para mostrar com máscara
  bool obscure = true;
  bool touched = false;

  @override
  void initState() {
    super.initState();

    // Se for telefone, sempre usamos MaskedTextController para exibição
    if (widget.type == InputType.phone) {
      displayController = MaskedTextController(mask: '(00) 00000-0000');
      // Se o controller externo já tiver valor, aplica
      if (widget.controller != null && widget.controller!.text.isNotEmpty) {
        displayController.text = _applyMask(widget.controller!.text);
      }
    } else {
      displayController = widget.controller ?? TextEditingController();
    }
  }

  // Função para formatar número com máscara
  String _applyMask(String digits) {
    if (digits.isEmpty) return '';
    final clean = digits.replaceAll(RegExp(r'\D'), '');
    if (clean.length <= 2) return '($clean)';
    if (clean.length <= 7) {
      return '(${clean.substring(0, 2)}) ${clean.substring(2)}';
    }
    if (clean.length <= 11) {
      return '(${clean.substring(0, 2)}) ${clean.substring(2, 7)}-${clean.substring(7)}';
    }
    return clean;
  }

  String? _validator(String value, String lang) {
    if (!touched) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return AppLocalizations.text(lang, "requiredField");
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return switch (widget.type) {
      InputType.text =>
        (trimmed.length < 2) ? AppLocalizations.text(lang, "min2Chars") : null,
      InputType.email => (() {
        if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(trimmed)) {
          return AppLocalizations.text(lang, "invalidEmail");
        }
        return null;
      })(),
      InputType.password =>
        (value.length < 6) ? AppLocalizations.text(lang, "min6Chars") : null,
      InputType.phone =>
        (digits.length < 11)
            ? AppLocalizations.text(lang, "invalidPhone")
            : null,
      InputType.cpf =>
        (digits.length < 11)
            ? AppLocalizations.text(lang, "incompleteCPF")
            : null,
      InputType.cnpj =>
        (digits.length < 14)
            ? AppLocalizations.text(lang, "incompleteCNPJ")
            : null,
      InputType.cep =>
        (digits.length < 8)
            ? AppLocalizations.text(lang, "incompleteCEP")
            : null,
      InputType.date =>
        (digits.length < 8)
            ? AppLocalizations.text(lang, "incompleteDate")
            : null,
      InputType.age => (() {
        final age = int.tryParse(value);
        if (age == null) return AppLocalizations.text(lang, "invalidAge");
        if (age < 1 || age > 120) {
          return AppLocalizations.text(lang, "ageRange");
        }
        return null;
      })(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settings) {
        final lang = settings.languageCode;
        return StatefulBuilder(
          builder: (context, setSB) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: displayController,
                  obscureText: widget.type == InputType.password
                      ? obscure
                      : false,
                  keyboardType: switch (widget.type) {
                    InputType.phone => TextInputType.phone,
                    InputType.email => TextInputType.emailAddress,
                    InputType.cpf ||
                    InputType.cnpj ||
                    InputType.cep ||
                    InputType.date ||
                    InputType.age => TextInputType.number,
                    _ => TextInputType.text,
                  },
                  onChanged: (value) {
                    if (!touched) setSB(() => touched = true);

                    if (widget.type == InputType.phone) {
                      // Atualiza controller externo só com números
                      final digits = value.replaceAll(RegExp(r'\D'), '');
                      if (widget.controller != null) {
                        widget.controller!.text = digits;
                        widget
                            .controller!
                            .selection = TextSelection.fromPosition(
                          TextPosition(offset: widget.controller!.text.length),
                        );
                      }
                      widget.onChanged?.call(digits);
                    } else {
                      widget.onChanged?.call(value);
                    }

                    setSB(() {}); // Atualiza UI para validação
                  },
                  decoration: InputDecoration(
                    hintText: switch (widget.type) {
                      InputType.phone => AppLocalizations.text(
                        lang,
                        "hintPhone",
                      ),
                      InputType.email => AppLocalizations.text(
                        lang,
                        "hintEmail",
                      ),
                      InputType.text => AppLocalizations.text(lang, "hintText"),
                      InputType.cpf => AppLocalizations.text(lang, "hintCPF"),
                      InputType.cnpj => AppLocalizations.text(lang, "hintCNPJ"),
                      InputType.cep => AppLocalizations.text(lang, "hintCEP"),
                      InputType.date => AppLocalizations.text(lang, "hintDate"),
                      InputType.age => AppLocalizations.text(lang, "hintAge"),
                      InputType.password => AppLocalizations.text(
                        lang,
                        "hintPassword",
                      ),
                    },
                    errorText: _validator(displayController.text, lang),
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                    suffixIcon: widget.type == InputType.password
                        ? IconButton(
                            icon: Icon(
                              obscure ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () => setSB(() => obscure = !obscure),
                          )
                        : null,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
