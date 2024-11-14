import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/custom_colors.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  double? _bmiResult;
  String _bmiCategory = '';
  Color _categoryColor = CustomColors.primaryColor;

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      double height = double.parse(_heightController.text) / 100;
      double weight = double.parse(_weightController.text);

      setState(() {
        _bmiResult = weight / (height * height);
        _updateBMICategory();
      });
    }
  }

  void _updateBMICategory() {
    if (_bmiResult! < 18.5) {
      _bmiCategory = 'Berat Badan Kurang';
      _categoryColor = CustomColors.primaryLight;
    } else if (_bmiResult! < 25) {
      _bmiCategory = 'Berat Badan Normal';
      _categoryColor = Colors.green;
    } else if (_bmiResult! < 30) {
      _bmiCategory = 'Berat Badan Berlebih';
      _categoryColor = CustomColors.primaryDark;
    } else {
      _bmiCategory = 'Obesitas';
      _categoryColor = CustomColors.redColor;
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kalkulator BMI',
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
          child: Form(
            key: _formKey,
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
                          'Masukkan Data Anda',
                          style: GoogleFonts.bitter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: CustomColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.bitter(),
                          decoration: InputDecoration(
                            labelText: 'Tinggi Badan (cm)',
                            labelStyle: GoogleFonts.bitter(
                                color: CustomColors.primaryDark),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: CustomColors.primaryColor, width: 2),
                            ),
                            prefixIcon: const Icon(Icons.height,
                                color: CustomColors.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan tinggi badan';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Masukkan angka yang valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.bitter(),
                          decoration: InputDecoration(
                            labelText: 'Berat Badan (kg)',
                            labelStyle: GoogleFonts.bitter(
                                color: CustomColors.primaryDark),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: CustomColors.primaryColor, width: 2),
                            ),
                            prefixIcon: const Icon(Icons.monitor_weight,
                                color: CustomColors.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan berat badan';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Masukkan angka yang valid';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateBMI,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Hitung BMI',
                    style: GoogleFonts.bitter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (_bmiResult != null) ...[
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
                            _categoryColor.withOpacity(0.1),
                            _categoryColor.withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Hasil BMI:',
                            style: GoogleFonts.bitter(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _bmiResult!.toStringAsFixed(1),
                            style: GoogleFonts.bitter(
                              fontSize: 52,
                              fontWeight: FontWeight.bold,
                              color: _categoryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _categoryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _bmiCategory,
                              style: GoogleFonts.bitter(
                                fontSize: 24,
                                color: _categoryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Rentang BMI Normal: 18.5 - 24.9',
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
      ),
    );
  }
}
