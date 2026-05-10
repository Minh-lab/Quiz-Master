import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Hệ thống kiểu chữ ứng dụng Quiz Master
/// Font: Mulish (từ Figma)
class AppTypography {
  AppTypography._();

  // ===== Heading =====

  /// Tiêu đề lớn - dùng cho Splash, tên ứng dụng
  /// Figma: Mulish Regular 40px
  static TextStyle displayLarge({Color? color}) => GoogleFonts.mulish(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      );

  /// Tiêu đề trang
  /// Figma: Mulish SemiBold 24px
  static TextStyle headlineLarge({Color? color}) => GoogleFonts.mulish(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.black,
      );

  /// Tiêu đề section
  /// Figma: Mulish SemiBold 20px
  static TextStyle headlineMedium({Color? color}) => GoogleFonts.mulish(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.black,
      );

  /// Tiêu đề nhỏ (card, dialog)
  /// Figma: Mulish SemiBold 18px
  static TextStyle headlineSmall({Color? color}) => GoogleFonts.mulish(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.black,
      );

  // ===== Body =====

  /// Nội dung chính (câu hỏi, mô tả)
  /// Figma: Mulish Regular 16px
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.mulish(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.black,
        height: 1.5,
      );

  /// Nội dung phụ (đáp án, thông tin đề)
  /// Figma: Mulish Regular 14px
  static TextStyle bodyMedium({Color? color}) => GoogleFonts.mulish(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.black,
        height: 1.4,
      );

  /// Nội dung nhỏ
  static TextStyle bodySmall({Color? color}) => GoogleFonts.mulish(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.black,
      );

  // ===== Label =====

  /// Nhãn nút bấm
  /// Figma: Mulish SemiBold 16px
  static TextStyle labelLarge({Color? color}) => GoogleFonts.mulish(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.white,
      );

  /// Nhãn tab, category
  /// Figma: Mulish SemiBold 14px
  static TextStyle labelMedium({Color? color}) => GoogleFonts.mulish(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.black,
      );

  /// Nhãn nhỏ (metadata, caption)
  /// Figma: Mulish Regular 12px
  static TextStyle labelSmall({Color? color}) => GoogleFonts.mulish(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? const Color(0xFF757575),
      );

  // ===== Đặc biệt =====

  /// Điểm số lớn (màn hình kết quả)
  static TextStyle scoreDisplay({Color? color}) => GoogleFonts.mulish(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: color ?? Colors.black,
      );

  /// Timer đếm ngược
  static TextStyle timer({Color? color}) => GoogleFonts.mulish(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      );
}
