import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

import '../res/json.dart';
import '../widgets/popular_caregiver.dart';

class Search extends StatefulWidget {
  const Search({ Key? key }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var opacity = 0.0;
  bool position=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: badges.Badge(
              position: BadgePosition.topEnd(top: 7, end: -4),
              badgeContent: Text('1', style: TextStyle(color: Colors.white),),
              child: Icon(Icons.notifications_sharp),
            ),
          )
        ],
      ),
      body: getBody(),
    );
  }

  getBody(){
    return
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(child: Text("Hi,", style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),),),
                SizedBox(height: 5,),
                Container(child: Text("Let's Find Your Caregiver", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),)),
                SizedBox(height: 15,),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search_sharp,
                          size: 30,
                          color: Colors.black.withOpacity(.5),
                        ),
                        hintText: "   Search"),
                  ),
                ),

                SizedBox(height: 10,),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  height: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage("https://media.istockphoto.com/vectors/electronic-health-record-concept-vector-id1299616187?k=20&m=1299616187&s=612x612&w=0&h=gmUf6TXc8w6NynKB_4p2TzL5PVIztg9UK6TOoY5ckMM="),
                        fit: BoxFit.cover,)
                  ),
                ),
                SizedBox(height: 25,),
                Container(child: Text("Popular Doctors", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)),
                SizedBox(height: 10),
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 5),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      PopularCaregiver(caregiver: doctors[0],),
                      PopularCaregiver(caregiver: doctors[1],),
                      PopularCaregiver(caregiver: doctors[2],),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
              ]
          ),
        ),
      );
  }
}
