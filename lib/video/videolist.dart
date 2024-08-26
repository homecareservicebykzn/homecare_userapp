import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical_health_firebase/video/videoupload.dart';

class VideoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoUploadForm()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('videos')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final videos = snapshot.data?.docs ?? [];

          if (videos.isEmpty) {
            return Center(child: Text('No videos found.', style: TextStyle(fontSize: 18, color: Colors.grey)));
          }

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              final data = video.data() as Map<String, dynamic>;
              final videoName = data['videoName'] as String?;
              final docId = video.id; // Document ID for delete operations

              return ListTile(
                contentPadding: EdgeInsets.all(8),
                title: Text(videoName ?? 'No Name', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    bool? confirm = await _showDeleteConfirmationDialog(context);
                    if (confirm == true) {
                      await _deleteVideo(context, docId, data['videoUrl'] as String?);
                    }
                  },
                ),
                onTap: () {
                  // You can add navigation to a detailed view here if needed
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Video'),
          content: Text('Are you sure you want to delete this video?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteVideo(BuildContext context, String docId, String? videoUrl) async {
    try {
      // Delete the video file from Firebase Storage
      if (videoUrl != null) {
        var storageRef = FirebaseStorage.instance.refFromURL(videoUrl);
        await storageRef.delete();
      }

      // Delete the video record from Firestore
      await FirebaseFirestore.instance.collection('videos').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete video: $e')),
      );
    }
  }
}
