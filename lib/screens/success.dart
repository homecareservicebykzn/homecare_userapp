import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import '../main.dart';
import 'Home.dart';

class SuccessPage extends StatefulWidget {
  final Map<String, dynamic> appointmentData;
  final String caregiverPhotoUrl;

  SuccessPage({required this.appointmentData, required this.caregiverPhotoUrl});

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  GlobalKey _globalKey = GlobalKey();
  bool _isCapturing = false;

  Future<void> _captureSaveAndGoHome() async {
    setState(() {
      _isCapturing = true;
    });

    try {
      if (_globalKey.currentContext != null) {
        RenderRepaintBoundary boundary = _globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 2.0);
        ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        Uint8List rawBytes = byteData!.buffer.asUint8List();

        img.Image capturedImage =
        img.Image.fromBytes(image.width, image.height, rawBytes);
        List<int> jpgBytes = img.encodeJpg(capturedImage, quality: 100);

        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/caregiverbooking.jpg');
        await file.writeAsBytes(jpgBytes);

        final result = await GallerySaver.saveImage(file.path,
            albumName: 'caregiverbooking');
        print(result);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Center(child: Text('Appointment Photo saved in Your Photo Gallery')),
              backgroundColor: Colors.green),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
        );
      } else {
        print('Error: context is null');
      }
    } catch (e) {
      print('Error capturing and saving screenshot: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Center(child: Text('Failed to save Appointment Photo: $e')),
            backgroundColor: kPrimaryColor),
      );
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd MMMM yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointmentData;
    final formattedDates = appointment['dutyDates']
        .map<String>((date) => formatDate(date))
        .join("\n");

    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),

      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
        child: Column(
          children: [
            Expanded(
              child: RepaintBoundary(
                key: _globalKey,
                child: Container(
                  padding: EdgeInsetsDirectional.all(20),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${appointment['caregiverName']}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          softWrap: true,
                        ),
                        SizedBox(height: 20),
                        CachedNetworkImage(
                          imageUrl: widget.caregiverPhotoUrl,
                          width: MediaQuery.of(context).size.height * 0.25,
                          height: MediaQuery.of(context).size.height * 0.25,
                          fit: BoxFit.contain,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Position', softWrap: true),
                                  Text(
                                    'Caregiver',
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Phone Number', softWrap: true),
                                  Text(
                                    '095 994 9437',
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Duty',
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                  ),
                                  Text(
                                    '${appointment['label']}',
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Duty Time',
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                  ),
                                  Text(
                                    '${appointment['selectedTime']}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Booking Dates',
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                  ),
                                  Text(
                                    formattedDates,
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Price',
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                  ),
                                  Text(
                                    '฿${appointment['pricePerDay']} x ${appointment['days']} day(s)',
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Divider(),
                                  Text(
                                    'Total: ฿${appointment['totalPrice']}',
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isCapturing
          ? null
          : Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _captureSaveAndGoHome,
            child: Text('Go to Home Page'),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
