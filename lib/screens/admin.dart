import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'package:medical_health_firebase/screens/photoslider/PhotoListPage.dart';
import 'package:medical_health_firebase/screens/show_appointment.dart';
import '../main.dart';
import '../video/videolist.dart';
import '../video/videoupload.dart';
import 'caregiver/CaregiverList.dart';


class Admin extends StatelessWidget {
  void handleButtonPress(String buttonTitle) {
    print("Pressed $buttonTitle");
    // You can do other actions here, like navigation or updating the state
  }

  // Method to launch the dialer
  void _dialPhoneNumber(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      print('Could not launch $phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 90),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade800,
            backgroundImage: AssetImage('assets/logo.png'), // Replace with actual image url
          ),
          SizedBox(height: 10),
          Text(
            "HOME CARE SERVICE BY KZN",
            style: TextStyle(
              fontSize: 17,
              letterSpacing: 1,
              wordSpacing: 1,
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                CustomButton(
                  title: "VIDEO POSTING",
                  icon: Icons.video_library,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoUploadForm(),
                    ),
                  ),
                ),
                CustomButton(
                  title: "VIDEO MANAGE",
                  icon: Icons.video_collection,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoListPage(),
                    ),
                  ),
                ),
                CustomButton(
                  title: "APPOINTMENT SCHEDULE",
                  icon: Icons.calendar_today,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentsPage(),
                    ),
                  ),
                ),
                CustomButton(
                  title: "CAREGIVER ADD & MANAGE",
                  icon: Icons.person_add,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CaregiverListPage(),
                    ),
                  ),
                ),
                CustomButton(
                  title: "SLIDER ADD & MANAGE",
                  icon: Icons.photo_camera,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotoListPage(),
                    ),
                  ),
                ),
                // CustomButton(
                //   title: "BLOG ADD",
                //   icon: Icons.article,
                //   onPressed: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => BlogFormScreen(),
                //     ),
                //   ),
                // ),
                // CustomButton(
                //   title: "CATEGORY ADD",
                //   icon: Icons.category,
                //   onPressed: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => CategoryFormScreen(),
                //     ),
                //   ),
                // ),
                CustomButton(
                  title: "09 46300 830 (Customer Service)",
                  icon: Icons.phone,
                  onPressed: () => _dialPhoneNumber("09 46300 830"), // Direct dial
                ),
                CustomButton(
                  title: "095 994 9437 (Customer Service)",
                  icon: Icons.phone,
                  onPressed: () => _dialPhoneNumber("095 994 9437"), // Direct dial
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  CustomButton({required this.title, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: kPrimaryColor),
        title: Text(
          title,
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onPressed,
      ),
    );
  }
}
