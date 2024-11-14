import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CustomColors {
  static const primaryColor = Color(0xFF545454);
  static const primaryLight = Color(0xFF787878);
  static const primaryDark = Color(0xFF363636);
  static const accentColor = Color(0xFFE0E0E0);
  static const backgroundColor = Colors.white;
  static const errorColor = Color(0xFFB00020);
}

class BmkgDataPage extends StatefulWidget {
  const BmkgDataPage({super.key});

  // Membuat widget stateful bernama BmkgDataPage.
  @override
  _BmkgDataPageState createState() =>
      _BmkgDataPageState(); // Menghubungkan dengan State untuk mengelola data dan state di halaman.
}

class _BmkgDataPageState extends State<BmkgDataPage> {
  // Membuat kelas State untuk widget BmkgDataPage.
  Map<String, dynamic>?
      autogempaData; // Variabel untuk menyimpan data gempa terkini dari autogempa.json.
  List<dynamic>?
      gempaterkiniData; // Variabel untuk menyimpan daftar gempa terbaru dari gempaterkini.json.

  @override
  void initState() {
    super.initState();
    fetchAutoGempa(); // Memanggil fungsi fetchAutoGempa saat halaman diinisialisasi.
    fetchGempaTerkini(); // Memanggil fungsi fetchGempaTerkini saat halaman diinisialisasi.
  }

  Future<void> fetchAutoGempa() async {
    // Fungsi asinkron untuk mengambil data dari autogempa.json.
    final url = Uri.parse(
        "https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json"); // Mendefinisikan URL API untuk autogempa.json.

    try {
      final response =
          await http.get(url); // Melakukan permintaan HTTP GET ke API.
      if (response.statusCode == 200) {
        // Jika permintaan berhasil (status 200 OK).
        setState(() {
          // Memperbarui state agar UI menampilkan data terbaru.
          autogempaData = json.decode(response.body)['Infogempa'][
              'gempa']; // Mem-parsing data JSON dan menyimpan data gempa di autogempaData.
        });
      } else {
        print(
            "Error: ${response.statusCode}"); // Mencetak pesan error jika status bukan 200.
      }
    } catch (e) {
      print(
          "Exception: $e"); // Mencetak pesan jika terjadi exception saat memanggil API.
    }
  }

  Future<void> fetchGempaTerkini() async {
    // Fungsi asinkron untuk mengambil data dari gempaterkini.json.
    final url = Uri.parse(
        "https://data.bmkg.go.id/DataMKG/TEWS/gempaterkini.json"); // Mendefinisikan URL API untuk gempaterkini.json.

    try {
      final response =
          await http.get(url); // Melakukan permintaan HTTP GET ke API.
      if (response.statusCode == 200) {
        // Jika permintaan berhasil (status 200 OK).
        setState(() {
          // Memperbarui state agar UI menampilkan data terbaru.
          gempaterkiniData = json.decode(response.body)['Infogempa'][
              'gempa']; // Mem-parsing data JSON dan menyimpan daftar gempa di gempaterkiniData.
        });
      } else {
        print(
            "Error: ${response.statusCode}"); // Mencetak pesan error jika status bukan 200.
      }
    } catch (e) {
      print(
          "Exception: $e"); // Mencetak pesan jika terjadi exception saat memanggil API.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Gempa BMKG',
          style: GoogleFonts.bitter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: CustomColors.primaryColor,
          ),
        ),
        backgroundColor: CustomColors.accentColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          autogempaData == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gempa Terkini:",
                      style: GoogleFonts.bitter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      color: CustomColors.backgroundColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tanggal: ${autogempaData!['Tanggal']}",
                              style: GoogleFonts.bitter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Waktu: ${autogempaData!['Jam']}",
                              style: GoogleFonts.bitter(
                                fontSize: 14,
                                color: CustomColors.primaryLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Magnitude: ${autogempaData!['Magnitude']}",
                              style: GoogleFonts.bitter(
                                fontSize: 14,
                                color: CustomColors.primaryLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Kedalaman: ${autogempaData!['Kedalaman']}",
                              style: GoogleFonts.bitter(
                                fontSize: 14,
                                color: CustomColors.primaryLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Lokasi: ${autogempaData!['Wilayah']}",
                              style: GoogleFonts.bitter(
                                fontSize: 14,
                                color: CustomColors.primaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 20),
          gempaterkiniData == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Daftar Gempa Terbaru:",
                      style: GoogleFonts.bitter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: gempaterkiniData!.length,
                      itemBuilder: (context, index) {
                        final gempa = gempaterkiniData![index];
                        return Card(
                          color: CustomColors.backgroundColor,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tanggal: ${gempa['Tanggal']}",
                                  style: GoogleFonts.bitter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Waktu: ${gempa['Jam']}",
                                  style: GoogleFonts.bitter(
                                    fontSize: 14,
                                    color: CustomColors.primaryLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Magnitude: ${gempa['Magnitude']}",
                                  style: GoogleFonts.bitter(
                                    fontSize: 14,
                                    color: CustomColors.primaryLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Kedalaman: ${gempa['Kedalaman']}",
                                  style: GoogleFonts.bitter(
                                    fontSize: 14,
                                    color: CustomColors.primaryLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Lokasi: ${gempa['Wilayah']}",
                                  style: GoogleFonts.bitter(
                                    fontSize: 14,
                                    color: CustomColors.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
