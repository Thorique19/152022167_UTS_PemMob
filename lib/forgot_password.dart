import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomColors {
  static const primaryColor = Color(0xFF545454);
  static const primaryLight = Color(0xFF787878);
  static const primaryDark = Color(0xFF363636);
  static const accentColor = Color(0xFFE0E0E0);
  static const backgroundColor = Colors.white;
  static const errorColor = Color(0xFFB00020);
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _userFound = false;
  bool _showPasswordField = false;
  bool _obscurePassword = true;
  String? _userId;

  Future<void> _checkEmail() async {
    // Validate the email field
    if (!_formKey.currentState!.validate()) {
      return; // If validation fails, do not proceed
    }

    // If validation passes, proceed with checking the email in Firestore
    setState(() => _isLoading = true);

    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _emailController.text.trim())
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        setState(() {
          _userFound = true;
          _showPasswordField = true;
          _userId = result.docs.first.id;
        });
      } else {
        _showErrorDialog('No account found with this email');
      }
    } catch (e) {
      _showErrorDialog('Error occurred: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(_userId).update({
        'password': _newPasswordController.text.trim(),
        'updatedAt': Timestamp.now(),
      });

      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog('Failed to update password: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  'Password Updated!',
                  style: GoogleFonts.bitter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your password has been successfully updated.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bitter(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Return to login page
                  },
                  child: Text(
                    'Back to Login',
                    style: GoogleFonts.bitter(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CustomColors.errorColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Text(
                    'Forgot Password',
                    style: GoogleFonts.bitter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Enter your email address to reset your password',
                    style: GoogleFonts.bitter(
                      fontSize: 14,
                      color: CustomColors.primaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Email Input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors.primaryColor.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      enabled: !_userFound,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email'; // Error message for empty field
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email'; // Error message for invalid email
                        }
                        return null; // No error if everything is valid
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Check Email Button (shown only before user is found)
                  if (!_userFound)
                    ElevatedButton(
                      onPressed: _isLoading ? null : _checkEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Submit',
                              style: GoogleFonts.bitter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),

                  // New Password Fields (shown only after user is found)
                  if (_showPasswordField) ...[
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.primaryColor.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _newPasswordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Update Password',
                              style: GoogleFonts.bitter(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
