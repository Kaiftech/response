import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  String _error = '';
  bool _isLoading = false;
  double _errorOpacity = 0.0; // Initial opacity for the error message

  void _clearErrors() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _error = '';
    });
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter an email address';
    } else if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (!_isLoading) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          _error = 'Please fill in all fields';
          _errorOpacity = 1.0; // Show the error message
        });

        // Wait for a moment before hiding the error message
        await Future.delayed(const Duration(seconds: 3));

        // Hide the error message
        setState(() {
          _errorOpacity = 0.0;
        });
        return;
      }

      _clearErrors(); // Clear any previous errors

      final emailError = _validateEmail(email);
      final passwordError = _validatePassword(password);

      if (emailError != null || passwordError != null) {
        setState(() {
          _emailError = emailError;
          _passwordError = passwordError;
        });
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isUserSignedIn', true);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _error = 'Invalid credentials';
          _errorOpacity = 1.0; // Show the error message
        });

        // Wait for a moment before hiding the error message
        await Future.delayed(const Duration(seconds: 3));

        // Hide the error message
        setState(() {
          _errorOpacity = 0.0;
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _emailError,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    _emailError = _validateEmail(value);
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _passwordError,
                ),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _passwordError = _validatePassword(value);
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    _isLoading || _emailError != null || _passwordError != null
                        ? null
                        : _signInWithEmailAndPassword,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Log In'),
              ),
              const SizedBox(height: 20),
              AnimatedOpacity(
                opacity: _errorOpacity,
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _error,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
