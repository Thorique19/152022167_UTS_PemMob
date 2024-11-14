import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/custom_colors.dart';

class Zakat extends StatefulWidget {
  const Zakat({super.key});

  @override
  _ZakatState createState() => _ZakatState();
}

class _ZakatState extends State<Zakat> {
  final _formKey = GlobalKey<FormState>();
  final _hartaController = TextEditingController();
  final _nisabController = TextEditingController();
  final _jumlahOrangController = TextEditingController();

  double _zakatMaal = 0;
  double _zakatFitrah = 0;

  void _hitungZakat() {
    if (_formKey.currentState!.validate()) {
      double harta = double.parse(_hartaController.text.replaceAll(',', ''));
      double nisab = double.parse(_nisabController.text.replaceAll(',', ''));
      int jumlahOrang = int.parse(_jumlahOrangController.text);

      // Perhitungan Zakat Maal
      _zakatMaal = (harta >= nisab) ? harta * 0.025 : 0;

      // Perhitungan Zakat Fitrah
      const double hargaZakatFitrahPerOrang =
          40000.0; // Asumsi Rp 40,000 per orang
      _zakatFitrah = hargaZakatFitrahPerOrang * jumlahOrang;

      setState(() {});
    }
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  void dispose() {
    _hartaController.dispose();
    _nisabController.dispose();
    _jumlahOrangController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Simulasi Zakat',
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
                          'Data Simulasi Zakat',
                          style: GoogleFonts.bitter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: CustomColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _hartaController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.bitter(),
                          decoration: InputDecoration(
                            labelText: 'Total Harta (Rp)',
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
                            prefixIcon: const Icon(Icons.money,
                                color: CustomColors.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan total harta';
                            }
                            if (double.tryParse(value.replaceAll(',', '')) ==
                                null) {
                              return 'Masukkan angka yang valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nisabController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.bitter(),
                          decoration: InputDecoration(
                            labelText: 'Nisab (Rp)',
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
                            prefixIcon: const Icon(Icons.gavel,
                                color: CustomColors.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan nilai nisab';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Masukkan angka yang valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _jumlahOrangController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.bitter(),
                          decoration: InputDecoration(
                            labelText: 'Jumlah Jiwa (Orang)',
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
                            prefixIcon: const Icon(Icons.person_add,
                                color: CustomColors.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan jumlah jiwa';
                            }
                            if (int.tryParse(value) == null) {
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
                  onPressed: _hitungZakat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Hitung Zakat',
                    style: GoogleFonts.bitter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_zakatMaal != 0 || _zakatFitrah != 0) ...[
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          _buildResultRow(
                            'Zakat Maal: ',
                            'Rp ${_formatCurrency(_zakatMaal)}',
                          ),
                          const SizedBox(height: 12),
                          _buildResultRow(
                            'Zakat Fitrah: ',
                            'Rp ${_formatCurrency(_zakatFitrah)}',
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

  Widget _buildResultRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: CustomColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.bitter(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: CustomColors.primaryDark,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.bitter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CustomColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
