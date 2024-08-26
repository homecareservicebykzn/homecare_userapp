import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthDataForm extends StatefulWidget {
  @override
  _HealthDataFormState createState() => _HealthDataFormState();
}

class _HealthDataFormState extends State<HealthDataForm> {
  final _formKey = GlobalKey<FormState>();

  // Personal Information
  String _name = '';
  String _dateOfBirth = '';
  String _gender = '';
  String _contactInformation = '';
  String _insuranceDetails = '';

  // Medical History
  String _pastConditions = '';
  String _surgicalHistory = '';
  String _allergies = '';
  String _familyMedicalHistory = '';

  // Current Health Information
  String _currentConditions = '';
  String _medications = '';
  String _vaccinationRecords = '';

  // Lifestyle and Habits
  String _diet = '';
  String _physicalActivity = '';
  String _sleepPatterns = '';
  String _substanceUse = '';

  // Biometric Data
  String _height = '';
  String _weight = '';
  String _bloodPressure = '';
  String _heartRate = '';
  String _bloodGlucose = '';
  String _cholesterolLevels = '';

  // Diagnostic Test Results
  String _labResults = '';
  String _imagingResults = '';

  // Treatment Plans
  String _treatmentPlans = '';
  String _appointments = '';

  // Mental Health Information
  String _mentalHealthInfo = '';

  // Immunization Records
  String _immunizationRecords = '';

  // Emergency Contact Information
  String _emergencyContacts = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _firestore.collection('health_data').add({
        'name': _name,
        'date_of_birth': _dateOfBirth,
        'gender': _gender,
        'contact_information': _contactInformation,
        'insurance_details': _insuranceDetails,
        'past_conditions': _pastConditions,
        'surgical_history': _surgicalHistory,
        'allergies': _allergies,
        'family_medical_history': _familyMedicalHistory,
        'current_conditions': _currentConditions,
        'medications': _medications,
        'vaccination_records': _vaccinationRecords,
        'diet': _diet,
        'physical_activity': _physicalActivity,
        'sleep_patterns': _sleepPatterns,
        'substance_use': _substanceUse,
        'height': _height,
        'weight': _weight,
        'blood_pressure': _bloodPressure,
        'heart_rate': _heartRate,
        'blood_glucose': _bloodGlucose,
        'cholesterol_levels': _cholesterolLevels,
        'lab_results': _labResults,
        'imaging_results': _imagingResults,
        'treatment_plans': _treatmentPlans,
        'appointments': _appointments,
        'mental_health_info': _mentalHealthInfo,
        'immunization_records': _immunizationRecords,
        'emergency_contacts': _emergencyContacts,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data Submitted Successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Data Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Personal Information
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date of Birth'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
                onSaved: (value) {
                  _dateOfBirth = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Gender'),
                onSaved: (value) {
                  _gender = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact Information'),
                onSaved: (value) {
                  _contactInformation = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Insurance Details'),
                onSaved: (value) {
                  _insuranceDetails = value!;
                },
              ),
              // Medical History
              TextFormField(
                decoration: InputDecoration(labelText: 'Past Conditions'),
                onSaved: (value) {
                  _pastConditions = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Surgical History'),
                onSaved: (value) {
                  _surgicalHistory = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Allergies'),
                onSaved: (value) {
                  _allergies = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Family Medical History'),
                onSaved: (value) {
                  _familyMedicalHistory = value!;
                },
              ),
              // Current Health Information
              TextFormField(
                decoration: InputDecoration(labelText: 'Current Conditions'),
                onSaved: (value) {
                  _currentConditions = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Medications'),
                onSaved: (value) {
                  _medications = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Vaccination Records'),
                onSaved: (value) {
                  _vaccinationRecords = value!;
                },
              ),
              // Lifestyle and Habits
              TextFormField(
                decoration: InputDecoration(labelText: 'Diet'),
                onSaved: (value) {
                  _diet = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Physical Activity'),
                onSaved: (value) {
                  _physicalActivity = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Sleep Patterns'),
                onSaved: (value) {
                  _sleepPatterns = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Smoking, Alcohol, and Substance Use'),
                onSaved: (value) {
                  _substanceUse = value!;
                },
              ),
              // Biometric Data
              TextFormField(
                decoration: InputDecoration(labelText: 'Height'),
                onSaved: (value) {
                  _height = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Weight'),
                onSaved: (value) {
                  _weight = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Blood Pressure'),
                onSaved: (value) {
                  _bloodPressure = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Heart Rate'),
                onSaved: (value) {
                  _heartRate = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Blood Glucose Levels'),
                onSaved: (value) {
                  _bloodGlucose = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cholesterol Levels'),
                onSaved: (value) {
                  _cholesterolLevels = value!;
                },
              ),
              // Diagnostic Test Results
              TextFormField(
                decoration: InputDecoration(labelText: 'Laboratory Test Results'),
                onSaved: (value) {
                  _labResults = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Imaging Results'),
                onSaved: (value) {
                  _imagingResults = value!;
                },
              ),
              // Treatment Plans
              TextFormField(
                decoration: InputDecoration(labelText: 'Treatment Plans'),
                onSaved: (value) {
                  _treatmentPlans = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Appointments and Follow-ups'),
                onSaved: (value) {
                  _appointments = value!;
                },
              ),
              // Mental Health Information
              TextFormField(
                decoration: InputDecoration(labelText: 'Mental Health Information'),
                onSaved: (value) {
                  _mentalHealthInfo = value!;
                },
              ),
              // Immunization Records
              TextFormField(
                decoration: InputDecoration(labelText: 'Immunization Records'),
                onSaved: (value) {
                  _immunizationRecords = value!;
                },
              ),
              // Emergency Contact Information
              TextFormField(
                decoration: InputDecoration(labelText: 'Emergency Contacts'),
                onSaved: (value) {
                  _emergencyContacts = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
