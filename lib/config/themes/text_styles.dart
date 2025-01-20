import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Headings
  static TextStyle get headingLarge => GoogleFonts.poppins(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get headingMedium => GoogleFonts.poppins(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get headingSmall => GoogleFonts.poppins(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get deviceType => GoogleFonts.poppins(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      );

  // Body Text
  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
      );

  // Labels
  static TextStyle get labelLarge => GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get labelMedium => GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get labelSmall => GoogleFonts.poppins(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      );

  // Button Text
  static TextStyle get buttonLarge => GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get buttonMedium => GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get buttonSmall => GoogleFonts.poppins(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
      );

  // Subtitle
  static TextStyle get subtitle => GoogleFonts.poppins(
        fontSize: 16.sp,
        color: Colors.grey[600],
      );

  // Error Text
  static TextStyle get error => GoogleFonts.poppins(
        color: Colors.red,
        fontSize: 12.sp,
      );

  // Input Field
  static TextStyle get input => GoogleFonts.poppins(
        fontSize: 14.sp,
      );

  static TextStyle get inputLabel => GoogleFonts.poppins(
        fontSize: 14.sp,
        color: Colors.grey[700],
      );

  static TextStyle get inputHint => GoogleFonts.poppins(
        fontSize: 14.sp,
        color: Colors.grey,
      );

  // Helper functions to modify existing styles
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
}
