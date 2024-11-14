import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomColors {
  static const primaryColor = Color(0xFF545454);
  static const primaryLight = Color(0xFF787878);
  static const primaryDark = Color(0xFF363636);
  static const accentColor = Color(0xFFE0E0E0);
  static const backgroundColor = Colors.white;
  static const errorColor = Color(0xFFB00020);
}

class RegisterPage extends StatefulWidget {
  final VoidCallback? onRegistrationSuccess;

  const RegisterPage({super.key, this.onRegistrationSuccess});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        await FirebaseFirestore.instance.collection('users').add({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text
              .trim(), // Note: In production, use proper authentication
          'createdAt': Timestamp.now(),
        });

        // Show success animation and message
        if (mounted) {
          _showSuccessDialog();
        }
      } catch (e) {
        if (mounted) {
          _showErrorMessage(e.toString());
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
                const SizedBox(height: 20),
                Text(
                  'Registration Successful!',
                  style: GoogleFonts.bitter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your account has been created successfully.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bitter(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    widget.onRegistrationSuccess?.call(); // Trigger callback
                    Navigator.pop(context); // Return to login page
                  },
                  child: Text(
                    'Go to Login',
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

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CustomColors.errorColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Create Account',
                    style: GoogleFonts.bitter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  _buildInputField(
                    controller: _nameController,
                    label: ' Username',
                    icon: Icons.person_outline,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: _emailController,
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter your email';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: CustomColors.primaryLight,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter your password';
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  _buildRegisterButton(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: GoogleFonts.bitter(
                          color: CustomColors.primaryLight,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Login',
                          style: GoogleFonts.bitter(
                            color: CustomColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.bitter(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.bitter(color: CustomColors.primaryLight),
          prefixIcon: Icon(icon, color: CustomColors.primaryLight),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _registerUser,
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
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              'Create Account',
              style: GoogleFonts.bitter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
    );
  }
}
