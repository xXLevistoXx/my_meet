import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({required String id, required String email}) : super(id: id, email: email);

  factory UserModel.fromFirebaseUser(firebase.User firebaseUser) {
    return UserModel(id: firebaseUser.uid, email: firebaseUser.email!);
  }
}