import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/custom_colors.dart';

class TemperatureConverter extends StatefulWidget {
  const TemperatureConverter({super.key});

  @override
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  final _temperatureController = TextEditingController();
  String _fromUnit = 'Celsius';
  String _toUnit = 'Fahrenheit';
  double? _result;

  final List<String> _units = ['Celsius', 'Fahrenheit', 'Kelvin'];

  // Function to convert temperature between units
  double _convertTemperature(double inputTemp) {
    if (_fromUnit == _toUnit) return inputTemp;

    // Convert from 'from' unit to Celsius
    double tempInCelsius;
    if (_fromUnit == 'Celsius') {
      tempInCelsius = inputTemp;
    } else if (_fromUnit == 'Fahrenheit') {
      tempInCelsius = (inputTemp - 32) * 5 / 9;
    } else {
      // Kelvin
      tempInCelsius = inputTemp - 273.15;
    }

    // Convert from Celsius to 'to' unit
    if (_toUnit == 'Celsius') {
      return tempInCelsius;
    } else if (_toUnit == 'Fahrenheit') {
      return (tempInCelsius * 9 / 5) + 32;
    } else {
      // Kelvin
      return tempInCelsius + 273.15;
    }
  }

  void _calculateConversion() {
    if (_temperatureController.text.isEmpty) return;

    double inputTemp = double.parse(_temperatureController.text);
    double result = _convertTemperature(inputTemp);

    setState(() {
      _result = result;
    });
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Konversi Suhu',
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
                        'Masukkan Suhu',
                        style: GoogleFonts.bitter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _temperatureController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.bitter(),
                        decoration: InputDecoration(
                          labelText: 'Suhu',
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
                          prefixIcon: Icon(Icons.thermostat,
                              color: CustomColors.primaryColor),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _calculateConversion();
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
                                          _calculateConversion();
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
                                          _calculateConversion();
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
                          '${_temperatureController.text} $_fromUnit = ${_result == _result!.toInt() ? _result!.toInt().toString() : _result!.toStringAsFixed(4)} $_toUnit',
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
