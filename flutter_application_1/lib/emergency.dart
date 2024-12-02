import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddEmergencyContactsScreen extends StatefulWidget {
  final int userId;

  const AddEmergencyContactsScreen({super.key, required this.userId});
  @override
  _AddEmergencyContactsScreenState createState() => _AddEmergencyContactsScreenState();
}

class _AddEmergencyContactsScreenState extends State<AddEmergencyContactsScreen> {
  final List<Map<String, String>> _contacts = [];
  final _formKey = GlobalKey<FormState>(); // FormKey for validation

  // Function to handle adding a contact
  void _addContact() {
    if (_contacts.length < 5) {
      _contacts.add({'name': '', 'phoneNumber': ''});
    }
    setState(() {});
  }

  // Function to handle saving contacts to the server
  Future<void> _saveContacts() async {
    final String backendUrl = 'http://localhost:8080/${widget.userId}/contacts'; // User-specific endpoint

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_contacts),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contacts saved successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error saving contacts')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send data: $error')));
    }
  }

  // Regex for validating phone number starting with +91 and followed by 10 digits
  bool _isPhoneNumberValid(String phoneNumber) {
    final regex = RegExp(r'^\+91\d{10}$');
    return regex.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Emergency Contacts")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: TextFormField(
                        decoration: const InputDecoration(labelText: 'Contact Name'),
                        onChanged: (value) {
                          setState(() {
                            _contacts[index]['name'] = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      subtitle: TextFormField(
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                        onChanged: (value) {
                          setState(() {
                            _contacts[index]['phoneNumber'] = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          if (!_isPhoneNumberValid(value)) {
                            return 'Phone number must start with +91 and have 10 digits';
                          }
                          return null;
                        },
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _addContact,
                child: const Text("Add Another Contact"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Validate all fields
                  if (_formKey.currentState?.validate() ?? false) {
                    _saveContacts();
                  }
                },
                child: const Text("Save Contacts"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
