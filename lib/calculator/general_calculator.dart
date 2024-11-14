import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/custom_colors.dart';
import 'dart:math';

class GeneralCalculator extends StatefulWidget {
  const GeneralCalculator({super.key});

  @override
  State<GeneralCalculator> createState() => _GeneralCalculatorState();
}

class _GeneralCalculatorState extends State<GeneralCalculator> {
  String _input = '';
  String _result = '';
  String _operation = '';
  double _firstNumber = 0;
  bool _isNewCalculation = true;

  void _onNumberPressed(String number) {
    setState(() {
      if (_isNewCalculation) {
        _input = number;
        _isNewCalculation = false;
      } else {
        _input += number;
      }
    });
  }

  void _onOperationPressed(String operation) {
    setState(() {
      if (_input.isNotEmpty) {
        _firstNumber = double.parse(_input);
        _operation = operation;
        _input = '';
      }
    });
  }

  void _onEqualsPressed() {
    setState(() {
      if (_input.isNotEmpty && _operation.isNotEmpty) {
        double secondNumber = double.parse(_input);
        double result = 0;

        switch (_operation) {
          case '+':
            result = _firstNumber + secondNumber;
            break;
          case '-':
            result = _firstNumber - secondNumber;
            break;
          case '×':
            result = _firstNumber * secondNumber;
            break;
          case '÷':
            if (secondNumber != 0) {
              result = _firstNumber / secondNumber;
            } else {
              _result = 'Error';
              return;
            }
            break;
        }

        _result = result.toString();
        _input = result.toString();
        _operation = '';
        _isNewCalculation = true;
      }
    });
  }

  void _onSquarePressed() {
    setState(() {
      if (_input.isNotEmpty) {
        double number = double.parse(_input);
        double result = pow(number, 2).toDouble();
        _result = result.toString();
        _input = result.toString();
        _isNewCalculation = true;
      }
    });
  }

  void _onSquareRootPressed() {
    setState(() {
      if (_input.isNotEmpty) {
        double number = double.parse(_input);
        if (number >= 0) {
          double result = sqrt(number);
          _result = result.toString();
          _input = result.toString();
          _isNewCalculation = true;
        } else {
          _result = 'Error';
        }
      }
    });
  }

  void _onClearPressed() {
    setState(() {
      _input = '';
      _result = '';
      _operation = '';
      _firstNumber = 0;
      _isNewCalculation = true;
    });
  }

  Widget _buildButton(
    String text, {
    Color color = Colors.white,
    Color textColor = Colors.black,
    void Function()? onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kalkulator',
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: CustomColors.primaryColor,
          ),
        ),
        backgroundColor: CustomColors.backgroundColor,
      ),
      body: Column(
        children: [
          // Display
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _input.isEmpty ? '0' : _input,
                  style: const TextStyle(fontSize: 48),
                ),
                Text(
                  _result.isEmpty ? '' : '= $_result',
                  style: const TextStyle(
                    fontSize: 24,
                    color: CustomColors.accentColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          // Buttons
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('C',
                            color: CustomColors.errorColor,
                            textColor: Colors.white,
                            onPressed: _onClearPressed),
                        _buildButton('√',
                            color: CustomColors.primaryLight,
                            textColor: Colors.white,
                            onPressed: _onSquareRootPressed),
                        _buildButton('x²',
                            color: CustomColors.primaryLight,
                            textColor: Colors.white,
                            onPressed: _onSquarePressed),
                        _buildButton('÷',
                            color: CustomColors.primaryLight,
                            textColor: Colors.white,
                            onPressed: () => _onOperationPressed('÷')),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('7',
                            onPressed: () => _onNumberPressed('7')),
                        _buildButton('8',
                            onPressed: () => _onNumberPressed('8')),
                        _buildButton('9',
                            onPressed: () => _onNumberPressed('9')),
                        _buildButton('×',
                            color: CustomColors.primaryLight,
                            textColor: Colors.white,
                            onPressed: () => _onOperationPressed('×')),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('4',
                            onPressed: () => _onNumberPressed('4')),
                        _buildButton('5',
                            onPressed: () => _onNumberPressed('5')),
                        _buildButton('6',
                            onPressed: () => _onNumberPressed('6')),
                        _buildButton('-',
                            color: CustomColors.primaryLight,
                            textColor: Colors.white,
                            onPressed: () => _onOperationPressed('-')),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('1',
                            onPressed: () => _onNumberPressed('1')),
                        _buildButton('2',
                            onPressed: () => _onNumberPressed('2')),
                        _buildButton('3',
                            onPressed: () => _onNumberPressed('3')),
                        _buildButton('+',
                            color: CustomColors.primaryLight,
                            textColor: Colors.white,
                            onPressed: () => _onOperationPressed('+')),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('0',
                            onPressed: () => _onNumberPressed('0')),
                        _buildButton('.',
                            onPressed: () => _onNumberPressed('.')),
                        _buildButton('=',
                            color: CustomColors.primaryLight,
                            textColor: Colors.white,
                            onPressed: _onEqualsPressed),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
