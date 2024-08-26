import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:medical_health_firebase/main.dart'; // Ensure this contains required Firebase initialization

class VideoUploadForm extends StatefulWidget {
  @override
  _VideoUploadFormState createState() => _VideoUploadFormState();
}

class _VideoUploadFormState extends State<VideoUploadForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _videoNameController = TextEditingController();
  final TextEditingController _videouploaderNameController = TextEditingController();
  final TextEditingController _videoDescController = TextEditingController();

  void _uploadVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        String fileName = 'video_${DateTime.now().millisecondsSinceEpoch}.${result.files.single.extension}';
        var storageRef = FirebaseStorage.instance.ref().child('videos/$fileName');
        var uploadTask = storageRef.putFile(file);
        await uploadTask.whenComplete(() => {});
        String videoUrl = await storageRef.getDownloadURL();
        _submitForm(videoUrl);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload video: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No video selected')),
      );
    }
  }

  void _submitForm(String videoUrl) async {
    if (_formKey.currentState!.validate()) {
      String videoName = _videoNameController.text.trim();
      String uploaderName = _videouploaderNameController.text.trim();
      String videoDesc = _videoDescController.text.trim();

      try {
        await FirebaseFirestore.instance.collection('videos').add({
          'videoUrl': videoUrl,
          'videoName': videoName,
          'videouploaderName': uploaderName,
          'videoDesc': videoDesc,
        });

        _videoNameController.clear();
        _videouploaderNameController.clear();
        _videoDescController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video uploaded successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload video details: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VIDEO UPLOAD',
          style: TextStyle(
            fontSize: 18,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            wordSpacing: 2,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _videoNameController,
                decoration: InputDecoration(labelText: 'Video Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter video name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _videouploaderNameController,
                decoration: InputDecoration(labelText: 'Video Uploader Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Video uploader name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _videoDescController,
                decoration: InputDecoration(labelText: 'Video Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter video description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor, // If your Flutter version still uses primary
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _uploadVideo,
                  child: Text('UPLOAD VIDEO',
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 1,
                      wordSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
