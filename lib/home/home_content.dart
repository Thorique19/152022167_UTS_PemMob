import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/buildCard/cryptocurrency.dart';
import 'package:riqapp/buildCard/financial.dart';
import 'package:riqapp/buildCard/jadwal.dart';
import 'package:riqapp/buildCard/note.dart';
import 'package:riqapp/buildCard/calculator_menu.dart';
import 'package:riqapp/custom_colors.dart' as customColors;
import 'package:riqapp/buildCard/bmkgData.dart';
import 'package:riqapp/animationCard/homeAnimation.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Create staggered animations for each card
    for (int i = 0; i < 6; i++) {
      _animations.add(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            i * 0.1, // Start each animation at an offset
            (i + 1) * 0.1, // Ensure the end value doesn't exceed 1.0
            curve: Curves.easeOut,
          ),
        ),
      );
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated welcome section
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.5),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _controller,
                curve: Curves.easeOut,
              )),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      customColors.CustomColors.primaryColor.withOpacity(0.1),
                      customColors.CustomColors.primaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang!',
                      style: GoogleFonts.bitter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: customColors.CustomColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Apa yang ingin Anda lakukan hari ini?',
                      style: GoogleFonts.bitter(
                        fontSize: 16,
                        color: customColors.CustomColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                HomeAnimated(
                  animation: _animations[0],
                  icon: Icons.money_sharp,
                  title: 'Finance',
                  subtitle: 'Atur Keuangan Anda!',
                  gradientColors: [
                    customColors.CustomColors.primaryColor.withOpacity(0.8),
                    customColors.CustomColors.primaryColor.withOpacity(0.6),
                  ],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FinancialPage()),
                  ),
                ),
                HomeAnimated(
                  animation: _animations[1],
                  icon: Icons.calculate,
                  title: 'Calculator',
                  subtitle: 'Perhitungan Matematis',
                  gradientColors: [
                    customColors.CustomColors.primaryLight.withOpacity(0.8),
                    customColors.CustomColors.primaryLight.withOpacity(0.6),
                  ],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CalculatorMenu()),
                  ),
                ),
                HomeAnimated(
                  animation: _animations[2],
                  icon: Icons.note_add,
                  title: 'Catatan',
                  subtitle: 'Buat catatan baru',
                  gradientColors: [
                    customColors.CustomColors.primaryColor.withOpacity(0.7),
                    customColors.CustomColors.primaryColor.withOpacity(0.5),
                  ],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotePage()),
                  ),
                ),
                HomeAnimated(
                  animation: _animations[3],
                  icon: Icons.calendar_today,
                  title: 'Jadwal',
                  subtitle: 'Atur jadwal Anda',
                  gradientColors: [
                    customColors.CustomColors.primaryLight.withOpacity(0.7),
                    customColors.CustomColors.primaryLight.withOpacity(0.5),
                  ],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Schedule()),
                  ),
                ),
                HomeAnimated(
                  animation: _animations[4],
                  icon: Icons.currency_bitcoin_sharp,
                  title: 'Cryptocurrency',
                  subtitle: 'Market & Chart',
                  gradientColors: [
                    customColors.CustomColors.primaryColor.withOpacity(0.6),
                    customColors.CustomColors.primaryColor.withOpacity(0.4),
                  ],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Cryptocurrency()),
                  ),
                ),
                HomeAnimated(
                  animation: _animations[5],
                  icon: Icons.local_post_office,
                  title: 'BMKG',
                  subtitle: 'Data Gempa BMKG',
                  gradientColors: [
                    customColors.CustomColors.primaryLight.withOpacity(0.6),
                    customColors.CustomColors.primaryLight.withOpacity(0.4),
                  ],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BmkgDataPage()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
