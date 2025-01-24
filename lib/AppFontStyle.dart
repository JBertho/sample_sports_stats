
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AppColors.dart';

class AppFontStyle {
  static TextStyle anton = GoogleFonts.anton();

  static TextStyle header = GoogleFonts.anton(
      textStyle: const TextStyle(
          fontSize: 40, color: AppColors.blue));

  static TextStyle scoreHeader = GoogleFonts.anton(
      textStyle: const TextStyle(
          fontSize: 32, color: AppColors.blue));

  static TextStyle smallComplement = GoogleFonts.anton(
      textStyle: const TextStyle(
          fontSize: 16, color: AppColors.greyComplement));
}