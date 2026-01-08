import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Settings State
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state - loading preferences
class SettingsInitial extends SettingsState {}

/// Settings loaded with user preferences
class SettingsLoaded extends SettingsState {
  final Locale locale;
  final ThemeMode themeMode;
  final bool isFirstLaunch;

  const SettingsLoaded({
    required this.locale,
    required this.themeMode,
    required this.isFirstLaunch,
  });

  @override
  List<Object?> get props => [locale, themeMode, isFirstLaunch];

  SettingsLoaded copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    bool? isFirstLaunch,
  }) {
    return SettingsLoaded(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    );
  }

  bool get isArabic => locale.languageCode == 'ar';
}
