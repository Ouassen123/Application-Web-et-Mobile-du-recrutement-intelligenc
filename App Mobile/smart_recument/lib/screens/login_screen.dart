import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  double _opacity = 0.0; // Initial opacity value
  bool _loading = false; // Initial loading state

  @override
  void initState() {
    super.initState();
    // Delay the animation to start after a short delay
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0; // Set opacity to fully visible
      });
    });
  }

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Check if both username and password are not empty
    if (username.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _loading = true; // Set loading state to true
      });

      // Prepare the request body
      var requestBody = {
        'username': username,
        'password': password,
      };

      // Make the API call to your Django server
      var url = Uri.parse('http://127.0.0.1:8000/login/');
      var response = await http.post(url, body: requestBody);

      // Check the response status code
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        bool loginSuccessful = data['success'];

        if (loginSuccessful) {
          // Navigate to the HomeScreen after successful login
          Navigator.pushReplacementNamed(context, '/home',
              arguments: {'username': username, 'email': data['email']});
        } else {
          // Display an error message if login fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid username or password.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Error response from the API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect to the server.'),
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
                duration: Duration(seconds: 1), // Animation duration
                child: Column(
                  children: [
                    Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.0), // Spacing
                    Text(
                      'Enter your username and password',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.0), // Spacing
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _loading ? null : _login,
                child: _loading ? CircularProgressIndicator() : Text('Login'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF89BA16),
                  padding: EdgeInsets.symmetric(horizontal: 48.0),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF89BA16),
                  padding: EdgeInsets.symmetric(horizontal: 48.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
