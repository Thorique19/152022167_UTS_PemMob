import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Mendeklarasikan controller dan animasi
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Inisialisasi animasi fade
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    // Inisialisasi animasi slide
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    // Memulai animasi
    _controller.forward();

    // Navigasi setelah 5 detik
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.grey[900]!,
              Colors.grey[850]!,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo dan Judul
                        Text(
                          "RIQ",
                          style: GoogleFonts.spaceMono(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24, width: 1),
                          ),
                          child: Text(
                            "ILLUMINATE THE FUTURE",
                            style: GoogleFonts.spaceMono(
                              fontSize: 12,
                              color: Colors.white70,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),

                        // Foto Profil
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.05),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.white10,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/melogo.png',
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Nama
                        Text(
                          "THORIQ NAJMU",
                          style: GoogleFonts.spaceMono(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // NIM
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            border: Border.all(color: Colors.white24, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "152022167",
                            style: GoogleFonts.spaceMono(
                              fontSize: 16,
                              color: Colors.white70,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),

                        // Loading Indicator
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withOpacity(0.7)),
                            strokeWidth: 2,
                            backgroundColor: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
