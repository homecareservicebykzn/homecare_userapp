import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/text_widget.dart';
import 'Home.dart';
import 'appointment.dart';

class DetailPage extends StatefulWidget {
  final Caregiver caregiver;
  DetailPage({super.key, required this.caregiver});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool animate = false;
  double opacity = 0.0;
  late Size size;
  String selectedOption = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, animator);
  }

  void animator() {
    setState(() {
      opacity = opacity == 0.0 ? 1.0 : 0.0;
      animate = !animate;
    });
  }

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
    print('Selected Option: $option');
  }

  void proceedToAppointment() {
    if (selectedOption.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Appointment(
            0, // Provide necessary index
            caregiver: widget.caregiver,
            selectedOption: selectedOption,
          ),
        ),
      );
    } else {
      // Show a message to the user if no option is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a duty to Proceed your Booking'),
          backgroundColor: kPrimaryColor),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 45),
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            buildAnimatedImage(),
            buildCaregiverDetails(),
            buildGradientOverlay(),
            buildSkillsSection(),
            buildBookingOptions(),
            buildProceedButton(),
            buildBackButton(),
          ],
        ),
      ),
    );
  }

  Widget buildAnimatedImage() {
    return AnimatedPositioned(
      top: 1,
      right: animate ? -100 : -200,
      duration: const Duration(milliseconds: 400),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: opacity,
        child: Container(
          height: size.height / 1.9,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(widget.caregiver.caregiverphotoUrl),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCaregiverDetails() {
    return AnimatedPositioned(
      left: animate ? 1 : -100,
      duration: const Duration(milliseconds: 400),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: opacity,
        child: Container(
          padding: const EdgeInsets.only(top: 80, left: 20),
          height: size.height / 1.9,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.caregiver.name,
                style: TextStyle(
                  fontSize: 23,
                  letterSpacing: 1,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '❤️ ${widget.caregiver.position} 🩷',
                style: TextStyle(
                  color: Colors.black.withOpacity(.6),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              buildDetailsRow(Icons.star, "Rating", "5", kPrimaryColor, Colors.black.withOpacity(.5)),
              const SizedBox(height: 15),
              buildDetailsRow(Icons.people_rounded, "Patient", "30 +", kPrimaryColor, Colors.black.withOpacity(.5)),
              const SizedBox(height: 15),
              buildDetailsRow(Icons.attach_money, "Start From", "฿799", kPrimaryColor, Colors.black.withOpacity(.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailsRow(IconData icon, String title, String value, Color iconColor, Color textColor) {
    return Row(
      children: [
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SizedBox(
            height: 60,
            width: 60,
            child: Center(
              child: Icon(icon, color: iconColor, size: 30),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(title, 17, textColor, FontWeight.bold),
            const SizedBox(height: 10),
            TextWidget(value, 20, kPrimaryColor, FontWeight.bold),
          ],
        ),
      ],
    );
  }

  Widget buildGradientOverlay() {
    return AnimatedPositioned(
      top: 350,
      right: animate ? 1 : -50,
      duration: const Duration(milliseconds: 400),
      child: Container(
        height: 150,
        width: size.width / 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(.1),
              Colors.white,
              Colors.white,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSkillsSection() {
    return AnimatedPositioned(
      top: animate ? 420 : 510,
      left: 1,
      right: 1,
      duration: const Duration(milliseconds: 400),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: opacity,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 40),
          height: size.height / 4,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget("SKILLS", 22, Colors.black, FontWeight.bold),
              const SizedBox(height: 10),
              Text(
                widget.caregiver.description,
                style: TextStyle(
                  color: Colors.black.withOpacity(.9),
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),

              SizedBox(height: 10),

              Text(
                widget.caregiver.location,
                style: TextStyle(
                  color: Colors.black.withOpacity(.9),
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildBookingOptions() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: animate ? 60 : -20,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 400),
        child: Container(
          height: 150,
          width: size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: buildBookingOptionCards(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildBookingOptionCards() {
    final options = [
      {"label": "Day 8 Hours", "price": "799"},
      {"label": "Night 8 Hours", "price": "799"},
      {"label": "Day 12 Hours", "price": "999"},
      {"label": "Night 12 Hours", "price": "999"},
      {"label": "Day + Night", "price": "1399"},
    ];

    return options.map((option) {
      return InkWell(
        onTap: () => selectOption(option["label"]!),
        child: Card(
          color: selectedOption == option["label"]
              ? kPrimaryColor
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            height: 60,
            width: 139,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      TextWidget(
                        "฿",
                        14,
                        selectedOption == option["label"]
                            ? Colors.white
                            : kPrimaryColor,
                        FontWeight.bold,
                      ),
                      TextWidget(
                        option["price"]!,
                        14,
                        selectedOption == option["label"]
                            ? Colors.white
                            : kPrimaryColor,
                        FontWeight.bold,
                      ),
                    ],
                  ),
                  TextWidget(
                    option["label"]!,
                    14,
                    selectedOption == option["label"]
                        ? Colors.white
                        : kPrimaryColor,
                    FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget buildProceedButton() {
    return AnimatedPositioned(
      bottom: animate ? 15 : -80,
      left: 30,
      right: 30,
      duration: const Duration(milliseconds: 400),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: opacity,
        child: InkWell(
          onTap: () async {
            animator();
            await Future.delayed(const Duration(milliseconds: 400));
            proceedToAppointment(); // Call the function to handle validation and navigation
            animator();
          },
          child: Container(
            height: 65,
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: kPrimaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget("Proceed to Booking", 18, Colors.white, FontWeight.w700),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios_outlined, color: Colors.white, size: 18),
                Icon(Icons.arrow_forward_ios_outlined, color: Colors.white.withOpacity(.5), size: 18),
                Icon(Icons.arrow_forward_ios_outlined, color: Colors.white.withOpacity(.2), size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackButton() {
    return Positioned(
      top: 5,
      right: 20,
      left: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              animator();
              Timer(const Duration(milliseconds: 500), () {
                Navigator.pop(context);
              });
            },
            child: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black,
            ),
          ),
          Container(height: 10),
        ],
      ),
    );
  }
}
