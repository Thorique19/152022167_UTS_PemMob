import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/cryptocurrency/cryptoprice.dart';
import 'package:riqapp/custom_colors.dart';

class Cryptocurrency extends StatefulWidget {
  const Cryptocurrency({super.key});

  @override
  _CryptocurrencyState createState() => _CryptocurrencyState();
}

class _CryptocurrencyState extends State<Cryptocurrency>
    with SingleTickerProviderStateMixin {
  String _sortingOption = 'A-Z'; // Default sorting option

  late AnimationController _controller;
  final List<Animation<double>> _animations = [];

  // Define calculator items as a list of maps for easy sorting
  final List<Map<String, dynamic>> _calculatorItems = [
    {
      'title': 'Price',
      'icon': Icons.currency_bitcoin,
      'description': 'Koin & Harga',
      'route': (context) => CryptoPriceScreen(),
    },
    {
      'title': 'NULL',
      'icon': Icons.show_chart,
      'description': 'NULLL',
      'route': null, // Replace with actual route
    },
  ];

  // Get sorted items based on current sorting option
  List<Map<String, dynamic>> get _sortedItems {
    final items = List<Map<String, dynamic>>.from(_calculatorItems);
    switch (_sortingOption) {
      case 'A-Z':
        items.sort(
            (a, b) => a['title'].toString().compareTo(b['title'].toString()));
        break;
      case 'Z-A':
        items.sort(
            (a, b) => b['title'].toString().compareTo(a['title'].toString()));
        break;
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Create staggered animations for each card
    for (int i = 0; i < _calculatorItems.length; i++) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crypto Page',
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: CustomColors.primaryColor,
          ),
        ),
        backgroundColor: CustomColors.accentColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Crypto Enthusiast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: CustomColors.primaryColor),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _sortingOption,
                      icon: const Icon(Icons.sort),
                      items: ['A-Z', 'Z-A'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _sortingOption = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: _sortedItems.map((item) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => item['route'](context)),
                  ),
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'],
                            size: 48, color: CustomColors.primaryColor),
                        const SizedBox(height: 8),
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['description'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
