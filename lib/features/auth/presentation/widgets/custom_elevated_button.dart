import 'package:flutter/material.dart';

import 'package:verbisense/core/themes/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onTap,
    required this.text,
    this.backgroundColor,
    this.icon,
    this.loading = false,
  });

  final void Function() onTap;
  final String text;
  final Color? backgroundColor;
  final IconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor ?? ThemeColors.primary,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: backgroundColor != null
                ? ThemeColors.gray200
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Row(
                children: [
                  Icon(
                    icon,
                    color: backgroundColor != null
                        ? ThemeColors.black
                        : ThemeColors.white,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            if (loading) ...[
              SizedBox(
                width: 23,
                height: 23,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    backgroundColor != null
                        ? ThemeColors.black
                        : ThemeColors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            if (!loading)
              Text(
                text,
                style: backgroundColor == null
                    ? Theme.of(context).textTheme.titleSmall
                    : Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
