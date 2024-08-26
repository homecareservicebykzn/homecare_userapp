import 'package:flutter/material.dart';

import '../../main.dart';


class OptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                              image: AssetImage("assets/logo_header.png"),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '''His's & Her's''',
                        style: TextStyle(
                          color: kWhiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.verified,
                        size: 15,
                        color: kWhiteColor,
                      ),
                      const SizedBox(width: 6),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),
                  Text('The way to be a Professional 💙❤💛 ..',
                    style: TextStyle(
                      color: kWhiteColor,
                    ),),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.child_care,
                        color: kWhiteColor,
                        size: 15,
                      ),
                      Text(' Caregiving',
                        style: TextStyle(
                          color: kWhiteColor,
                        ),),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.favorite_outline,
                      color: kWhiteColor),
                  Text('601k',style: TextStyle(
                      color: kWhiteColor
                  ),),
                  const SizedBox(height: 20),
                  Icon(Icons.comment_rounded,
                      color: kWhiteColor),
                  Text('1123',
                    style: TextStyle(
                        color: kWhiteColor
                    ),),
                  const SizedBox(height: 20),
                  Transform(
                    transform: Matrix4.rotationZ(5.8),
                    child: Icon(Icons.send,
                      color: kWhiteColor,),
                  ),
                  const SizedBox(height: 50),
                  Icon(Icons.more_vert,
                      color: kWhiteColor),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
