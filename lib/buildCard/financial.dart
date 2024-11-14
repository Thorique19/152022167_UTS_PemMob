import 'dart:convert'; // To convert to and from JSON format
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:riqapp/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String type; // 'income', 'expense', 'hutang'

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
  });

  // Convert a Transaction to a Map for storing in SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'type': type,
    };
  }

  // Convert a Map into a Transaction object
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'],
      type: map['type'],
    );
  }
}

class FinancialPage extends StatefulWidget {
  const FinancialPage({super.key});

  @override
  _FinancialPageState createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage> {
  final List<Transaction> _transactions = [];
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Other';
  String _selectedType = 'expense';

  final List<String> _categories = [
    'Makan & Minum',
    'Transportasi',
    'Kebutuhan & Keinginan',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  // Load saved transactions from SharedPreferences
  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? transactionsJson = prefs.getString('transactions');
    if (transactionsJson != null) {
      final List<dynamic> transactionsList = jsonDecode(transactionsJson);
      setState(() {
        _transactions.addAll(transactionsList
            .map((transaction) => Transaction.fromMap(transaction))
            .toList());
      });
    }
  }

  // Save transactions to SharedPreferences
  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> transactionsMap =
        _transactions.map((transaction) => transaction.toMap()).toList();
    await prefs.setString('transactions', jsonEncode(transactionsMap));
  }

  double get totalBalance {
    return _transactions.fold(0, (sum, transaction) {
      if (transaction.type == 'income') {
        return sum + transaction.amount;
      } else if (transaction.type == 'expense' ||
          transaction.type == 'hutang') {
        return sum - transaction.amount;
      }
      return sum;
    });
  }

  double get totalIncome {
    return _transactions
        .where((transaction) => transaction.type == 'income')
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalExpense {
    return _transactions
        .where((transaction) => transaction.type == 'expense')
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalhutang {
    return _transactions
        .where((transaction) => transaction.type == 'hutang')
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  void _addTransaction() {
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);

    if (title.isEmpty || amount <= 0) return;

    setState(() {
      _transactions.add(
        Transaction(
          id: DateTime.now().toString(),
          title: title,
          amount: amount,
          date: DateTime.now(),
          category: _selectedCategory,
          type: _selectedType,
        ),
      );
    });

    _titleController.clear();
    _amountController.clear();
    _saveTransactions(); // Save transactions after adding a new one
    Navigator.pop(context);
  }

  void _showAddTransactionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: CustomColors.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Transaction',
                style: GoogleFonts.bitter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryColor,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Teks',
                  border: OutlineInputBorder(),
                ),
                style: GoogleFonts.bitter(),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
                style: GoogleFonts.bitter(),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category, style: GoogleFonts.bitter()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: ['income', 'expense', 'hutang'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(
                      type.toUpperCase(),
                      style: GoogleFonts.bitter(),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addTransaction,
                  child: Text(
                    '(+) Tambah Transaksi',
                    style: GoogleFonts.bitter(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Financial Manager',
          style: GoogleFonts.bitter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CustomColors.backgroundColor),
        ),
        backgroundColor: CustomColors.primaryColor,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: CustomColors.primaryColor,
            child: Column(
              children: [
                Text(
                  'Total Saldo',
                  style: GoogleFonts.bitter(
                    color: CustomColors.backgroundColor,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Rp ${NumberFormat('#,###').format(totalBalance)}',
                  style: GoogleFonts.bitter(
                    color: CustomColors.backgroundColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryCard('Income', totalIncome, Colors.green),
                    _buildSummaryCard(
                        'Outcome', totalExpense, CustomColors.redColor),
                    _buildSummaryCard(
                        'Hutang', totalhutang, CustomColors.errorColor),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getTypeColor(transaction.type),
                      child: Icon(
                        _getTypeIcon(transaction.type),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      transaction.title,
                      style: GoogleFonts.bitter(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${transaction.category} • ${DateFormat('dd MMM yyyy').format(transaction.date)}',
                      style: GoogleFonts.bitter(),
                    ),
                    trailing: Text(
                      'Rp ${NumberFormat('#,###').format(transaction.amount)}',
                      style: GoogleFonts.bitter(
                        color: _getTypeColor(transaction.type),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionSheet,
        child: Icon(Icons.add),
        backgroundColor: CustomColors.primaryColor,
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CustomColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.bitter(
              color: CustomColors.primaryColor,
              fontSize: 14,
            ),
          ),
          Text(
            'Rp ${NumberFormat('#,###').format(amount)}',
            style: GoogleFonts.bitter(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'income':
        return Colors.green;
      case 'expense':
        return CustomColors.redColor;
      case 'hutang':
        return CustomColors.errorColor;
      default:
        return CustomColors.primaryColor;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'income':
        return Icons.arrow_upward;
      case 'expense':
        return Icons.arrow_downward;
      case 'hutang':
        return Icons.money_off;
      default:
        return Icons.attach_money;
    }
  }
}
