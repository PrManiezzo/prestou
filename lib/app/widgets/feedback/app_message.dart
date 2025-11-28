import 'package:flutter/material.dart';

/// Tipo da mensagem.
enum AppMessageType { error, success, info }

/// Exibe uma mensagem de forma centralizada via Overlay.
class AppMessage {
  static void show(
    BuildContext context,
    String message, {
    AppMessageType type = AppMessageType.info,
    Duration duration = const Duration(seconds: 4),
    bool minimal = false,
    bool sanitize = true,
  }) {
    final overlay = Overlay.of(context);

    final theme = Theme.of(context);
    Color color;
    switch (type) {
      case AppMessageType.error:
        color = theme.colorScheme.error;
        break;
      case AppMessageType.success:
        color = Colors.green;
        break;
      case AppMessageType.info:
        color = theme.colorScheme.primary;
        break;
    }

    // Sanitiza mensagens verbosas de backend se for erro
    String displayMessage = message;
    if (type == AppMessageType.error && sanitize) {
      displayMessage = _sanitizeMessage(message);
    }

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _MessageBanner(
        message: displayMessage,
        color: color,
        type: type,
        minimal: minimal,
        onClose: () {
          if (entry.mounted) entry.remove();
        },
      ),
    );
    overlay.insert(entry);
    Future.delayed(duration, () {
      if (entry.mounted) entry.remove();
    });
  }

  // Tenta extrair apenas texto relevante de uma string de erro estruturada.
  static String _sanitizeMessage(String raw) {
    // Remove prefixos comuns
    String m = raw.trim();
    if (m.startsWith('Exception:')) {
      m = m.substring('Exception:'.length).trim();
    }
    // Se conter 'errors:' extrai lista
    final errorsIdx = m.indexOf('errors:');
    if (errorsIdx != -1) {
      // Busca colchetes após errors:
      final startList = m.indexOf('[', errorsIdx);
      final endList = m.indexOf(']', startList + 1);
      if (startList != -1 && endList != -1) {
        final listContent = m.substring(startList + 1, endList);
        final parts = listContent
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        if (parts.isNotEmpty) {
          return parts.join('\n');
        }
      }
    }
    // Caso tenha campo message: extrai
    final msgIdx = m.indexOf('message:');
    if (msgIdx != -1) {
      // termina no próximo ',' ou '}'
      int end = m.indexOf(',', msgIdx + 8);
      if (end == -1) end = m.indexOf('}', msgIdx + 8);
      if (end == -1) end = m.length;
      final val = m.substring(msgIdx + 8, end).trim();
      if (val.isNotEmpty) return val;
    }
    // Remove chaves envolventes
    if (m.startsWith('{') && m.endsWith('}')) {
      m = m.substring(1, m.length - 1).trim();
    }
    return m;
  }
}

class _MessageBanner extends StatefulWidget {
  final String message;
  final Color color;
  final AppMessageType type;
  final VoidCallback onClose;
  final bool minimal;
  const _MessageBanner({
    required this.message,
    required this.color,
    required this.type,
    required this.onClose,
    this.minimal = false,
  });

  @override
  State<_MessageBanner> createState() => _MessageBannerState();
}

class _MessageBannerState extends State<_MessageBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _offset = Tween(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData get _icon {
    switch (widget.type) {
      case AppMessageType.error:
        return Icons.error_outline;
      case AppMessageType.success:
        return Icons.check_circle_outline;
      case AppMessageType.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shadow = Theme.of(context).brightness == Brightness.dark
        ? Colors.black54
        : Colors.black26;
    final baseColor = widget.color;
    final bgColor = widget.minimal ? Colors.white : baseColor.withOpacity(0.93);
    final textColor = widget.minimal ? Colors.black87 : Colors.white;
    final iconColor = widget.minimal ? baseColor : Colors.white;
    return Positioned(
      top: 12,
      left: 12,
      right: 12,
      child: SlideTransition(
        position: _offset,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: widget.minimal
                  ? Border.all(color: baseColor, width: 1.2)
                  : null,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  spreadRadius: 1,
                  color: shadow,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_icon, color: iconColor, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (!widget.minimal)
                  GestureDetector(
                    onTap: widget.onClose,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
