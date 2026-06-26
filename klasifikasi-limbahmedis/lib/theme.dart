import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF1A3A6B);       // navy gelap
  static const primaryLight = Color(0xFF2756A8);   // biru gelap
  static const accent = Color(0xFF4A90D9);          // biru muda
  static const background = Color(0xFFF5F7FA);
  static const surface = Colors.white;
  static const textDark = Color(0xFF1A1A2E);
  static const textMuted = Color(0xFF8A94A6);
  static const yellow = Color(0xFFFFC107);
  static const yellowBg = Color(0xFFFFF8E1);
  static const infeksius = Color(0xFFFFC107);
  static const farmasi = Color(0xFF8D6E63);
  static const sitotoksik = Color(0xFF9C27B0);
  static const domestik = Color(0xFF4CAF50);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        // 👇 Sudah jadi Inter semua
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textDark),
          titleTextStyle: GoogleFonts.inter(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      );
}