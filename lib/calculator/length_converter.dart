import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/custom_colors.dart';

class LengthConverter extends StatefulWidget {
  const LengthConverter({super.key});

  @override
  _LengthConverterState createState() => _LengthConverterState();
}

class _LengthConverterState extends State<LengthConverter> {
  final _lengthController = TextEditingController();
  String _fromUnit = 'km';
  String _toUnit = 'meter';
  double? _result;

  final Map<String, double> _conversionFactors = {
    'km': 1.0,
    'meter': 1000,
    'cm': 100000,
    'mm': 1000000,
    'mile': 0.621371,
    'yard': 1093.61,
    'foot': 3280.84,
  };

  final List<String> _units = [
    'km',
    'meter',
    'cm',
    'mm',
    'mile',
    'yard',
    'foot'
  ];

  void _convertLength() {
    if (_lengthController.text.isEmpty) return;

    double inputLength = double.parse(_lengthController.text);
    double inKm = inputLength / _conversionFactors[_fromUnit]!;
    double result = inKm * _conversionFactors[_toUnit]!;

    setState(() {
      _result = result;
    });
  }

  @override
  void dispose() {
    _lengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Konversi Panjang',
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
                        'Masukkan Panjang',
                        style: GoogleFonts.bitter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _lengthController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.bitter(),
                        decoration: InputDecoration(
                          labelText: 'Panjang',
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
                          prefixIcon: Icon(Icons.show_chart,
                              color: CustomColors.primaryColor),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _convertLength();
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
                                          _convertLength();
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
                                          _convertLength();
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
                              // Check if the result is an integer, and if so, show it as an integer
                              _result == _result!.toInt()
                                  ? _result!.toInt().toString()
                                  : _result!.toStringAsFixed(4),
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
                          '${_lengthController.text} $_fromUnit = ${_result == _result!.toInt() ? _result!.toInt().toString() : _result!.toStringAsFixed(4)} $_toUnit',
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
