import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTypography {
  AppTypography._();



  static TextStyle displayLarge({Color? color}) => GoogleFonts.mulish(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: color,
      );


  static TextStyle headlineLarge({Color? color}) => GoogleFonts.mulish(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
      );


  static TextStyle headlineMedium({Color? color}) => GoogleFonts.mulish(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
      );


  static TextStyle headlineSmall({Color? color}) => GoogleFonts.mulish(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle titleLarge({Color? color}) => GoogleFonts.mulish(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle titleMedium({Color? color}) => GoogleFonts.mulish(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle titleSmall({Color? color}) => GoogleFonts.mulish(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle bodyLarge({Color? color}) => GoogleFonts.mulish(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.mulish(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.4,
      );


  static TextStyle bodySmall({Color? color}) => GoogleFonts.mulish(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      );


  static TextStyle labelLarge({Color? color}) => GoogleFonts.mulish(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle labelMedium({Color? color}) => GoogleFonts.mulish(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      );

  
  static TextStyle labelSmall({Color? color}) => GoogleFonts.mulish(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      );


  static TextStyle scoreDisplay({Color? color}) => GoogleFonts.mulish(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: color,
      );

 
  static TextStyle timer({Color? color}) => GoogleFonts.mulish(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color,
      );
}
