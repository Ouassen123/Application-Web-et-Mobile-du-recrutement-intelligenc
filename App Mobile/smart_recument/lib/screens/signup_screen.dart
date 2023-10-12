import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/api.dart' show KeyDerivator;
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _isApplicant = true; // true for Applicant, false for Recruiter
  bool _signupSuccess = false; // Variable to track signup success
  double _opacity = 0.0; // Initial opacity value
  bool _loading = false; // Initial loading state
  bool _animationCompleted = false; // Track if animation has completed

  @override
  void initState() {
    super.initState();
    // Delay the animation to start after a short delay
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0; // Set opacity to fully visible
        _animationCompleted = true; // Animation completed
      });
    });
  }

  Future<void> _signup() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    int userType = _isApplicant ? 0 : 1;

    // Check if both username and password are not empty
    if (username.isNotEmpty && password.isNotEmpty) {
      // Hash the password using PBKDF2
      String hashedPassword = _hashPassword(password);

      // Prepare the request body
      var requestBody = {
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'user_type': userType.toString(),
        'password': hashedPassword,
      };

      setState(() {
        _loading = true; // Set loading state to true
      });

      try {
        // Make the API call to your signup endpoint
        var url = Uri.parse('http://127.0.0.1:8000/signup/');
        var response = await http.post(url, body: requestBody);

        // Check the response status code
        if (response.statusCode == 201) {
          // Successful signup, set signupSuccess to true
          setState(() {
            _signupSuccess = true;
          });

          // Show a success message using SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Signup successful. Please log in.'),
              duration: Duration(seconds: 2),
            ),
          );

          // Redirect to login screen and replace the current screen
          Navigator.pushReplacementNamed(context, '/');
        } else {
          // Display an error message if signup fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to sign up.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        // Handle any exceptions that occur during the API call
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred.'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      setState(() {
        _loading = false; // Set loading state back to false
      });
    } else {
      // Display an error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter username and password.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  String _hashPassword(String password) {
    final salt = 'YourSaltHere';
    final iterations = 1000; // Number of iterations for PBKDF2
    final keyLength = 32; // Length of the derived key (in bytes)

    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), iterations));
    final key = Uint8List.fromList(utf8.encode(salt));
    final params = Pbkdf2Parameters(key, iterations, keyLength);
    pbkdf2.init(params);

    final hash = pbkdf2.process(Uint8List.fromList(utf8.encode(password)));

    return 'pbkdf2_sha256\$$iterations\$$salt\$${base64.encode(hash)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/hero_1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(seconds: 1),
                child: Column(
                  children: [
                    TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(labelText: 'First Name'),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(labelText: 'Last Name'),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: true,
                          groupValue: _isApplicant,
                          onChanged: (bool? value) {
                            setState(() {
                              _isApplicant = value!;
                            });
                          },
                        ),
                        Text('Applicant'),
                        Radio(
                          value: false,
                          groupValue: _isApplicant,
                          onChanged: (bool? value) {
                            setState(() {
                              _isApplicant = value!;
                            });
                          },
                        ),
                        Text('Recruiter'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _loading ? null : _signup,
                child: _loading ? CircularProgressIndicator() : Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF89BA16), // Replace with the desired color
                ),
              ),
              SizedBox(height: 16.0),
              if (_signupSuccess)
                Text(
                  'Signup successful. Please log in.',
                  style: TextStyle(color: Colors.green),
                ),
              if (_animationCompleted)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                  child: Text('Back'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SignupScreen(),
  ));
}
