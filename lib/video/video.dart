import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:math';

import '../../main.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Random _random = Random();

  Future<List<DocumentSnapshot>> getRandomDocuments(String collection, int limit) async {
    final QuerySnapshot querySnapshot = await _db.collection(collection).get();
    final List<DocumentSnapshot> allDocs = querySnapshot.docs;
    allDocs.shuffle(_random);
    return allDocs.take(limit).toList();
  }
}

class VideoPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: _firestoreService.getRandomDocuments('videos', 10), // Fetch 10 random videos
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              List<DocumentSnapshot> docs = snapshot.data!;
              return Stack(
                children: [
                  Swiper(
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return VideoItem(
                        videoUrl: docs[index]['videoUrl'],
                        videoName: docs[index]['videoName'],
                        videouploaderName: docs[index]['videouploaderName'],
                        videoDesc: docs[index]['videoDesc'],
                      );
                    },
                    itemCount: docs.length,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading videos'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class VideoItem extends StatefulWidget {
  final String videoUrl;
  final String videoName;
  final String videouploaderName;
  final String videoDesc;

  const VideoItem({
    required this.videoUrl,
    required this.videoName,
    required this.videouploaderName,
    required this.videoDesc,
  });

  static void pauseAllVideos() {
    _VideoItemState.pauseCurrentVideo();
  }

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  static VideoPlayerController? _currentController;
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerFuture = _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final file = await DefaultCacheManager().getSingleFile(widget.videoUrl);
    _controller = VideoPlayerController.file(file);
    await _controller!.initialize();
    _controller!.setLooping(true);
    _controller!.play();
    setState(() {
      _currentController = _controller;
    });
  }

  static void pauseCurrentVideo() {
    _currentController?.pause();
  }

  @override
  void dispose() {
    _controller?.pause();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller != null && _controller!.value.isPlaying) {
          _controller!.pause();
        } else {
          _controller?.play();
        }
      },
      child: Stack(
        children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && _controller != null) {
                return Center(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _controller != null
                ? VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
            )
                : SizedBox.shrink(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 110),
                        Row(
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage("assets/logo.png"),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.videouploaderName,
                              style: TextStyle(
                                color: kWhiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.verified,
                              size: 15,
                              color: kWhiteColor,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            widget.videoName,
                            style: TextStyle(
                              color: kWhiteColor,
                            ),
                          ),
                        ),
                        Text(
                          widget.videoDesc,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: kWhiteColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: IconButton(
          //     iconSize: 30,
          //     icon: const Icon(Icons.camera_alt_outlined,),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => VideoUploadForm(),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}


