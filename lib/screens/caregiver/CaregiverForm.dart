import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:medical_health_firebase/main.dart';


class CaregiverForm extends StatefulWidget {

  @override
  _CaregiverFormState createState() => _CaregiverFormState();
}

class _CaregiverFormState extends State<CaregiverForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _positionController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> _uploadImage(File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('caregiver_photo/${DateTime.now().toString()}');
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? caregiverphotoUrl;
      if (_image != null) {
        caregiverphotoUrl = await _uploadImage(_image!);
      }

      await FirebaseFirestore.instance.collection('caregivers').add({
        'name': _nameController.text,
        'position': _positionController.text,
        'location': _locationController.text,
        'description': _descriptionController.text,
        'caregiverphotoUrl': caregiverphotoUrl ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Created Caregiver!')),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'POST A CAREGIVER',
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 2,
            wordSpacing: 2,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.edit),
        //     onPressed: () {
        //       // Navigate to ModifyJobScreen with a sample jobId
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => ModifyJobListScreen(),
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Caregiver Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Caregiver Name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _positionController,
                decoration: InputDecoration(labelText: 'Position'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a position';
                  }
                  return null;
                },
              ),
              TextFormField(
                maxLines: 2,
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Job Description'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job description';
                  }
                  return null;
                },
              ),
            
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '📷',
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(width: 10),
                    Text('Select Caregiver Photo'),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _image == null
                  ? Text('No image selected.')
                  : Image.file(
                _image!,
                height: 150,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),),
                    backgroundColor: kPrimaryColor),
                onPressed: _submitForm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 1,
                      wordSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: white,
                    ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
