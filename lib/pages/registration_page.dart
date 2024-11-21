import 'package:flutter/material.dart';
import 'package:tronixbook_project/services/api_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController(); // New controller
  bool obscurePass = true;
  bool obscureConfirmPass = true; // Toggle for confirm password
  final ApiService _apiService = ApiService();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      String? token = await _apiService.register(
        _nameController.text,
        _emailController.text,
        _passController.text,
        _confirmPassController.text,
      );

      if (token != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Registration successful! Please log in.")),
        );
        Navigator.pushReplacementNamed(context, '/loginPage');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Registration failed. Please try again.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 56, 158),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              height: 710,
              width: 400,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.apartment,
                            size: 50.0, color: Colors.blue[900]),
                        const SizedBox(height: 15.0),
                        const Text(
                          'Register to TronixBook',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 8.0),
                        Text('Please enter your details below',
                            style: TextStyle(color: Colors.grey[700])),
                        const SizedBox(height: 32.0),
                        // Username Field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none),
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintText: 'Username',
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none),
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintText: 'Email',
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            final emailRegex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        // Password Field
                        TextFormField(
                          controller: _passController,
                          obscureText: obscurePass,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none),
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(obscurePass
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  obscurePass = !obscurePass;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        // Password Confirmation Field
                        TextFormField(
                          controller: _confirmPassController,
                          obscureText: obscureConfirmPass,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none),
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintText: 'Confirm Password',
                            hintStyle: const TextStyle(color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(obscureConfirmPass
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  obscureConfirmPass = !obscureConfirmPass;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30.0),
                        ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor:
                                const Color.fromARGB(255, 0, 56, 158),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/loginPage'),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 56, 158),
                                    fontWeight: FontWeight.bold),
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
    );
  }
}
