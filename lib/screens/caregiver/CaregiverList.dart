import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../main.dart';
import 'CaregiverForm.dart';
import 'Caregivermanage.dart';

class CaregiverListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MANAGE CAREGIVER',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: kPrimaryColor,
          ),),
        actions: [
          IconButton(
            icon: Icon(Icons.add,
              color: kPrimaryColor,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CaregiverForm()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('caregivers').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Something went wrong.'),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Add retry logic
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final caregivers = snapshot.data?.docs ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              // Trigger a refresh to get the latest data
              // In real-world scenarios, you might need to handle refresh explicitly
            },
            child: ListView.builder(
              itemCount: caregivers.length,
              itemBuilder: (context, index) {
                final caregiver = caregivers[index];
                final data = caregiver.data() as Map<String, dynamic>?;

                String name = data?['name'] ?? 'No Name';
                String position = data?['position'] ?? 'No Position';
                String location = data?['location'] ?? 'Unknown Location';
                String? photoUrl = data?['caregiverphotoUrl'];
                bool isAvailable = data != null && data['available'] == true;
                String statusText = isAvailable ? 'Available' : 'On Duty';

                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CaregiverManagePage(caregiver: caregiver),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: photoUrl ?? '',
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
                              Text(
                                name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                position,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                location,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                statusText,
                                style: TextStyle(
                                  color: isAvailable ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: isAvailable ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
     );
  }
}
