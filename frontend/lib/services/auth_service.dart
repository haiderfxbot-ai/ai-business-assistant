import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserModel?> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return _getUserData(cred.user!);
  }

  Future<UserModel?> signUpWithEmail(String email, String password, String name) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await cred.user!.updateDisplayName(name);
    final user = UserModel(
      uid: cred.user!.uid,
      email: email,
      displayName: name,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );
    await _firestore.collection('users').doc(cred.user!.uid).set(user.toMap());
    return user;
  }

  Future<UserModel?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    final auth = await googleUser.authentication;
    final cred = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final userCred = await _auth.signInWithCredential(cred);
    final userDoc = await _firestore.collection('users').doc(userCred.user!.uid).get();
    if (!userDoc.exists) {
      final user = UserModel(
        uid: userCred.user!.uid,
        email: userCred.user!.email,
        displayName: userCred.user!.displayName,
        photoURL: userCred.user!.photoURL,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );
      await _firestore.collection('users').doc(userCred.user!.uid).set(user.toMap());
      return user;
    }
    return _getUserData(userCred.user!);
  }

  Future<UserModel?> signInWithPhone(String phoneNumber) async {
    // Phone OTP flow - handled via Firebase Auth UI
    return null;
  }

  Future<UserModel?> signInAnonymously() async {
    final cred = await _auth.signInAnonymously();
    final user = UserModel(
      uid: cred.user!.uid,
      displayName: 'Guest',
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );
    await _firestore.collection('users').doc(cred.user!.uid).set(user.toMap());
    return user;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<UserModel?> _getUserData(User user) async {
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }
}
