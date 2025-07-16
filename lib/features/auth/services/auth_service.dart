import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Đăng nhập bằng email
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }

  // Đăng ký bằng email
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }

  // signInWithGoogle
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Lấy thông tin người dùng từ userCredential.user
      User? user = userCredential.user;
      return user;
    } catch (e) {
      print("Lỗi Google Sign-In: $e");
      return null;
    }
  }
  // Quên mật khẩu
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }

  // Xử lý thông báo lỗi
  String _handleAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Email không tồn tại';
      case 'wrong-password':
        return 'Mật khẩu không đúng';
      case 'email-already-in-use':
        return 'Email đã được sử dụng';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'weak-password':
        return 'Mật khẩu quá yếu';
      default:
        return 'Đã xảy ra lỗi';
    }
  }
}