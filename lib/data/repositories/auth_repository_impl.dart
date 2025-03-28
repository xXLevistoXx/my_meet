import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseService _service;

  AuthRepositoryImpl(this._service);

  @override
  Future<User> login(String email, String password) async {
    final firebaseUser = await _service.login(email, password);
    return UserModel.fromFirebaseUser(firebaseUser.user!);
  }

  @override
  Future<User> register(String email, String password) async {
    final firebaseUser = await _service.register(email, password);
    return UserModel.fromFirebaseUser(firebaseUser.user!);
  }

  @override
  Future<void> logout() {
    return _service.logout();
  }
}