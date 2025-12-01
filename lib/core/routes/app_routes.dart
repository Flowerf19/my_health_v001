import 'package:flutter/material.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/profile/screens/profile_screen.dart' show ProfileScreen;
import '../../screens/onboarding1.dart'; // Thêm Onboarding1
import '../../screens/onboarding2.dart';
import '../../screens/onboarding3.dart';
import '../../screens/home_screen.dart';
import '../../screens/chat_screen.dart'; // Thêm ChatScreen
import '../../screens/report_screen.dart'; // Thêm ReportScreen
import '../../screens/main_screen.dart'; // Thêm MainScreen
import '../../screens/splash_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const Onboarding1());
      case '/onboarding2':
        return MaterialPageRoute(builder: (_) => const Onboarding2());
      case '/onboarding3':
        return MaterialPageRoute(builder: (_) => const Onboarding3());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/chat':
        return MaterialPageRoute(builder: (_) => ChatScreen());
      case '/report':
        return MaterialPageRoute(builder: (_) => const ReportScreen());
      case '/main':
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        ); // Thêm MainScreen
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('Không tìm thấy trang: ${settings.name}'),
                ),
              ),
        );
    }
  }
}
