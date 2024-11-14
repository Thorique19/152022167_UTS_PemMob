import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riqapp/custom_colors.dart';

class CryptoPriceScreen extends StatefulWidget {
  @override
  _CryptoPriceScreenState createState() => _CryptoPriceScreenState();
}

class _CryptoPriceScreenState extends State<CryptoPriceScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  Map<String, dynamic> cryptoPrices = {};
  Map<String, String> cryptoIcons = {
    'bitcoin': '₿',
    'ethereum': 'Ξ',
    'ripple': 'XRP',
    'litecoin': 'Ł',
    'cardano': '₳',
    'ton': '₮',
  };

  late AnimationController _refreshIconController;

  @override
  void initState() {
    super.initState();
    _refreshIconController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    fetchCryptoPrices();
  }

  @override
  void dispose() {
    _refreshIconController.dispose();
    super.dispose();
  }

  Future<void> fetchCryptoPrices() async {
    setState(() {
      isLoading = true;
    });

    final url =
        'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,ripple,litecoin,cardano,ton&vs_currencies=usd';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          cryptoPrices = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load crypto prices');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorSnackbar('Failed to fetch data');
    }
  }

  Future<void> _refreshPrices() async {
    _refreshIconController.repeat();
    await fetchCryptoPrices();
    _refreshIconController.stop();
    _refreshIconController.reset();
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: CustomColors.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Crypto Tracker',
          style: TextStyle(
            color: CustomColors.primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: CustomColors.backgroundColor,
        elevation: 0,
        actions: [
          RotationTransition(
            turns: _refreshIconController,
            child: IconButton(
              icon: Icon(Icons.refresh, color: CustomColors.primaryDark),
              onPressed: _refreshPrices,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(CustomColors.primaryColor),
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshPrices,
              color: CustomColors.primaryColor,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: cryptoPrices.keys.map((crypto) {
                  double price = cryptoPrices[crypto]['usd'].toDouble();
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CustomColors.primaryLight.withOpacity(0.1),
                            CustomColors.primaryDark.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.primaryDark.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            // Handle tap event
                          },
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: CustomColors.primaryLight
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      cryptoIcons[crypto] ?? '',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: CustomColors.primaryDark,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        crypto.capitalize(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: CustomColors.primaryDark,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Current Price',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: CustomColors.primaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    if (this.isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + this.substring(1);
  }
}
