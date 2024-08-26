import 'dart:async';

import 'package:flutter/material.dart';
import '../res/lists.dart';
import '../widgets/text_widget.dart';
import 'Chat.dart';
import 'Home.dart';

class SeeAll extends StatefulWidget {
  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  var opacity = 0.0;
  bool position = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      animator();
    });
  }

  animator() {
    if (opacity == 1) {
      opacity = 0;
      position = false;
    } else {
      opacity = 1;
      position = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 70),
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              top: position ? 1 : 50,
              left: 20,
              right: 20,
              child: upperRow(),
            ),
            AnimatedPositioned(
                top: position ? 60 : 120,
                right: 20,
                left: 20,
                duration: Duration(milliseconds: 300),
                child: findDoctor()),
            AnimatedPositioned(
                top: position ? 390 : 450,
                right: 20,
                left: 20,
                duration: Duration(milliseconds: 400),
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 400),
                  child: Container(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          "Nearby Caregivers",
                          18,
                          Colors.black,
                          FontWeight.bold,
                          letterSpace: 2,
                        ),
                        TextWidget(
                          "See all",
                          14,
                          Colors.blue.shade900,
                          FontWeight.bold,
                          letterSpace: 1,
                        ),
                      ],
                    ),
                  ),
                )),
            AnimatedPositioned(
                top: position ? 430 : 500,
                left: 20,
                right: 20,
                duration: Duration(milliseconds: 500),
                child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: opacity,
                    child: SizedBox(
                      height: 350,
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 0, bottom: 20),
                        itemCount: 7,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () async {
                            animator();
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            // await Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => Chat(
                            //           image: images[index],
                            //           name: names[index],
                            //           position: spacilality[index]),
                            //     ));
                            animator();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: images[index],
                                      backgroundColor: Colors.blue,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          names[index],
                                          18,
                                          Colors.black,
                                          FontWeight.bold,
                                          letterSpace: 0,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextWidget(
                                          spacilality[index],
                                          14,
                                          Colors.black,
                                          FontWeight.bold,
                                          letterSpace: 0,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.orangeAccent,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.orangeAccent,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.orangeAccent,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.orangeAccent,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.orangeAccent,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.message_outlined),
                                      color: Colors.blue,
                                      onPressed: () async {
                                        animator();
                                        await Future.delayed(
                                            const Duration(milliseconds: 500));
                                        Navigator.pop(
                                            context); // This line navigates back to the previous screen
                                        animator();
                                      },
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }

  Widget findDoctor() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: opacity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade700,
                    Colors.blue.shade900,
                    Colors.blue.shade900,
                  ])),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  top: 25,
                  left: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Center(
                          child: Image(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/images/p1.png'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TextWidget(
                            "Find Caregivers !",
                            18,
                            Colors.white,
                            FontWeight.bold,
                            letterSpace: 0,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextWidget(
                                "Use this feature to find a caregiver\nclosest to you",
                                15,
                                Colors.white,
                                FontWeight.normal,
                                letterSpace: 0,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  )),
              Positioned(
                  top: 115,
                  left: 20,
                  right: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/images/map.png'))),
                    ),
                  )),
              const Positioned(
                  top: 15,
                  right: 15,
                  child: Icon(
                    Icons.close_outlined,
                    color: Colors.white,
                    size: 15,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget upperRow() {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              animator();
              Timer(const Duration(milliseconds: 600), () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              });
            },
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
              size: 25,
            ),
          ),
          TextWidget("Our Specialists", 20, Colors.black, FontWeight.bold),
          const Icon(
            Icons.search,
            color: Colors.black,
            size: 25,
          )
        ],
      ),
    );
  }
}
