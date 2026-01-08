import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sgmc_app/logic/cubits/settings/settings_state.dart';

/// Settings Cubit - Manages app-wide settings
/// - Language (Arabic / English)
/// - Theme Mode (Light / Dark)
/// - First Launch detection
class SettingsCubit extends Cubit<SettingsState> {
  static const String _keyLanguage = 'app_language';
  static const String _keyThemeMode = 'app_theme_mode';
  static const String _keyFirstLaunch = 'app_first_launch';

  SettingsCubit() : super(SettingsInitial());

  /// Load settings from SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if this is first launch
    final isFirstLaunch = prefs.getBool(_keyFirstLaunch) ?? true;

    // Load language (default: English)
    final languageCode = prefs.getString(_keyLanguage) ?? 'en';
    final locale = Locale(languageCode);

    // Load theme mode (default: Light)
    final themeModeIndex = prefs.getInt(_keyThemeMode) ?? 0;
    final themeMode = ThemeMode.values[themeModeIndex];

    emit(
      SettingsLoaded(
        locale: locale,
        themeMode: themeMode,
        isFirstLaunch: isFirstLaunch,
      ),
    );
  }

  /// Change language
  Future<void> changeLanguage(String languageCode) async {
    if (state is! SettingsLoaded) return;

    final current = state as SettingsLoaded;
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyLanguage, languageCode);

    emit(current.copyWith(locale: Locale(languageCode)));
  }

  /// Change theme mode
  Future<void> changeThemeMode(ThemeMode mode) async {
    if (state is! SettingsLoaded) return;

    final current = state as SettingsLoaded;
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_keyThemeMode, mode.index);

    emit(current.copyWith(themeMode: mode));
  }

  /// Mark first launch as complete
  Future<void> completeFirstLaunch() async {
    if (state is! SettingsLoaded) return;

    final current = state as SettingsLoaded;
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_keyFirstLaunch, false);

    emit(current.copyWith(isFirstLaunch: false));
  }
}
