import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/login.dart';

class CustomColors {
  static const primaryColor = Color(0xFF545454);
  static const primaryLight = Color(0xFF787878);
  static const primaryDark = Color(0xFF363636);
  static const accentColor = Color(0xFFE0E0E0);
  static const backgroundColor = Colors.white;
  static const errorColor = Color(0xFFB00020);
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.backgroundColor,
        appBar: AppBar(
          title: Text(
            'Settings',
            style: GoogleFonts.bitter(color: Colors.white),
          ),
          backgroundColor: CustomColors.primaryDark,
          elevation: 0,
          automaticallyImplyLeading: false, // Menghilangkan tombol back
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Account Settings'),
              _buildSettingsTile(
                icon: Icons.person,
                title: 'Profile Information',
                subtitle: 'Change your account information',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.lock,
                title: 'Privacy & Security',
                subtitle: 'Password, security settings',
                onTap: () {},
              ),
              _buildDivider(),
              _buildSectionTitle('App Settings'),
              _buildSettingsTile(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Manage your notifications',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'Change app language',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.dark_mode,
                title: 'Theme',
                subtitle: 'Change app appearance',
                onTap: () {},
              ),
              _buildDivider(),
              _buildSectionTitle('Other'),
              _buildSettingsTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help or contact us',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'App version and information',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Sign out from your account',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout Confirmation'),
                        backgroundColor: Colors.white,
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Tambahkan logika logout di sini
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) =>
                                    false, // Hapus semua route sebelumnya
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: CustomColors.errorColor,
                            ),
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                textColor: CustomColors.errorColor,
              )
            ],
          ),
        )));
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: GoogleFonts.bitter(
          color: CustomColors.primaryLight,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Card(
      color: CustomColors.primaryDark,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: textColor ?? CustomColors.primaryLight),
        title: Text(
          title,
          style: GoogleFonts.bitter(
            color: textColor ?? Colors.white,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.bitter(
            color: (textColor ?? Colors.white).withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: textColor ?? Colors.white.withOpacity(0.7),
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: CustomColors.accentColor,
      thickness: 1,
      height: 32,
    );
  }
}
