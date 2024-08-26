import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;

import '../../main.dart';



class SliderUpload extends StatefulWidget {
  @override
  _SliderUploadState createState() => _SliderUploadState();
}

class _SliderUploadState extends State<SliderUpload> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  bool _isUploading = false;
  String? _uploadedFileURL;

  Future chooseFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future uploadFile() async {
    if (_imageFile == null) return;
    setState(() {
      _isUploading = true;
    });
    File file = File(_imageFile!.path);
    String fileName = Path.basename(file.path);
    Reference storageReference =
    FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() async {
      _uploadedFileURL = await storageReference.getDownloadURL();
      FirebaseFirestore.instance.collection('photoslider').add({
        'url': _uploadedFileURL,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        _isUploading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "UPLOAD SLIDER IMAGE",
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 2,
            wordSpacing: 2,
            color:
            kPrimaryColor, // Assuming you have a color defined as kPrimaryColor
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          _isUploading
              ? CircularProgressIndicator()
              : IconButton(
            onPressed: chooseFile,
            icon: Icon(Icons.upload, color: kPrimaryColor,),
          ),

        ],
      ),
      body: Center(
        child: Column(

          children: [
            SizedBox(
              height: 20,
            ),
            _imageFile != null
                ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(_imageFile!.path), height: 240))
                : Container(height: 70),
            SizedBox(height: 20),
            _imageFile != null
                ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),),
                  backgroundColor: kPrimaryColor),

              onPressed: _isUploading ? null : uploadFile,
              child: Text('SUBMIT THE PHOTO',
                style: TextStyle(
                  letterSpacing: 1,
                  wordSpacing: 1,
                  fontWeight: FontWeight.bold,

                  color: white,
                ),),) : Container(height: 0),

          ],
        ),
      ),
    );
  }
}
