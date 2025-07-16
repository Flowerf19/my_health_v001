import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../../health_connect/widgets/health_connect_card.dart';
import '../../health_connect/providers/health_connect_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HealthConnectProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // TODO: Navigate to settings
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(
                name: 'John Doe',
                email: 'john.doe@example.com',
                onEditPressed: () {
                  // TODO: Navigate to edit profile
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const HealthConnectCard(),
              const SizedBox(height: 16),
              ProfileMenuItem(
                icon: Icons.person,
                title: 'Personal Information',
                onTap: () {
                  // TODO: Navigate to personal information
                },
              ),
              ProfileMenuItem(
                icon: Icons.medical_services,
                title: 'Health Records',
                onTap: () {
                  // TODO: Navigate to health records
                },
              ),
              ProfileMenuItem(
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () {
                  // TODO: Navigate to notifications
                },
              ),
              ProfileMenuItem(
                icon: Icons.help,
                title: 'Help & Support',
                onTap: () {
                  // TODO: Navigate to help & support
                },
              ),
              ProfileMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  // TODO: Handle logout
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
