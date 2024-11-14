import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/animationCard/menucalculatorAnimation.dart';
import 'package:riqapp/calculator/currency_converter.dart';
import 'package:riqapp/calculator/length_converter.dart';
import 'package:riqapp/calculator/pajak.dart';
import 'package:riqapp/calculator/scientific_calculator.dart';
import 'package:riqapp/calculator/temperature_converter.dart';
import 'package:riqapp/calculator/timeZone_converter.dart';
import 'package:riqapp/calculator/weight_converter.dart';
import 'package:riqapp/calculator/bmi_calculator.dart';
import 'package:riqapp/calculator/discount_calculator.dart';
import 'package:riqapp/calculator/kpr_simulation.dart';
import 'package:riqapp/calculator/zakaat.dart';
import 'package:riqapp/custom_colors.dart';
import 'package:riqapp/calculator/general_calculator.dart';

class CalculatorMenu extends StatefulWidget {
  const CalculatorMenu({super.key});

  @override
  _CalculatorMenuState createState() => _CalculatorMenuState();
}

class _CalculatorMenuState extends State<CalculatorMenu>
    with SingleTickerProviderStateMixin {
  String _sortingOption = 'A-Z'; // Default sorting option

  late AnimationController _controller;
  final List<Animation<double>> _animations = [];

  // Define calculator items as a list of maps for easy sorting
  final List<Map<String, dynamic>> _calculatorItems = [
    {
      'title': 'Kalkulator\nUmum',
      'icon': Icons.calculate,
      'description': 'Operasi matematika dasar',
      'route': (context) => const GeneralCalculator(),
    },
    {
      'title': 'Mata Uang',
      'icon': Icons.currency_exchange,
      'description': 'Konversi antar mata uang',
      'route': (context) => const CurrencyConverter(),
    },
    {
      'title': 'Suhu',
      'icon': Icons.thermostat,
      'description': 'Konversi Suhu. Celsius, Fahrenheit, Kelvin',
      'route': (context) => const TemperatureConverter()
    },
    {
      'title': 'BMI',
      'icon': Icons.monitor_weight,
      'description': 'Hitung Indeks Massa Tubuh',
      'route': (context) => const BMICalculator(),
    },
    {
      'title': 'Diskon',
      'icon': Icons.discount,
      'description': 'Hitung potongan harga',
      'route': (context) => const DiscountCalculator(),
    },
    {
      'title': 'Panjang',
      'icon': Icons.straighten,
      'description': 'Hitung Meter, kilometer, dll',
      'route': (context) => const LengthConverter()
    },
    {
      'title': 'KPR',
      'icon': Icons.house,
      'description': 'Simulasi kredit rumah',
      'route': (context) => const KreditRumah(),
    },
    {
      'title': 'Zakat',
      'icon': Icons.attach_money,
      'description': 'Hitung zakat maal & fitrah',
      'route': (context) => const Zakat(),
    },
    {
      'title': 'Zona Waktu',
      'icon': Icons.access_time,
      'description': 'WIB, WITA, WIT, dll',
      'route': (context) => const TimeConverter()
    },
    {
      'title': 'Pajak',
      'icon': Icons.receipt_long,
      'description': 'Hitung PPh, PPN, dll',
      'route': (context) => const PajakRumah()
    },
    {
      'title': 'Kalkulator\nScientific',
      'icon': Icons.science,
      'description': 'Fungsi matematika lanjutan',
      'route': (context) => const ScientificCalculator(),
    },
    {
      'title': 'Berat',
      'icon': Icons.fitness_center,
      'description': 'Hitung Kg, gram, pound, dll',
      'route': (context) => const WeightConverter(),
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
          'Kalkulator',
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
                  'Pilih Jenis Kalkulator',
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
              children: _sortedItems
                  .asMap()
                  .map((index, item) {
                    return MapEntry(
                      index,
                      AnimatedCalculatorMenu(
                        animation: _animations[index],
                        title: item['title'],
                        icon: item['icon'],
                        color: CustomColors.primaryColor,
                        description: item['description'],
                        onTap: item['route'] != null
                            ? () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        item['route'](context),
                                  ),
                                )
                            : () {}, // Empty function for TODO routes
                      ),
                    );
                  })
                  .values
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
