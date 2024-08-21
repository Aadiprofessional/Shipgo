import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedAge = '12';
  String _selectedGender = 'Male';
  bool _isLoading = false;
  File? _imageFile;

  final List<String> _ages = List.generate(49, (index) => (index + 12).toString());
  final List<String> _genders = ['Male', 'Female', 'Other'];

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  bool _validateInputs() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String phone = _phoneController.text.trim();
    String name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || phone.isEmpty || name.isEmpty || _selectedAge.isEmpty || _selectedGender.isEmpty) {
      _showToast('All fields are required');
      return false;
    }
    if (password != confirmPassword) {
      _showToast('Passwords do not match');
      return false;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showToast('Enter a valid email');
      return false;
    }
    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      _showToast('Enter a valid phone number');
      return false;
    }
    return true;
  }

  Future<void> _handleSignup() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = userCredential.user;

      if (user != null) {
        String imageUrl = '';
        if (_imageFile != null) {
          // Upload image
          final storageRef = FirebaseStorage.instance.ref().child('profile_images/${user.uid}.jpg');
          await storageRef.putFile(_imageFile!);
          imageUrl = await storageRef.getDownloadURL();
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'age': int.parse(_selectedAge),
          'phone': _phoneController.text.trim(),
          'gender': _selectedGender,
          'profileImage': imageUrl,
        });

        // Save user data and token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', user.uid);
        await prefs.setString('name', _nameController.text.trim());
        await prefs.setString('email', _emailController.text.trim());
        await prefs.setString('age', _selectedAge);
        await prefs.setString('phone', _phoneController.text.trim());
        await prefs.setString('gender', _selectedGender);
        await prefs.setString('profileImage', imageUrl);

        _showToast('Signup successful');
        Navigator.pushReplacementNamed(context, '/main');
      }
    } on FirebaseAuthException catch (e) {
      _showToast(e.message ?? 'Signup failed');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Image.asset('images/logo2.png', width: 200, height: 100, fit: BoxFit.contain),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('Sign Up to Shipgo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black)),
              SizedBox(height: 20),
              _buildTextField('Name', _nameController, TextInputType.text, false),
              SizedBox(height: 20),
              _buildTextField('Email', _emailController, TextInputType.emailAddress, false),
              SizedBox(height: 20),
              _buildTextField('Password', _passwordController, TextInputType.text, true),
              SizedBox(height: 20),
              _buildTextField('Confirm Password', _confirmPasswordController, TextInputType.text, false),
              SizedBox(height: 20),
              _buildDropdownField('Age', _ages, _selectedAge, (value) {
                setState(() {
                  _selectedAge = value!;
                });
              }),
              SizedBox(height: 20),
              _buildTextField('Phone Number', _phoneController, TextInputType.phone, false, isPhone: true),
              SizedBox(height: 20),
              _buildGenderField(),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF25424D), width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                    image: _imageFile != null ? DecorationImage(
                      image: FileImage(_imageFile!),
                      fit: BoxFit.cover,
                    ) : null,
                  ),
                  child: _imageFile == null ? Center(child: Text('Upload Profile Image', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF25424D), fontWeight: FontWeight.bold))) : null,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignup,
                  child: _isLoading ? CircularProgressIndicator() : Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF25424D),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 48),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: TextStyle(color: Colors.black)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                      _showToast('Navigating to Login');
                    },
                    child: Text('Login', style: TextStyle(color: Color(0xFF25424D))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType keyboardType, bool isPassword, {bool isPhone = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: isPhone ? TextInputType.number : keyboardType,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            filled: true,
            fillColor: Colors.grey.shade200,
            hintText: 'Enter $label',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Color(0xFF25424D), width: 2.0),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            items: items.map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: TextStyle(color: Color(0xFF25424D))),
            )).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        SizedBox(height: 10),
        Column(
          children: _genders.map((gender) => RadioListTile<String>(
            title: Text(gender),
            value: gender,
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value!;
              });
            },
            activeColor: Color(0xFF25424D),
          )).toList(),
        ),
      ],
    );
  }
}
