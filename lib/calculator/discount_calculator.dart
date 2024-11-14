import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/custom_colors.dart';

class DiscountCalculator extends StatefulWidget {
  const DiscountCalculator({super.key});

  @override
  _DiscountCalculatorState createState() => _DiscountCalculatorState();
}

class _DiscountCalculatorState extends State<DiscountCalculator> {
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  double? _discountedPrice;

  void _calculateDiscount() {
    if (_priceController.text.isEmpty || _discountController.text.isEmpty)
      return;

    double originalPrice = double.parse(_priceController.text);
    double discountPercentage = double.parse(_discountController.text);
    double discountAmount = originalPrice * (discountPercentage / 100);
    double result = originalPrice - discountAmount;

    setState(() {
      _discountedPrice = result;
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kalkulator Diskon',
          style: GoogleFonts.bitter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: CustomColors.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CustomColors.primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Masukkan Harga Asli',
                        style: GoogleFonts.bitter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.bitter(),
                        decoration: InputDecoration(
                          labelText: 'Harga Asli',
                          labelStyle: GoogleFonts.bitter(
                              color: CustomColors.primaryDark),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: CustomColors.primaryColor, width: 2),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'RP',
                              style: GoogleFonts.bitter(
                                color: CustomColors.primaryColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty &&
                              _discountController.text.isNotEmpty) {
                            _calculateDiscount();
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Persentase Diskon',
                        style: GoogleFonts.bitter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _discountController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.bitter(),
                        decoration: InputDecoration(
                          labelText: 'Diskon (%)',
                          labelStyle: GoogleFonts.bitter(
                              color: CustomColors.primaryDark),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: CustomColors.primaryColor, width: 2),
                          ),
                          prefixIcon: Icon(Icons.percent,
                              color: CustomColors.primaryColor),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty &&
                              _priceController.text.isNotEmpty) {
                            _calculateDiscount();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (_discountedPrice != null) ...[
                const SizedBox(height: 24),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          CustomColors.primaryColor.withOpacity(0.1),
                          CustomColors.primaryColor.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Harga Setelah Diskon',
                          style: GoogleFonts.bitter(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: CustomColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _discountedPrice!.toStringAsFixed(2),
                              style: GoogleFonts.bitter(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'IDR',
                                style: GoogleFonts.bitter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Harga asli: ${_priceController.text} IDR\nDiskon: ${_discountController.text}%',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.bitter(
                            fontSize: 16,
                            color: CustomColors.primaryDark.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
