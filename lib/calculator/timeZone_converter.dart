import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/custom_colors.dart'; // Assuming custom colors are defined here
import 'package:intl/intl.dart';

class TimeConverter extends StatefulWidget {
  const TimeConverter({super.key});

  @override
  _TimeConverterState createState() => _TimeConverterState();
}

class _TimeConverterState extends State<TimeConverter> {
  final TextEditingController _dateTimeController = TextEditingController();
  String _fromZone = 'UTC';
  String _toZone = 'UTC';
  String _result = '';

  final List<String> _timeZones = [
    'UTC',
    'WIB (UTC +7)',
    'WITA (UTC +8)',
    'WIT (UTC +9)',
    'GMT',
    'PST (UTC -8)',
    'EST (UTC -5)',
    'CET (UTC +1)',
  ];

  String _convertTime(String inputTime) {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime dateTime = inputFormat.parse(inputTime);

    int fromOffset = _getTimeZoneOffset(_fromZone);
    int toOffset = _getTimeZoneOffset(_toZone);

    DateTime convertedTime =
        dateTime.add(Duration(hours: toOffset - fromOffset));

    return outputFormat.format(convertedTime);
  }

  int _getTimeZoneOffset(String zone) {
    switch (zone) {
      case 'UTC':
        return 0;
      case 'WIB (UTC +7)':
        return 7;
      case 'WITA (UTC +8)':
        return 8;
      case 'WIT (UTC +9)':
        return 9;
      case 'GMT':
        return 0;
      case 'PST (UTC -8)':
        return -8;
      case 'EST (UTC -5)':
        return -5;
      case 'CET (UTC +1)':
        return 1;
      default:
        return 0;
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (selectedTime != null) {
        final DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        String formattedDateTime =
            DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDateTime);
        setState(() {
          _dateTimeController.text = formattedDateTime;
        });
        _calculateConversion();
      }
    }
  }

  void _calculateConversion() {
    if (_dateTimeController.text.isEmpty) return;

    String inputTime = _dateTimeController.text;
    String result = _convertTime(inputTime);

    setState(() {
      _result = result;
    });
  }

  @override
  void dispose() {
    _dateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Konversi Waktu',
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
                        'Pilih Waktu (Tanggal dan Jam)',
                        style: GoogleFonts.bitter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _dateTimeController,
                        readOnly: true,
                        style: GoogleFonts.bitter(),
                        decoration: InputDecoration(
                          labelText: 'Tanggal dan Waktu',
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
                          prefixIcon: Icon(Icons.access_time,
                              color: CustomColors.primaryColor),
                        ),
                        onTap: () {
                          _selectDateTime(context);
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
                                      value: _fromZone,
                                      isExpanded: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      borderRadius: BorderRadius.circular(10),
                                      items: _timeZones.map((String zone) {
                                        return DropdownMenuItem<String>(
                                          value: zone,
                                          child: Text(
                                            zone,
                                            style: GoogleFonts.bitter(),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _fromZone = newValue!;
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
                                      value: _toZone,
                                      isExpanded: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      borderRadius: BorderRadius.circular(10),
                                      items: _timeZones.map((String zone) {
                                        return DropdownMenuItem<String>(
                                          value: zone,
                                          child: Text(
                                            zone,
                                            style: GoogleFonts.bitter(),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _toZone = newValue!;
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
              if (_result.isNotEmpty) ...[
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
                        Text(
                          _result,
                          style: GoogleFonts.bitter(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.primaryColor,
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
