import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:medical_health_firebase/screens/photoslider/sliderupload.dart';

import '../../main.dart';

class PhotoListPage extends StatelessWidget {
  Future<void> _deletePhoto(BuildContext context, String photoId) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('CONFIRM DELETE',
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 2,
              wordSpacing: 2,
              color:
              kPrimaryColor, // Assuming you have a color defined as kPrimaryColor
              fontWeight: FontWeight.bold,
            ),),
          content: Text('Are you sure you want to delete this photo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance.collection('photoslider').doc(photoId).delete();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting photo: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PHOTO SLIDER LIST',
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 2,
            wordSpacing: 2,
            color:
            kPrimaryColor, // Assuming you have a color defined as kPrimaryColor
            fontWeight: FontWeight.bold,
          ),),
        actions: [
          IconButton(
            icon: Icon(Icons.add,
            color: kPrimaryColor,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SliderUpload()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('photoslider')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator(radius: 20.0));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final photos = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              final data = photo.data() as Map<String, dynamic>;
              final url = data['url'] as String?;
              final photoId = photo.id;

              return Dismissible(
                key: Key(photoId), // Use the photoId as the key for identification
                background: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Deletion'),
                        content: Text('Are you sure you want to delete this photo?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('No'),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  _deletePhoto(context, photoId);
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: url ?? '',
                      placeholder: (context, url) =>
                          Center(child: CupertinoActivityIndicator(radius: 20.0)),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      height: 210,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      );
  }
}
