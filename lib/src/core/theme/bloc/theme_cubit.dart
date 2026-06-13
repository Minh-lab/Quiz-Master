import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _prefs;
  static const _themeKey = 'theme_mode';

  ThemeCubit({required SharedPreferences prefs})
      : _prefs = prefs,
        super(_loadTheme(prefs));

  static ThemeMode _loadTheme(SharedPreferences prefs) {
    final themeString = prefs.getString(_themeKey);
    if (themeString == 'dark') return ThemeMode.dark;
    if (themeString == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  void toggleTheme() {
    if (state == ThemeMode.light || state == ThemeMode.system) {
      emit(ThemeMode.dark);
      _prefs.setString(_themeKey, 'dark');
    } else {
      emit(ThemeMode.light);
      _prefs.setString(_themeKey, 'light');
    }
  }

  void setTheme(ThemeMode mode) {
    emit(mode);
    if (mode == ThemeMode.dark) {
      _prefs.setString(_themeKey, 'dark');
    } else if (mode == ThemeMode.light) {
      _prefs.setString(_themeKey, 'light');
    } else {
      _prefs.setString(_themeKey, 'system');
    }
  }
}
