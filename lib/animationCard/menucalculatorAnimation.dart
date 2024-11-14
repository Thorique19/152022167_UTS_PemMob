import 'package:flutter/material.dart';

class AnimatedCalculatorMenuPage extends StatefulWidget {
  @override
  _AnimatedCalculatorMenuPageState createState() =>
      _AnimatedCalculatorMenuPageState();
}

class _AnimatedCalculatorMenuPageState extends State<AnimatedCalculatorMenuPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Define the scale animation correctly from 0.0 to 1.0
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Menu')),
      body: Center(
        child: AnimatedCalculatorMenu(
          animation: _scaleAnimation,
          title: "Zakat Maal",
          icon: Icons.money,
          color: Colors.blue,
          description: "Simulasi Zakat Maal untuk perhitungan harta.",
          onTap: () {
            print("Zakat Maal menu tapped!");
          },
        ),
      ),
    );
  }
}

class AnimatedCalculatorMenu extends StatelessWidget {
  final Animation<double> animation;
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final VoidCallback onTap;

  const AnimatedCalculatorMenu({
    Key? key,
    required this.animation,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation, // Apply animation to scale the widget
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: color,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
