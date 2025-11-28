import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isLink;
  final double borderRadius;
  final Color? color;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isLink = false,
    this.borderRadius = 12,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isLink) {
      return GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: textColor ?? Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? const SizedBox(
                  key: ValueKey("loading"),
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
              : Text(
                  key: const ValueKey("label"),
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
