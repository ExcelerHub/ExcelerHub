import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool showTagline;

  const AppLogo({
    super.key,
    this.size = 64,
    this.showText = true,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusCard),
          ),
          child: Icon(
            Icons.school_outlined,
            color: AppColors.primary,
            size: size * 0.5,
          ),
        ),
        if (showText) ...[
          SizedBox(height: size * 0.25),
          Text(
            AppConstants.appName,
            style: TextStyle(
              fontSize: size * 0.42,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
        ],
        if (showTagline) ...[
          const SizedBox(height: 6),
          const Text(
            AppConstants.appTagline,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ],
    );
  }
}
