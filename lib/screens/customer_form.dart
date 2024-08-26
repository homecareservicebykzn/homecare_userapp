import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical_health_firebase/screens/success.dart';
import '../main.dart';
import 'package:flutter/cupertino.dart';

class CustomerInfoForm extends StatefulWidget {
  final String caregiverName;
  final String label;
  final List<DateTime> dutyDates;
  final int days;
  final String selectedTime;
  final String caregiverPhotoUrl; // Add this line

  CustomerInfoForm({
    required this.caregiverName,
    required this.label,
    required this.dutyDates,
    required this.days,
    required this.selectedTime,
    required this.caregiverPhotoUrl, // Initialize here
  });

  @override
  _CustomerInfoFormState createState() => _CustomerInfoFormState();
}

class _CustomerInfoFormState extends State<CustomerInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String price;
  late int totalPrice;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    price = getPrice(widget.label);
    calculateTotalPrice();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String getPrice(String label) {
    switch (label) {
      case '8 Hours Duty (Day Shift)':
      case '8 Hours (Night Shift)':
        return '799';
      case '12 Hours (Day Shift)':
      case '12 Hours (Night Shift)':
        return '999';
      case '24 Hours (Day + Night)':
        return '1399';
      default:
        return '0';
    }
  }

  void calculateTotalPrice() {
    int pricePerDay = int.parse(price);
    totalPrice = pricePerDay * widget.days;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      final name = _nameController.text;
      final phone = _phoneController.text;
      final address = _addressController.text;
      final caregiverPhotoUrl = widget.caregiverPhotoUrl; // Get the photo URL from the widget

      await Future.delayed(Duration(seconds: 1));

      try {
        await _firestore.collection('appointments').add({
          'caregiverName': widget.caregiverName,
          'label': widget.label,
          'dutyDates': widget.dutyDates.map((date) => date.toIso8601String()).toList(),
          'days': widget.days,
          'selectedTime': widget.selectedTime,
          'pricePerDay': price,
          'totalPrice': totalPrice,
          'customerName': name,
          'phone': phone,
          'address': address,
          'caregiverPhotoUrl': caregiverPhotoUrl, // Save the photo URL in Firestore
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your order has been submitted'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to SuccessPage after a short delay to show SnackBar
        await Future.delayed(Duration(seconds: 2));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(
              appointmentData: {
                'caregiverName': widget.caregiverName,
                'label': widget.label,
                'dutyDates': widget.dutyDates.map((date) => date.toIso8601String()).toList(),
                'days': widget.days,
                'selectedTime': widget.selectedTime,
                'pricePerDay': price,
                'totalPrice': totalPrice,
                'customerName': name,
                'phone': phone,
                'address': address,
                'caregiverPhotoUrl': caregiverPhotoUrl, // Pass the photo URL to SuccessPage
              },
              caregiverPhotoUrl: caregiverPhotoUrl, // Pass the photo URL to SuccessPage
            ),
          ),
              (Route<dynamic> route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit form: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BOOKING INFORMATION',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 13),
                        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CupertinoActivityIndicator(
                radius: 20.0,
                color: CupertinoColors.activeBlue,
              ),
            ),
        ],
      ),
    );
  }
}
