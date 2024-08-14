// ignore: file_names
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeliveryAddressScreenState createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  late final String _userId;
  List<DocumentSnapshot> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      await _fetchAddresses();
    }
  }

  Future<void> _fetchAddresses() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('addresses')
        .get();

    setState(() {
      _addresses = snapshot.docs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Addresses'),
        foregroundColor: const Color.fromARGB(255, 252, 252, 252),
        backgroundColor: const Color(0xFF25424D),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _addresses.isEmpty
              ? const Center(child: Text('No addresses available'))
              : ListView.builder(
                  itemCount: _addresses.length,
                  itemBuilder: (context, index) {
                    final address = _addresses[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(address['address'] ?? 'Address'),
                      subtitle: Text(address['type'] ?? 'Type'),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Address screen
        },
        backgroundColor: const Color(0xFF25424D),
        foregroundColor: const Color.fromARGB(255, 252, 252, 252),
        child: const Icon(Icons.add),
      ),
    );
  }
}
