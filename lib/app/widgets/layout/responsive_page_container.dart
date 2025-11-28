import 'package:flutter/material.dart';

/// Container responsivo para reutilizar em páginas de formulário.
/// - Em telas largas (web / desktop) limita largura e centraliza.
/// - Em telas pequenas mantém layout padrão com padding.
class ResponsivePageContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double maxWidth;

  const ResponsivePageContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
    this.maxWidth = 520,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide =
            constraints.maxWidth > maxWidth + 48; // sob folga lateral
        final content = Padding(
          padding: padding,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          ),
        );
        return isWide
            ? Align(alignment: Alignment.topCenter, child: content)
            : content;
      },
    );
  }
}
