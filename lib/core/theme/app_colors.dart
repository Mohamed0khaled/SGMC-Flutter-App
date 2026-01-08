import 'package:flutter/material.dart';

/// App Color Palette
/// Professional, modern color scheme suitable for a service directory app
/// Emphasis on clarity, trust, and readability
class AppColors {
  // Primary Colors - Deep Blue (trust, professionalism)
  static const Color primary = Color(0xFF1976D2); // Material Blue 700
  static const Color primaryLight = Color(0xFF42A5F5); // Material Blue 400
  static const Color primaryDark = Color(0xFF0D47A1); // Material Blue 900

  // Secondary Colors - Teal Accent (modern, fresh)
  static const Color secondary = Color(0xFF00897B); // Teal 600
  static const Color secondaryLight = Color(0xFF4DB6AC); // Teal 300
  static const Color secondaryDark = Color(0xFF00695C); // Teal 800

  // Background Colors
  static const Color background = Color(0xFFF5F7FA); // Light gray-blue
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFFF0F4F8); // Very light blue-gray

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A); // Almost black
  static const Color textSecondary = Color(0xFF6B7280); // Medium gray
  static const Color textDisabled = Color(0xFF9CA3AF); // Light gray
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White

  // Border and Divider
  static const Color border = Color(0xFFE5E7EB); // Light gray
  static const Color divider = Color(0xFFE5E7EB);

  // Status Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color error = Color(0xFFEF4444); // Red
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color info = Color(0xFF3B82F6); // Blue

  // Shadows and Overlays
  static const Color shadow = Color(0x1A000000); // 10% black
  static const Color overlay = Color(0x4D000000); // 30% black

  // Icon Colors
  static const Color iconPrimary = Color(0xFF6B7280);
  static const Color iconSecondary = Color(0xFF9CA3AF);
  static const Color iconActive = primary;
}
