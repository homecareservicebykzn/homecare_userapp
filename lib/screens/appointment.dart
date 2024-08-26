import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../main.dart';
import '../widgets/text_widget.dart';
import 'Home.dart';
import 'customer_form.dart';

class Appointment extends StatefulWidget {
  final int index;
  final Caregiver caregiver;
  final String selectedOption;

  Appointment(this.index, {Key? key, required this.caregiver, required this.selectedOption}) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  late Size size;
  bool animate = false;
  double opacity = 0.0;
  List<bool> time = [false, false, false, false, false, false];
  late String price;
  late String label;
  List<DateTime> selectedDates = [];
  int totalPrice = 0;
  String? selectedTime; // Track the selected time
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, animator);
    price = getPrice(widget.selectedOption);
    label = getLabel(widget.selectedOption);
    calculateTotalPrice();
  }

  void animator() {
    setState(() {
      opacity = opacity == 0.0 ? 1.0 : 0.0;
      animate = !animate;
    });
  }

  String getPrice(String selectedOption) {
    switch (selectedOption) {
      case 'Day 8 Hours':
      case 'Night 8 Hours':
        return '799';
      case 'Day 12 Hours':
      case 'Night 12 Hours':
        return '999';
      case 'Day + Night':
        return '1399';
      default:
        return '0';  // Default to 0 if price not available
    }
  }

  String getLabel(String selectedOption) {
    switch (selectedOption) {
      case 'Day 8 Hours':
        return '8 Hours Duty (Day Shift)';
      case 'Night 8 Hours':
        return '8 Hours (Night Shift)';
      case 'Day 12 Hours':
        return '12 Hours (Day Shift)';
      case 'Night 12 Hours':
        return '12 Hours (Night Shift)';
      case 'Day + Night':
        return '24 Hours (Day + Night)';
      default:
        return 'Unknown Option';
    }
  }

  void calculateTotalPrice() {
    int pricePerDay = int.parse(price);
    totalPrice = pricePerDay * selectedDates.length;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    DateTime dayAfterTomorrow = DateTime.now().add(const Duration(days: 2));

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              top: animate ? 1 : 80,
              left: 1,
              bottom: 1,
              right: 1,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: opacity,
                child: Container(
                  padding: const EdgeInsets.only(top: 70),
                  height: double.infinity,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned(
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
                            TextWidget(
                              "BOOKING SCHEDULE",
                              18,
                              kPrimaryColor,
                              FontWeight.bold,
                              letterSpace: 1,
                            ),
                            Container(height: 10),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 20,
                        right: 20,
                        child: SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode.multiple,
                          allowViewNavigation: true,
                          enablePastDates: false,
                          headerHeight: 50,
                          selectionColor: kPrimaryColor,
                          toggleDaySelection: true,
                          showNavigationArrow: true,
                          selectionShape: DateRangePickerSelectionShape.rectangle,
                          onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                            setState(() {
                              selectedDates = dateRangePickerSelectionChangedArgs.value;
                              calculateTotalPrice();
                            });
                          },
                          selectionTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          headerStyle: const DateRangePickerHeaderStyle(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          minDate: dayAfterTomorrow,
                        ),
                      ),
                      Positioned(
                        top: 340,
                        left: 20,
                        child: TextWidget("When would you like to start the duty?", 16, Colors.black, FontWeight.bold),
                      ),
                      Positioned(
                        top: 380,
                        left: 10,
                        right: 10,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(3, (index) {
                                final timeText = "${(index + 9).toString().padLeft(2, '0')}:00 ${index < 3 ? 'AM' : 'PM'}";
                                return InkWell(
                                  onTap: () {
                                    changer(index);
                                    setState(() {
                                      selectedTime = timeText;
                                    });
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 1,
                                    color: time[index] ? kPrimaryColor : Colors.white,
                                    child: Center(
                                      child: SizedBox(
                                        height: 60,
                                        width: 110,
                                        child: Center(
                                          child: TextWidget(
                                            timeText,
                                            17,
                                            time[index] ? Colors.white : kPrimaryColor,
                                            FontWeight.bold,
                                            letterSpace: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 20),
                            Card(
                              elevation: 1,
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                      height: size.height / 7,
                                      width: size.width / 4,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(widget.caregiver.caregiverphotoUrl),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${widget.caregiver.name}   ❤️ ${widget.caregiver.position} 🩷',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          label,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            TextWidget(
                                              "฿$price x ${selectedDates.length} Days = ฿$totalPrice",
                                              15,
                                              kPrimaryColor,
                                              FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 30,
                        right: 30,
                        child: InkWell(
                          onTap: () async {
                            if (selectedDates.isEmpty || selectedTime == null) {
                              // Show a message to the user if no date or time is selected
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: kPrimaryColor,
                                  content: Text('Please select both date and time before proceeding.'),
                                ),
                              );
                            } else {
                              setState(() {
                                _isLoading = true; // Show loading indicator
                              });

                              // Simulate a delay for loading
                              await Future.delayed(Duration(seconds: 1));

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomerInfoForm(
                                    caregiverName: widget.caregiver.name,
                                    label: label,
                                    dutyDates: selectedDates,
                                    days: selectedDates.length,
                                    selectedTime: selectedTime!,
                                    caregiverPhotoUrl: widget.caregiver.caregiverphotoUrl, // Pass the caregiver's photo URL
                                  ),
                                ),
                              ).then((_) {
                                setState(() {
                                  _isLoading = false; // Hide loading indicator after navigation
                                });
                              });

                              animator();
                            }
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
                                TextWidget("Proceed to Submit", 18, Colors.white, FontWeight.w700),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward_ios_outlined, color: Colors.white, size: 18),
                                Icon(Icons.arrow_forward_ios_outlined, color: Colors.white.withOpacity(.5), size: 18),
                                Icon(Icons.arrow_forward_ios_outlined, color: Colors.white.withOpacity(.2), size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Center(
                child: CupertinoActivityIndicator(
                  radius: 20.0,
                  color: CupertinoColors.activeBlue,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void changer(int index) {
    setState(() {
      for (int i = 0; i < time.length; i++) {
        time[i] = i == index;
      }
    });
  }
}
