import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/routes/app_routes.dart';
import 'features/auth/providers/auth_provider.dart';
import 'firebase_options.dart';
import 'features/health_connect/services/health_connect_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        Provider<HealthConnectService>(
          create: (_) => HealthConnectService(),
        ),
      ],
      child: MaterialApp(
        title: 'Healthcare App',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
        initialRoute: '/',
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
