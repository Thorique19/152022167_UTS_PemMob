import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/custom_colors.dart';
import 'dart:math';

class KreditRumah extends StatefulWidget {
  const KreditRumah({super.key});

  @override
  _KreditRumahState createState() => _KreditRumahState();
}

class _KreditRumahState extends State<KreditRumah> {
  final _formKey = GlobalKey<FormState>();
  final _hargaRumahController = TextEditingController();
  final _uangMukaController = TextEditingController();
  final _tenorController = TextEditingController();
  final _bungaController = TextEditingController();

  double? _angsuranPerBulan;
  double? _totalPinjaman;
  double? _totalBunga;
  double? _totalBayar;

  void _hitungKPR() {
    if (_formKey.currentState!.validate()) {
      double hargaRumah =
          double.parse(_hargaRumahController.text.replaceAll(',', ''));
      double uangMuka =
          double.parse(_uangMukaController.text.replaceAll(',', ''));
      int tenor = int.parse(_tenorController.text);
      double bungaTahunan = double.parse(_bungaController.text);

      // Perhitungan KPR
      _totalPinjaman = hargaRumah - uangMuka;
      double bungaBulanan = bungaTahunan / 12 / 100;

      // Rumus angsuran: A = P * (r(1+r)^n)/((1+r)^n-1)
      // A = Angsuran, P = Pinjaman, r = bunga bulanan, n = tenor dalam bulan
      double power = pow((1 + bungaBulanan), (tenor * 12)) as double;
      _angsuranPerBulan =
          _totalPinjaman! * (bungaBulanan * power) / (power - 1);

      _totalBayar = _angsuranPerBulan! * tenor * 12;
      _totalBunga = _totalBayar! - _totalPinjaman!;

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
    _uangMukaController.dispose();
    _tenorController.dispose();
    _bungaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Simulasi KPR',
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
                          'Data Simulasi KPR',
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
                          controller: _uangMukaController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.bitter(),
                          decoration: InputDecoration(
                            labelText: 'Uang Muka (Rp)',
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
                            prefixIcon: const Icon(Icons.payments,
                                color: CustomColors.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan uang muka';
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
                          controller: _tenorController,
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
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _bungaController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.bitter(),
                          decoration: InputDecoration(
                            labelText: 'Suku Bunga (%/tahun)',
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
                              return 'Masukkan suku bunga';
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
                  onPressed: _hitungKPR,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Hitung KPR',
                    style: GoogleFonts.bitter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (_angsuranPerBulan != null) ...[
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
                            'Hasil Simulasi KPR',
                            style: GoogleFonts.bitter(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildResultRow(
                            'Total Pinjaman:',
                            'Rp ${_formatCurrency(_totalPinjaman!)}',
                          ),
                          const SizedBox(height: 12),
                          _buildResultRow(
                            'Angsuran per Bulan:',
                            'Rp ${_formatCurrency(_angsuranPerBulan!)}',
                            isHighlighted: true,
                          ),
                          const SizedBox(height: 12),
                          _buildResultRow(
                            'Total Bunga:',
                            'Rp ${_formatCurrency(_totalBunga!)}',
                          ),
                          const SizedBox(height: 12),
                          _buildResultRow(
                            'Total Pembayaran:',
                            'Rp ${_formatCurrency(_totalBayar!)}',
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
