import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/registerscreen.dart';
import 'package:http/http.dart' as http;
  // Import LocationScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _status = "Please log in";  // Default status message
  
  // Function to send login request to the backend
  Future<void> _login() async {
    const String backendUrl = 'http://localhost:8080/login';  // Replace with your Spring Boot login URL

    // Create a Map with username and password
    final loginData = {
      'userName': _usernameController.text,
      'password': _passwordController.text,
    };

    try {
      // Send POST request to backend with username and password
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(loginData),  // Convert login data to JSON
      );

      // Log the response status and body for debugging
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

     List<String> responseParts = response.body.split(' ');

  // Extract the first value (body) and second value (userId)
      String body = responseParts[0];
      int userId = int.parse(responseParts[1]);

      // Check the response
      if (response.statusCode == 200) {
        if (body == 'success') {
          // If the response is 'success', navigate to the LocationScreen
          setState(() {
            _status = "Login successful!";
          });

          // Navigate to the LocationScreen after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LocationScreen(id: userId,)),
          );
        } else {
          // If the response is anything else, show an error message
          setState(() {
            _status = "Login failed";  // Show error message from response
          });
        }
      } else {
        setState(() {
          _status = "Login failed: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _status = "Error: $e";
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,  // Trigger the login function
              child: const Text("Login"),
            ),
            const SizedBox(height: 20),
            Text('Status: $_status'),  // Display the login status
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to RegisterScreen if the user needs to register
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: const Text("Don't have an account? Register here"),
            ),
          ],
        ),
      ),
    );
  }
}
