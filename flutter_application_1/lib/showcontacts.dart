import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Define the EmergencyContact model
class EmergencyContact {
  final String name;
  final String phoneNumber;
  final int id; // Assuming each contact has a unique ID.

  EmergencyContact({required this.name, required this.phoneNumber, required this.id});

  // A method to convert JSON data to an EmergencyContact object
  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      id: json['id'],  // Assuming the backend returns an 'id'
    );
  }
}

class ShowEmergencyContactsScreen extends StatefulWidget {
  final int userId; // User ID to fetch emergency contacts

  const ShowEmergencyContactsScreen({super.key, required this.userId});

  @override
  _ShowEmergencyContactsScreenState createState() => _ShowEmergencyContactsScreenState();
}

class _ShowEmergencyContactsScreenState extends State<ShowEmergencyContactsScreen> {
  late Future<List<EmergencyContact>> _emergencyContacts;

  @override
  void initState() {
    super.initState();
    // Fetch the emergency contacts from the API when the screen is initialized
    _emergencyContacts = _fetchEmergencyContacts(widget.userId);
  }

  // Function to fetch emergency contacts from the backend API
  Future<List<EmergencyContact>> _fetchEmergencyContacts(int userId) async {
    final url = 'http://localhost:8080/${widget.userId}/emergency-contacts';  // Your backend URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the response data
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => EmergencyContact.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load emergency contacts');
      }
    } catch (e) {
      throw Exception('Failed to fetch emergency contacts: $e');
    }
  }

  // Function to handle deleting a contact
  Future<void> _deleteContact(int contactId) async {
    final url = 'http://localhost:8080/$contactId/Delete'; // Your backend delete URL

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          // Reload contacts after successful deletion
          _emergencyContacts = _fetchEmergencyContacts(widget.userId);
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact deleted successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error deleting contact')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete contact: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
      ),
      body: FutureBuilder<List<EmergencyContact>>(
        future: _emergencyContacts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No emergency contacts found.'));
          } else {
            final contacts = snapshot.data!;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(contact.name),
                    subtitle: Text(contact.phoneNumber),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.call),
                          onPressed: () {
                            // Handle the call action, e.g., using url_launcher to dial the number
                            print('Dialing ${contact.phoneNumber}');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Confirm before deleting
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Contact'),
                                  content: const Text('Are you sure you want to delete this contact?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteContact(contact.id); // Call delete function
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
