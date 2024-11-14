import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/custom_colors.dart'; // Assuming CustomColors is already defined in your project

class PajakRumah extends StatefulWidget {
  const PajakRumah({super.key});

  @override
  _PajakRumahState createState() => _PajakRumahState();
}

class _PajakRumahState extends State<PajakRumah> {
  final _formKey = GlobalKey<FormState>();
  final _hargaRumahController = TextEditingController();
  final _nilaiPajakController = TextEditingController();
  final _tahunController = TextEditingController();

  double? _pajakTahunan;
  double? _pajakBulanan;
  double? _totalBayarPajak;

  void _hitungPajak() {
    if (_formKey.currentState!.validate()) {
      double hargaRumah =
          double.parse(_hargaRumahController.text.replaceAll(',', ''));
      double nilaiPajak = double.parse(_nilaiPajakController.text);
      int tahun = int.parse(_tahunController.text); // Corrected variable name

      // Perhitungan Pajak
      _pajakTahunan = hargaRumah * (nilaiPajak / 100);
      _pajakBulanan = _pajakTahunan! / 12;
      _totalBayarPajak = _pajakTahunan! * tahun;

      setState(() {});
    }
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  void dispose() {
    _hargaRumahController.dispose();
    _nilaiPajakController.dispose();
    _tahunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Simulasi Pajak Properti',
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
                          'Data Simulasi Pajak',
                          style: GoogleFonts.bitter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: CustomColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _hargaRumahController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.bitter(),
                          decoration: InputDecoration(
                            labelText: 'Harga Properti (Rp)',
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
                            prefixIcon: const Icon(Icons.house,
                                color: CustomColors.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan harga properti';
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
                          controller: _nilaiPajakController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.bitter(),
                          decoration: InputDecoration(
                            labelText: 'Nilai Pajak (%/tahun)',
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
                            prefixIcon: const Icon(Icons.percent,
                                color: CustomColors.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan nilai pajak';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Masukkan angka yang valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _tahunController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.bitter(),
                          decoration: InputDecoration(
                            labelText: 'Jangka Waktu (Tahun)',
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
                            prefixIcon: const Icon(Icons.calendar_today,
                                color: CustomColors.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan jangka waktu';
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
                  onPressed: _hitungPajak,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Hitung Pajak',
                    style: GoogleFonts.bitter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (_pajakBulanan != null) ...[
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
                            'Hasil Simulasi Pajak',
                            style: GoogleFonts.bitter(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildResultRow(
                            'Pajak Tahunan: ',
                            'Rp ${_formatCurrency(_pajakTahunan!)}',
                          ),
                          const SizedBox(height: 12),
                          _buildResultRow(
                            'Pajak per Bulan: ',
                            'Rp ${_formatCurrency(_pajakBulanan!)}',
                            isHighlighted: true,
                          ),
                          const SizedBox(height: 12),
                          _buildResultRow(
                            'Total Pajak untuk ${_tahunController.text} Tahun: ',
                            'Rp ${_formatCurrency(_totalBayarPajak!)}',
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

  Widget _buildResultRow(String label, String value,
      {bool isHighlighted = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color:
            isHighlighted ? CustomColors.primaryColor.withOpacity(0.2) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.bitter(
              fontSize: 16,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: CustomColors.primaryDark,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.bitter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isHighlighted
                  ? CustomColors.primaryColor
                  : CustomColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
