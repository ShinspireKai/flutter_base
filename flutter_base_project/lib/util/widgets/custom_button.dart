import 'package:flutter/material.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.height = 52,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.borderRadius = 14,
    this.elevation = 2,
    this.isOutline = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final Color? backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final double elevation;
  final bool isOutline;

  @override
  Widget build(BuildContext context) {
    final color = backgroundColor ?? ColorName.btnColorPrimary;
    final contentColor = isOutline ? color : foregroundColor;

    final child = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              color: contentColor,
              strokeWidth: 2.5,
            ),
          )
        : Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: contentColor,
              fontWeight: FontWeight.w600,
            ),
          );

    return SizedBox(
      height: height,
      child: isOutline
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: child,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: foregroundColor,
                disabledBackgroundColor: color.withValues(alpha: 0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                elevation: elevation,
              ),
              child: child,
            ),
    );
  }
}
