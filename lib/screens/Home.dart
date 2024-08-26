import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:medical_health_firebase/main.dart';
import '../widgets/Slider.dart';
import 'detail.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class Caregiver {
  final String name;
  final String position;
  final String location;
  final String description;
  final String caregiverphotoUrl;
  final bool available;  // New field

  Caregiver({
    required this.name,
    required this.position,
    required this.location,
    required this.description,
    required this.caregiverphotoUrl,
    required this.available,  // New field
  });
}


class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Caregiver>> getCaregivers() async {
    List<Caregiver> caregivers = [];

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('caregivers').get();
      for (var doc in querySnapshot.docs) {
        caregivers.add(Caregiver(
          name: doc['name'],
          position: doc['position'],
          description: doc['description'],
          location: doc['location'],
          caregiverphotoUrl: doc['caregiverphotoUrl'],
          available: doc['available'] ?? false,  // New field
        ));
      }
    } catch (e) {
      print('Error fetching caregivers: $e');
    }

    return caregivers;
  }
}

class HomePage extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HOME  CARE  SERVICE',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: kPrimaryColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {
                launchMessenger();
              },
              icon: Image.asset(
                "assets/messenger.png",
                width: 25,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 220,
            child: SliderWidget(), // Your custom Slider widget
          ),
          Expanded(
            child: FutureBuilder<List<Caregiver>>(
              future: firebaseService.getCaregivers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No caregivers found.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var caregiver = snapshot.data![index];
                      String statusText = caregiver.available ? 'Available' : 'On Duty';
                      Color statusColor = caregiver.available ? Colors.green : Colors.red;

                      return Card(
                        elevation: 1,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            if (caregiver.available) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(caregiver: caregiver),
                                ),
                              );
                            } else {
                              // Show a message or a dialog if the caregiver is not available
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('This caregiver is currently On Duty.'),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: caregiver.caregiverphotoUrl,
                                  placeholder: (context, url) => CupertinoActivityIndicator(
                                    radius: 20.0,
                                    color: CupertinoColors.activeBlue,
                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  height: 120,
                                  width: 100,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            caregiver.name,
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),

                                          Text(
                                            " (${statusText})",
                                            style: TextStyle(
                                              color: statusColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Text('${caregiver.position} (Start From ฿799)'),
                                      SizedBox(height: 4),
                                      RatingBar.builder(
                                        initialRating: 5,
                                        minRating: 5,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemSize: 20.0,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                      SizedBox(height: 4),
                                      Text(caregiver.location),


                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void launchMessenger() async {
    String facebookId = '104970494553207';
    String url;

    if (Platform.isAndroid) {
      url = 'fb-messenger://user/$facebookId';
    } else if (Platform.isIOS) {
      url = 'https://m.me/$facebookId';
    } else {
      throw 'Unsupported platform';
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}


