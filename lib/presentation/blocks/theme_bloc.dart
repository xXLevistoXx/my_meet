import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(ThemeMode.system)) {
    on<LoadTheme>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt('theme_mode') ?? 0;
      emit(ThemeState(ThemeMode.values[themeIndex]));
    });

    on<ChangeTheme>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('theme_mode', event.themeMode.index);
      emit(ThemeState(event.themeMode));
    });
  }
}