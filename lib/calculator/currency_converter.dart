import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/custom_colors.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final List<String> _currencies = ['USD', 'EUR', 'IDR', 'JPY', 'GBP'];
  String _sourceCurrency = 'USD';
  Map<String, double> _conversionResults = {};
  bool _isLoading = false;

  // Simulated API call to get conversion rates (replace with a real API call)
  Future<void> fetchConversionRates(
      String sourceCurrency, double amount) async {
    setState(() {
      _isLoading = true;
    });

    // Mock conversion rates (replace with real data from an API)
    final mockRates = {
      'USD': 1.0,
      'EUR': 0.85,
      'IDR': 14925.0,
      'JPY': 109.5,
      'GBP': 0.75,
    };

    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    setState(() {
      _conversionResults = _currencies.asMap().map((index, currency) {
        double convertedAmount = amount * (mockRates[currency] ?? 1.0);
        return MapEntry(currency, convertedAmount);
      });
      _isLoading = false;
    });
  }

  void _convertCurrency() {
    if (_formKey.currentState!.validate()) {
      double amount = double.parse(_amountController.text);
      fetchConversionRates(_sourceCurrency, amount);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Currency Converter',
          style: GoogleFonts.bitter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
                          'Enter Amount and Choose Source Currency',
                          style: GoogleFonts.bitter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: CustomColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.bitter(),
                          decoration: InputDecoration(
                            labelText: 'Amount',
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
                            prefixIcon: const Icon(Icons.attach_money,
                                color: CustomColors.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter an amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButton<String>(
                          value: _sourceCurrency,
                          onChanged: (newCurrency) {
                            setState(() {
                              _sourceCurrency = newCurrency!;
                            });
                          },
                          items: _currencies.map((currency) {
                            return DropdownMenuItem(
                              value: currency,
                              child: Text(
                                currency,
                                style: GoogleFonts.bitter(
                                    color: CustomColors.primaryDark),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _convertCurrency,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Convert',
                    style: GoogleFonts.bitter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        children: _conversionResults.entries.map((entry) {
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                '${entry.value.toStringAsFixed(2)} ${entry.key}',
                                style: GoogleFonts.bitter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.primaryDark,
                                ),
                              ),
                              subtitle: Text(
                                'Converted from $_sourceCurrency',
                                style: GoogleFonts.bitter(
                                  fontSize: 16,
                                  color:
                                      CustomColors.primaryDark.withOpacity(0.7),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
