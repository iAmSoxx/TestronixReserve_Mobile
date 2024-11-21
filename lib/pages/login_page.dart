import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tronixbook_project/services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obscurePass = true;
  final ApiService _apiService = ApiService();
  String? _loginError; // Error message variable

  Future<void> _login() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _loginError = null; // Reset error message
    });

    String? token = await _apiService.login(
      _emailController.text,
      _passController.text,
    );

    if (token != null) {
      // Save the token to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      // Navigate to RoomPage
      Navigator.pushNamedAndRemoveUntil(
          context, 'roomPage', (Route<dynamic> route) => false);
    } else {
      setState(() {
        _loginError = "Incorrect email or password. Please try again."; // Set error message for 401
      });
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
              height: 520,
              width: 400,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey, // Attach the form key here
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.apartment,
                          size: 50.0,
                          color: Colors.blue[900],
                        ),
                        const SizedBox(height: 15.0),
                        const Text(
                          'Log in to TronixBook',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Please enter your email and password',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 32.0),
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintText: 'Email',
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
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
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePass
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
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
                        const SizedBox(height: 8.0),
                        // Display error message if login fails
                        if (_loginError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _loginError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        const SizedBox(height: 30.0),
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor:
                                const Color.fromARGB(255, 0, 56, 158),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'registrationPage');
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 56, 158),
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
          ),
        ),
      ),
    );
  }
}
