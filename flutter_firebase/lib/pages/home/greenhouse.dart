import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/element/data_element.dart';
import 'package:flutter_firebase/model/device_model.dart';
import 'package:flutter_firebase/pages/home/devices.dart';
import 'package:flutter_firebase/utils/string_to_color.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/element/responsive.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';


class Greenhouse extends StatefulWidget {
  const Greenhouse({super.key});
  @override
  State<Greenhouse> createState() => _GreenhouseState();
}

var temperature = "0".obs;
var humidity = "0".obs;
var light = "0".obs;
var moisture = "0".obs;

class _GreenhouseState extends State<Greenhouse> {

  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  
  var ref = FirebaseDatabase.instance.ref().child("FirebaseIOT");
  getData() async {
    ref.onValue.listen(
      (event) {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        Object? data = snapshot.value;
        Map<dynamic, dynamic> map = data as Map<dynamic, dynamic>;
        temperature.value = map["temperature"].toString();
        humidity.value = map["humidity"].toString();
        moisture.value = map["moisture"].toString();
        
        if(map["light sensor"] > 800){
          light.value = "On";
        }else{
          light.value = "Off";
        }
        
      }
    });
  }
  

  List myElement = [
    ["Temperature ( °C )", "assets/icons/nhietdo.png" , true, temperature],
    ["Humidity ( % )", "assets/icons/doam.png", true, humidity],
    ["Lighting", "assets/icons/anhsang.png", true, light],
    ["Moisture ( % )", "assets/icons/doamdat.png", true, moisture],
  ];

  List<DeviceModel> devices = [
    DeviceModel(
        name: 'Lighting',
        isActive: false,
        color: "#fef7e2",
        icon: 'assets/svg/light.svg'),
    DeviceModel(
        name: 'Fan',
        isActive: false,
        color: "#cee7f0",
        icon: 'assets/svg/ac.svg'),
    DeviceModel(
        name: 'Watering',
        isActive: false,
        color: "#9fe3ee",
        icon: 'assets/svg/watering.svg'),
    // DeviceModel(
    //     name: 'Smart Sound',
    //     isActive: false,
    //     color: "#c207db",
    //     icon: 'assets/svg/speaker.svg'),
  ];
  
  @override
  void initState() {
    super.initState();
    getData();
  }

  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    
    // 6.4 1080 x 2400
    // double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    DateTime time = DateTime.now();
    const duration = Duration(seconds:1); //duration is set to one second
    Timer.periodic(duration, (Timer t) => setState((){
      time = DateTime.now();  
    }));

    const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.normal);

    List<Widget> widgetOptions = <Widget>[
      const SizedBox(),
      Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: Colors.white,
          ),
        
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 2,
                    ),
                    itemCount: devices.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Devices(
                        name: devices[index].name,
                        svg: devices[index].icon,
                        color: devices[index].color.toColor(),
                        isActive: devices[index].isActive,
                        onChanged: (val) {
                          setState(() {
                            if(devices[index].name == 'Lighting'){
                                devices[index].isActive = !devices[index].isActive;
                                ref.child("status led").set(devices[index].isActive);
                            }else if(devices[index].name == 'Fan'){
                              devices[index].isActive = !devices[index].isActive;
                              ref.child("status fan").set(devices[index].isActive);
                            }else if(devices[index].name == 'Watering'){
                              devices[index].isActive = !devices[index].isActive;
                              ref.child("status motor").set(devices[index].isActive);
                            }
                          });
                        },
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(),
      // Expanded(
      //   child: Scaffold(
      //     body: Center(
      //       child: ElevatedButton(
      //         onPressed: () { 
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => const LineChart()) 
      //           );}, child: null,
      //       ),
      //     ),
      //   ),
      // ),

      const Text(
        'Likes',
        style: optionStyle,
      ),
    ];
    
    // DateTime time = DateTime.now();
    // const duration = Duration(seconds:1); //duration is set to one second
    // Timer.periodic(duration, (Timer t) => setState((){
    //   time = DateTime.now();  
    // }));
    String dateString = time.toString();
    var dateTime = DateTime.parse(dateString);
    String dateUpdate = DateFormat.jm().format(time).toString();
    var date = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    ref
      .child("FirebaseIOT")
      .child("History")
      .child(date)
      .set({'datetime': dateUpdate}); 

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color.fromRGBO(220, 247, 222, 1.000), 
                Color.fromRGBO(255, 255, 255, 1)  
              ]),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                              fontSize: Responsive.isSmallScreen(context) ? sizeWidth / 25 : sizeWidth / 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          "Smart Greenhouse",
                          style: TextStyle(
                              fontSize: Responsive.isSmallScreen(context) ? sizeWidth / 25 : sizeWidth / 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
              
                  CircleAvatar(
                    minRadius: Responsive.isSmallScreen(context) ? sizeWidth / 20 : sizeWidth / 17,
                    backgroundImage: const AssetImage('assets/icons/ptit.png'),
                  )
              
                ],
              ),

              const SizedBox(
                  height: 5,
              ),

              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "A total of 4 sensor",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal
                                ),
                              ),
                              Text(
                                "Data sensor",
                                style: TextStyle(
                                    height: 1.1,
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          // Icon(
                          //   Icons.more_horiz,
                          //   color: Colors.grey[300],
                          //   size: 30,
                          // ),
                          Column(
                            children: [
                              Text(
                                DateFormat.MMMMEEEEd().format(time),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal
                                ),
                              ),
                              Text(
                                DateFormat.jms().format(time),
                                style: const TextStyle(
                                  height: 1.1,
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              
                            ]
                          ),
                          
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: GridView.builder(
                          itemCount: myElement.length,
                          padding: const EdgeInsets.all(0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 2,
                          ),
                          itemBuilder: (context, index) {
                            return DataElement(
                              dataElement: myElement[index][0],
                              iconPath: myElement[index][1],
                              powerOn: myElement[index][2],
                              data: myElement[index][3],
                            );
                          },
                        ),
                      ),
                    ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                  height: 3,
              ),
              widgetOptions.elementAt(_selectedIndex),
              const SizedBox(
                  height: 10,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.stream,
                  text: 'Devices',
                ),
                // GButton(
                //   icon: LineIcons.search,
                //   text: 'Search',
                // ),
                // GButton(
                //   icon: LineIcons.user,
                //   text: 'Profile',
                // ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}


