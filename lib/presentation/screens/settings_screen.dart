import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgmc_app/core/localization/app_localizations.dart';
import 'package:sgmc_app/core/theme/app_colors.dart';
import 'package:sgmc_app/core/theme/app_text_styles.dart';
import 'package:sgmc_app/core/theme/app_theme.dart';
import 'package:sgmc_app/logic/cubits/settings/settings_cubit.dart';
import 'package:sgmc_app/logic/cubits/settings/settings_state.dart';

/// Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is! SettingsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            children: [
              // Language Section
              _SectionHeader(title: l10n.language),
              const SizedBox(height: AppDimensions.spacingSmall),
              _LanguageTile(currentLanguage: state.locale.languageCode),
              
              const SizedBox(height: AppDimensions.spacingLarge),

              // Theme Section
              _SectionHeader(title: l10n.themeMode),
              const SizedBox(height: AppDimensions.spacingSmall),
              _ThemeTile(currentTheme: state.themeMode),
              
              const SizedBox(height: AppDimensions.spacingLarge),

              // About Developer Section
              _SectionHeader(title: l10n.aboutDeveloper),
              const SizedBox(height: AppDimensions.spacingSmall),
              _AboutDeveloperCard(),
            ],
          );
        },
      ),
    );
  }
}

/// Section Header
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Language Selection Tile
class _LanguageTile extends StatelessWidget {
  final String currentLanguage;

  const _LanguageTile({required this.currentLanguage});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Column(
        children: [
          RadioListTile<String>(
            value: 'ar',
            groupValue: currentLanguage,
            title: Row(
              children: [
                const Text('🇪🇬', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Text(l10n.arabic),
              ],
            ),
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsCubit>().changeLanguage(value);
              }
            },
          ),
          const Divider(height: 1),
          RadioListTile<String>(
            value: 'en',
            groupValue: currentLanguage,
            title: Row(
              children: [
                const Text('🇺🇸', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Text(l10n.english),
              ],
            ),
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsCubit>().changeLanguage(value);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Theme Selection Tile
class _ThemeTile extends StatelessWidget {
  final ThemeMode currentTheme;

  const _ThemeTile({required this.currentTheme});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Column(
        children: [
          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: currentTheme,
            title: Row(
              children: [
                const Icon(Icons.light_mode, size: 24),
                const SizedBox(width: 12),
                Text(l10n.lightMode),
              ],
            ),
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsCubit>().changeThemeMode(value);
              }
            },
          ),
          const Divider(height: 1),
          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: currentTheme,
            title: Row(
              children: [
                const Icon(Icons.dark_mode, size: 24),
                const SizedBox(width: 12),
                Text(l10n.darkMode),
              ],
            ),
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsCubit>().changeThemeMode(value);
              }
            },
          ),
          const Divider(height: 1),
          RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            groupValue: currentTheme,
            title: Row(
              children: [
                const Icon(Icons.brightness_auto, size: 24),
                const SizedBox(width: 12),
                Text(l10n.systemMode),
              ],
            ),
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsCubit>().changeThemeMode(value);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// About Developer Card
class _AboutDeveloperCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          children: [
            // Developer Avatar
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingMedium),

            // Developer Info
            Text(
              isArabic ? 'محمد خالد' : 'Mohamed Khaled',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingSmall),

            Text(
              isArabic
                  ? 'مطور تطبيقات Flutter'
                  : 'Flutter Developer',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingMedium),

            // Bio
            Text(
              isArabic
                  ? 'متخصص في تطوير تطبيقات الهاتف المحمول باستخدام Flutter مع التركيز على Clean Architecture والتصميم الحديث.'
                  : 'Specialized in mobile app development using Flutter with focus on Clean Architecture and modern design.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
