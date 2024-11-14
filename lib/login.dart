import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riqapp/forgot_password.dart';
import 'package:riqapp/home/home_page.dart';
import 'package:riqapp/register.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riqapp/custom_colors.dart' as colors;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final String identifier = _identifierController.text.trim();
        final String password = _passwordController.text.trim();

        // Attempt to find user by email
        final QuerySnapshot emailSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: identifier)
            .get();

        // Attempt to find user by name if no email match was found
        final List<QueryDocumentSnapshot> matchingDocs =
            emailSnapshot.docs.isNotEmpty
                ? emailSnapshot.docs
                : (await FirebaseFirestore.instance
                        .collection('users')
                        .where('name', isEqualTo: identifier)
                        .get())
                    .docs;

        if (matchingDocs.isEmpty) {
          _showErrorMessage('No user found');
          return;
        }

        // Check password
        final userData = matchingDocs.first.data() as Map<String, dynamic>;
        if (userData['password'] != password) {
          _showErrorMessage('Invalid password');
          return;
        }

        // Login successful
        _showSuccessMessage('Login successful!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } catch (e) {
        _showErrorMessage('An error occurred: ${e.toString()}');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: colors.CustomColors.errorColor,
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
      backgroundColor: colors.CustomColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shadowColor: colors.CustomColors.primaryColor.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        colors.CustomColors.accentColor.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: colors.CustomColors.primaryColor
                                      .withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 250,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 20),

                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                colors.CustomColors.primaryDark,
                                colors.CustomColors.primaryColor,
                              ],
                            ).createShader(bounds),
                          ),
                          const SizedBox(height: 20),

                          // Email/Name Field
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: colors.CustomColors.primaryColor
                                      .withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _identifierController,
                              style: GoogleFonts.bitter(
                                  color: colors.CustomColors.primaryDark),
                              decoration: InputDecoration(
                                labelText: 'Email or Username',
                                hintText: 'Enter your email or username',
                                labelStyle: GoogleFonts.bitter(
                                    color: colors.CustomColors.primaryColor),
                                prefixIcon: const Icon(Icons.person_outline,
                                    color: colors.CustomColors.primaryColor),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: colors.CustomColors.primaryLight
                                          .withOpacity(0.2)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: colors.CustomColors.primaryColor),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email or username';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Password Field
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: colors.CustomColors.primaryColor
                                      .withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              style: GoogleFonts.bitter(
                                  color: colors.CustomColors.primaryDark),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                labelStyle: GoogleFonts.bitter(
                                    color: colors.CustomColors.primaryColor),
                                prefixIcon: const Icon(Icons.lock_outline,
                                    color: colors.CustomColors.primaryColor),
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: colors.CustomColors.primaryColor,
                                  ),
                                  onPressed: () => setState(
                                      () => _obscureText = !_obscureText),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: colors.CustomColors.primaryLight
                                          .withOpacity(0.2)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: colors.CustomColors.primaryColor),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Forgot Password Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordPage()),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      colors.CustomColors.primaryColor,
                                ),
                                child: Text(
                                  'Forgot password?',
                                  style: GoogleFonts.bitter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Login Button
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [
                                  colors.CustomColors.primaryColor,
                                  colors.CustomColors.primaryDark,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colors.CustomColors.primaryColor
                                      .withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
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
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Sign in',
                                      style: GoogleFonts.bitter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account? ',
                                style: GoogleFonts.bitter(
                                  color: colors.CustomColors.primaryLight,
                                  fontSize: 13,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage()),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      colors.CustomColors.primaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                child: Text(
                                  'Sign up',
                                  style: GoogleFonts.bitter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
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
            ),
          ),
        ),
      ),
    );
  }
}
