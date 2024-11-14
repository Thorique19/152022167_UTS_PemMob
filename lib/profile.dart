import 'package:flutter/material.dart';
import 'package:riqapp/custom_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background gradient
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CustomColors.primaryColor,
                    CustomColors.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Logo
                    Image.asset(
                      'assets/images/whitelogo.png',
                      height: 60,
                      width: 60,
                    ),
                    const SizedBox(height: 30),
                    // Profile card
                    Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _ProfileHeader(),
                            SizedBox(height: 24.0),
                            _Divider(),
                            SizedBox(height: 24.0),
                            _AboutSection(),
                            SizedBox(height: 24.0),
                            _Divider(),
                            SizedBox(height: 24.0),
                            _SkillsSection(),
                            SizedBox(height: 24.0),
                            _Divider(),
                            SizedBox(height: 24.0),
                            _ContactSection(),
                            SizedBox(height: 24.0),
                            _SocialButtons(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(0.2),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.primaryColor.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const CircleAvatar(
                backgroundColor: CustomColors.primaryColor,
                radius: 60.0,
                backgroundImage: AssetImage('assets/images/me.png'),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Text(
          'Thoriq Najmu',
          style: GoogleFonts.bitter(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: CustomColors.primaryColor,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          'Creative Developer',
          style: GoogleFonts.bitter(
            fontSize: 16,
            color: CustomColors.primaryLight,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: CustomColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '✨ Available for freelance',
            style: GoogleFonts.bitter(
              fontSize: 14,
              color: CustomColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Me',
          style: GoogleFonts.bitter(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: CustomColors.primaryColor,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          'Passionate developer exploring the vast world of coding. Started as a script kiddie, now evolving into a creative problem solver. I believe in learning by doing and sharing knowledge with others. Currently focused on mobile development and UI/UX design.',
          style: GoogleFonts.bitter(
            fontSize: 16.0,
            height: 1.5,
            color: CustomColors.primaryLight,
          ),
        ),
      ],
    );
  }
}

class _SkillsSection extends StatelessWidget {
  const _SkillsSection();

  @override
  Widget build(BuildContext context) {
    final skills = [
      {'name': 'Flutter', 'level': 0.8},
      {'name': 'UI Design', 'level': 0.7},
      {'name': 'HTML', 'level': 0.6},
      {'name': 'PHP', 'level': 0.5},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills',
          style: GoogleFonts.bitter(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: CustomColors.primaryColor,
          ),
        ),
        const SizedBox(height: 12.0),
        ...skills.map((skill) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill['name'] as String,
                    style: GoogleFonts.bitter(
                      fontSize: 14.0,
                      color: CustomColors.primaryLight,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  LinearProgressIndicator(
                    value: skill['level'] as double,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    color: CustomColors.primaryColor,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: GoogleFonts.bitter(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: CustomColors.primaryColor,
          ),
        ),
        const SizedBox(height: 12.0),
        _ContactItem(
          icon: Icons.email,
          text: 'hurtcomfort19@gmail.com',
          onTap: () => _launchUrl('mailto:hurtcomfort19@gmail.com'),
        ),
        const SizedBox(height: 8.0),
        _ContactItem(
          icon: Icons.phone,
          text: '+628987951533',
          onTap: () => _launchUrl('https://wa.me/628987951533'),
        ),
        const SizedBox(height: 8.0),
        _ContactItem(
          icon: Icons.location_on,
          text: 'Bandung, Indonesia',
          onTap: () => _launchUrl('https://maps.app.goo.gl/gQHPNJAATQcsFFKQ9'),
        ),
      ],
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ContactItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: CustomColors.primaryColor),
          const SizedBox(width: 12.0),
          Text(
            text,
            style: GoogleFonts.bitter(
              fontSize: 16.0,
              color: CustomColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButtons extends StatelessWidget {
  const _SocialButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.instagram),
          color: CustomColors.primaryColor,
          onPressed: () => _launchUrl('https://www.instagram.com/thoriqnajmu_'),
        ),
        IconButton(
          icon: const Icon(FontAwesomeIcons.github),
          color: CustomColors.primaryColor,
          onPressed: () => _launchUrl('https://github.com/Thorique19'),
        ),
        IconButton(
          icon: const Icon(FontAwesomeIcons.linkedin),
          color: CustomColors.primaryColor,
          onPressed: () =>
              _launchUrl('https://www.linkedin.com/in/thoriqnajmu/'),
        ),
      ],
    );
  }
}

Future<void> _launchUrl(String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $urlString';
  }
}
