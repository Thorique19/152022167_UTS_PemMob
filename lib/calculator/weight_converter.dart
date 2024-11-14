import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/custom_colors.dart';

class WeightConverter extends StatefulWidget {
  const WeightConverter({super.key});

  @override
  _WeightConverterState createState() => _WeightConverterState();
}

class _WeightConverterState extends State<WeightConverter> {
  final _weightController = TextEditingController();
  String _fromUnit = 'kg';
  String _toUnit = 'pound';
  double? _result;

  final Map<String, double> _conversionFactors = {
    'kg': 1.0,
    'pound': 2.20462,
    'gram': 1000,
    'ounce': 35.274,
    'ton': 0.001,
  };

  final List<String> _units = ['kg', 'pound', 'gram', 'ounce', 'ton'];

  void _convertWeight() {
    if (_weightController.text.isEmpty) return;

    double inputWeight = double.parse(_weightController.text);
    double inKg = inputWeight / _conversionFactors[_fromUnit]!;
    double result = inKg * _conversionFactors[_toUnit]!;

    setState(() {
      _result = result;
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Konversi Berat',
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
                        'Masukkan Berat',
                        style: GoogleFonts.bitter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.bitter(),
                        decoration: InputDecoration(
                          labelText: 'Berat',
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
                          prefixIcon: Icon(Icons.monitor_weight,
                              color: CustomColors.primaryColor),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _convertWeight();
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dari',
                                  style: GoogleFonts.bitter(
                                    color: CustomColors.primaryDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: CustomColors.primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _fromUnit,
                                      isExpanded: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      borderRadius: BorderRadius.circular(10),
                                      items: _units.map((String unit) {
                                        return DropdownMenuItem<String>(
                                          value: unit,
                                          child: Text(
                                            unit,
                                            style: GoogleFonts.bitter(),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _fromUnit = newValue!;
                                          _convertWeight();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ke',
                                  style: GoogleFonts.bitter(
                                    color: CustomColors.primaryDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: CustomColors.primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _toUnit,
                                      isExpanded: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      borderRadius: BorderRadius.circular(10),
                                      items: _units.map((String unit) {
                                        return DropdownMenuItem<String>(
                                          value: unit,
                                          child: Text(
                                            unit,
                                            style: GoogleFonts.bitter(),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _toUnit = newValue!;
                                          _convertWeight();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_result != null) ...[
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
                          'Hasil Konversi',
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
                              _result!.toStringAsFixed(4),
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
                                _toUnit,
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
                          '${_weightController.text} $_fromUnit = ${_result!.toStringAsFixed(4)} $_toUnit',
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
