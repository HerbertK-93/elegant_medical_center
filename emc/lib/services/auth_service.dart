import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get userChanges => _auth.userChanges();

  Future<User?> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<User?> signUp(
    String email,
    String password,
    String name,
    String role, {
    String? department,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = result.user;

    if (user != null) {
      final userModel = UserModel(
        uid: user.uid,
        name: name,
        email: email,
        role: role,
        department: role == "user" ? department : null, // only for users
      );

      await _db.collection('users').doc(user.uid).set(userModel.toMap());
    }

    return user;
  }

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!, uid);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
