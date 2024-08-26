
import 'package:flutter/material.dart';

import 'avatarimage.dart';


class PopularCaregiver extends StatelessWidget {
  PopularCaregiver({ Key? key, required this.caregiver}) : super(key: key);
  var caregiver;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
        margin: EdgeInsets.only(right: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          color: Colors.white,
          height: 100,
          width: 240,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AvatarImage(caregiver["image"],),
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(caregiver["name"], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                  SizedBox(height: 3,),
                  Text(caregiver["skill"], style: TextStyle(fontSize: 12, color: Colors.black),),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 14,),
                      SizedBox(width: 10),
                      Text("${caregiver["review"]} Review", style: TextStyle(fontSize: 12),)
                    ],
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}