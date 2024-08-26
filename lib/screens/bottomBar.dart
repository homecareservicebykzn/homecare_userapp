// import 'package:flutter/material.dart';
// import 'package:bottom_navy_bar/bottom_navy_bar.dart';
// import 'package:medical_health_firebase/main.dart';
// import 'package:medical_health_firebase/screens/userprofile.dart';
//
// import '../video/video.dart';
// import 'Home.dart';
// import 'admin.dart';
//
// class BottomNavPage extends StatefulWidget {
//   @override
//   _BottomNavPageState createState() => _BottomNavPageState();
// }
//
// class _BottomNavPageState extends State<BottomNavPage> {
//   int _currentIndex = 0;
//   PageController _pageController = PageController(initialPage: 0);
//
//   static List<Widget> _widgetOptions = [
//     HomePage(),
//     VideoPage(),
//     Admin(),
//     Admin(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//       if (_currentIndex != 0) {
//         VideoItem.pauseAllVideos();
//       }
//       _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Color bottomNavColor = _currentIndex == 1 ? Colors.black : Colors.white;
//     Color iconAndTextColor = _currentIndex == 1 ? Colors.white : kPrimaryColor;
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         children: _widgetOptions,
//         onPageChanged: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//       bottomNavigationBar: BottomNavyBar(
//         backgroundColor: bottomNavColor,
//         selectedIndex: _currentIndex,
//         onItemSelected: _onItemTapped,
//         items: <BottomNavyBarItem>[
//           BottomNavyBarItem(
//             icon: Icon(Icons.home, color: iconAndTextColor),
//             title: Text('Home', style: TextStyle(color: iconAndTextColor)),
//             activeColor: primary,
//           ),
//           BottomNavyBarItem(
//             icon: Icon(Icons.tiktok, color: iconAndTextColor),
//             title: Text('Care', style: TextStyle(color: iconAndTextColor)),
//             activeColor: _currentIndex == 1 ? Colors.black : primary,
//           ),
//           BottomNavyBarItem(
//             icon: Icon(Icons.favorite, color: iconAndTextColor),
//             title: Text('Info', style: TextStyle(color: iconAndTextColor)),
//             activeColor: primary,
//           ),
//           BottomNavyBarItem(
//             icon: Icon(Icons.person, color: iconAndTextColor),
//             title: Text('Profile', style: TextStyle(color: iconAndTextColor)),
//             activeColor: primary,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// const primary = Color(0xff0085C2);
