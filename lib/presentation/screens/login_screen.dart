import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_meet/presentation/blocks/auth_bloc.dart';
import 'package:my_meet/presentation/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _resetEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вход')),
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.black),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                obscureText: true,
                style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.black),
              ),
              SizedBox(height: 20),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                child: CustomButton(
                  text: 'Войти',
                  onPressed: () {
                    if (_validateEmail(_emailController.text) == null && _validatePassword(_passwordController.text) == null) {
                      context.read<AuthBloc>().add(LoginEvent(_emailController.text, _passwordController.text));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Проверьте введенные данные')));
                    }
                  },
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text('Нет аккаунта? Зарегистрируйтесь'),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Сброс пароля'),
                      content: TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onChanged: (value) => _resetEmail = value,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (_resetEmail != null && _validateEmail(_resetEmail!) == null) {
                              FirebaseAuth.instance.sendPasswordResetEmail(email: _resetEmail!);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Письмо для сброса пароля отправлено')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Введите корректный email')));
                            }
                          },
                          child: Text('Отправить'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Забыли пароль?'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return 'Введите email';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Неверный формат email';
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) return 'Введите пароль';
    if (value.length < 6) return 'Пароль должен быть не менее 6 символов';
    return null;
  }
}