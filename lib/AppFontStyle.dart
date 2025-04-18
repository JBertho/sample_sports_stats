
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AppColors.dart';

class AppFontStyle {
  static TextStyle inter = GoogleFonts.inter();
  static TextStyle anton = GoogleFonts.anton();

  static TextStyle header = GoogleFonts.anton(
      textStyle: const TextStyle(
          fontSize: 40, color: AppColors.blue));

  static TextStyle blue34 = GoogleFonts.anton(
      textStyle: const TextStyle(
          fontSize: 34, color: AppColors.blue));

  static TextStyle teamHeader = GoogleFonts.anton(
      textStyle: const TextStyle(
          fontSize: 18, color: AppColors.blue, fontWeight: FontWeight.bold));

  static TextStyle scoreHeader = GoogleFonts.anton(
      textStyle: const TextStyle(
          fontSize: 32, color: AppColors.blue));

  static TextStyle smallComplement = GoogleFonts.anton(
      textStyle: const TextStyle(
          fontSize: 16, color: AppColors.greyComplement));
}