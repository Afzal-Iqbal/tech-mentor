import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// TechSaathi AI Accessible Typography Hierarchy.
/// Designed for high legibility, large contrast, and comfortable reading for older adults.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get headingLarge => GoogleFonts.notoSans(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryText,
        height: 1.3,
      );

  static TextStyle get headingMedium => GoogleFonts.notoSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        height: 1.3,
      );

  static TextStyle get cardHeading => GoogleFonts.notoSans(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        height: 1.3,
      );

  static TextStyle get bodyLarge => GoogleFonts.notoSans(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: AppColors.primaryText,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.secondaryText,
        height: 1.4,
      );

  static TextStyle get buttonLabel => GoogleFonts.notoSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.2,
      );

  // Urdu typography fallback
  static TextStyle urduHeading({double fontSize = 26}) => GoogleFonts.notoNastaliqUrdu(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryText,
        height: 1.8,
      );

  static TextStyle urduBody({double fontSize = 18}) => GoogleFonts.notoNastaliqUrdu(
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
        color: AppColors.primaryText,
        height: 1.8,
      );
}
