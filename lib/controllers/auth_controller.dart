import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User> registerUser(String email, String password, String namaLengkap, String nik) async {
    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user;
      if (user == null) throw Exception('Gagal membuat akun');

      // Simpan data user ke Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'createdAt': FieldValue.serverTimestamp(),
        'nama_lengkap': namaLengkap,
        'nik': nik,
        'no_telepon': '', // default kosong
        'password': password,
        'photoUrl': '', // default kosong
        'role': 'user', // default user
      });

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? e.code);
    }
  }

  Future<User> signInUser(String email, String password) async {
    try {
      final UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user;
      if (user == null) throw Exception('Gagal masuk');
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? e.code);
    }
  }

  Future<void> signOut() async => _auth.signOut();

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }
}