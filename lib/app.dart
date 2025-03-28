import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_meet/data/repositories/auth_repository_impl.dart';
import 'package:my_meet/data/repositories/event_repository_impl.dart';
import 'package:my_meet/data/services/firebase_service.dart';
import 'package:my_meet/domain/usecases/login_usecase.dart';
import 'package:my_meet/domain/usecases/register_usecase.dart';
import 'package:my_meet/presentation/blocks/auth_bloc.dart';
import 'package:my_meet/presentation/blocks/event_bloc.dart';
import 'package:my_meet/presentation/blocks/theme_bloc.dart';
import 'package:my_meet/presentation/screens/create_event_screen.dart';
import 'package:my_meet/presentation/screens/edit_event_screen.dart';
import 'package:my_meet/presentation/screens/event_details_screen.dart';
import 'package:my_meet/presentation/screens/home_screen.dart';
import 'package:my_meet/presentation/screens/login_screen.dart';
import 'package:my_meet/presentation/screens/register_screen.dart';
import 'package:my_meet/presentation/screens/settings_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();
    final authRepository = AuthRepositoryImpl(firebaseService);
    final loginUseCase = LoginUseCase(authRepository);
    final registerUseCase = RegisterUseCase(authRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(loginUseCase, registerUseCase)),
        BlocProvider(create: (_) => EventBloc(EventRepositoryImpl(firebaseService))),
        BlocProvider(create: (_) => ThemeBloc()..add(LoadTheme())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'My Meet',
            theme: ThemeData(
              colorScheme: ColorScheme(
                primary: Color(0xFFDABF8E),
                secondary: Color(0xFF78866B),
                surface: Colors.white,
                background: Color(0xFFF5F5F5),
                error: Colors.red,
                onPrimary: Colors.black,
                onSecondary: Colors.white,
                onSurface: Colors.black,
                onBackground: Colors.black,
                onError: Colors.white,
                brightness: Brightness.light,
              ),
              scaffoldBackgroundColor: Color(0xFFF5F5F5),
              textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
              appBarTheme: AppBarTheme(color: Color(0xFFDABF8E)),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF78866B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme(
                primary: Color(0xFF8B6F47),
                secondary: Color(0xFF4A5E3C),
                surface: Color(0xFF2A2A2A),
                background: Color(0xFF1E1E1E),
                error: Colors.red,
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onSurface: Colors.white,
                onBackground: Colors.white,
                onError: Colors.white,
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: Color(0xFF1E1E1E),
              textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
              appBarTheme: AppBarTheme(color: Color(0xFF8B6F47)),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A5E3C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            themeMode: themeState.themeMode,
            initialRoute: '/login',
            routes: {
              '/login': (_) => LoginScreen(),
              '/register': (_) => RegisterScreen(),
              '/home': (_) => HomeScreen(),
              '/create_event': (_) => CreateEventScreen(),
              '/edit_event': (context) => EditEventScreen(eventId: ModalRoute.of(context)!.settings.arguments as String),
              '/event_details': (context) => EventDetailsScreen(eventId: ModalRoute.of(context)!.settings.arguments as String),
              '/settings': (_) => SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}