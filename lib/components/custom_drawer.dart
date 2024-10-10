import 'package:chatapp/auth/auth_service.dart';
import 'package:chatapp/pages/settings_page.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void logout() {
    // Auth Service
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Logo
                DrawerHeader(
                  child: Center(
                    child: Icon(
                      Icons.message,
                      color: Theme.of(context).colorScheme.primary,
                      size: 40,
                    ),
                  ),
                ),

                // Home list tile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("H O M E"),
                    leading: const Icon(Icons.home),
                    onTap: () {
                      // Pop drawer
                      Navigator.pop(context);
                    },
                  ),
                ),

                // Settings list tile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("S E T T I N G S"),
                    leading: const Icon(Icons.settings),
                    onTap: () {
                      // Pop drawer
                      Navigator.pop(context);

                      // Navigate to settings page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Logout list tile
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
              child: ListTile(
                title: const Text("L O G O U T"),
                leading: const Icon(Icons.logout),
                onTap: logout,
              ),
            ),
          ],
        ));
  }
}
