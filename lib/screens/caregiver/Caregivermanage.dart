import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CaregiverManagePage extends StatefulWidget {
  final QueryDocumentSnapshot caregiver;

  CaregiverManagePage({required this.caregiver});

  @override
  _CaregiverManagePageState createState() => _CaregiverManagePageState();
}

class _CaregiverManagePageState extends State<CaregiverManagePage> {
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  bool _isAvailable = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.caregiver['name']);
    _positionController = TextEditingController(text: widget.caregiver['position']);
    _locationController = TextEditingController(text: widget.caregiver['location']);
    _descriptionController = TextEditingController(text: widget.caregiver['description']);
    var caregiverData = widget.caregiver.data() as Map<String, dynamic>?; // Safely cast to Map<String, dynamic>
    _isAvailable = caregiverData != null && caregiverData.containsKey('available') ? caregiverData['available'] : false;
  }

  void _updateCaregiver() {
    FirebaseFirestore.instance
        .collection('caregivers')
        .doc(widget.caregiver.id)
        .update({
      'name': _nameController.text,
      'position': _positionController.text,
      'location': _locationController.text,
      'description': _descriptionController.text,
      'available': _isAvailable,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Caregiver Updated')));
      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update caregiver: $error')));
    });
  }

  void _deleteCaregiver() {
    FirebaseFirestore.instance
        .collection('caregivers')
        .doc(widget.caregiver.id)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Caregiver Deleted')));
      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete caregiver: $error')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Caregiver'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteCaregiver,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Caregiver Name'),
              ),
              TextFormField(
                controller: _positionController,
                decoration: InputDecoration(labelText: 'Position'),
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Job Description'),
                maxLines: 5,
              ),
              SwitchListTile(
                title: Text('Available'),
                value: _isAvailable,
                onChanged: (bool value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateCaregiver,
                child: Text('Update Caregiver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
