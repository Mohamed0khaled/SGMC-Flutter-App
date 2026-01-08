import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgmc_app/core/theme/app_colors.dart';
import 'package:sgmc_app/core/theme/app_text_styles.dart';
import 'package:sgmc_app/core/theme/app_theme.dart';
import 'package:sgmc_app/logic/cubits/settings/settings_cubit.dart';

/// Language Selection Screen - Shown on first launch
class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo or Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.language,
                  size: 50,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: AppDimensions.spacingLarge),

              // Title
              Text(
                'Select Language',
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.spacingSmall),

              // Description
              Text(
                'Choose your preferred language',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.spacingExtraLarge),

              // Language Options
              _LanguageOption(
                title: 'العربية',
                subtitle: 'Arabic',
                flag: '🇪🇬',
                onTap: () => _selectLanguage(context, 'ar'),
              ),

              const SizedBox(height: AppDimensions.spacingMedium),

              _LanguageOption(
                title: 'English',
                subtitle: 'English',
                flag: '🇺🇸',
                onTap: () => _selectLanguage(context, 'en'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectLanguage(BuildContext context, String languageCode) async {
    final settingsCubit = context.read<SettingsCubit>();
    
    // Change language
    await settingsCubit.changeLanguage(languageCode);
    
    // Mark first launch as complete
    await settingsCubit.completeFirstLaunch();
  }
}

/// Language Option Card
class _LanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String flag;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Row(
            children: [
              // Flag
              Text(
                flag,
                style: const TextStyle(fontSize: 40),
              ),

              const SizedBox(width: AppDimensions.spacingMedium),

              // Language Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.iconSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
