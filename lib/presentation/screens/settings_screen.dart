import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_meet/presentation/blocks/theme_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Настройки')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Тема приложения', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return DropdownButtonFormField<ThemeMode>(
                  value: state.themeMode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  onChanged: (ThemeMode? newValue) {
                    if (newValue != null) {
                      context.read<ThemeBloc>().add(ChangeTheme(newValue));
                    }
                  },
                  items: [
                    DropdownMenuItem(value: ThemeMode.system, child: Text('Системная')),
                    DropdownMenuItem(value: ThemeMode.light, child: Text('Светлая')),
                    DropdownMenuItem(value: ThemeMode.dark, child: Text('Темная')),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}