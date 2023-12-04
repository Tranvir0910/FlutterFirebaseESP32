import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/maincard.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase/element/responsive.dart';


class DataElement extends StatelessWidget {
  final String dataElement;
  final String iconPath;
  final bool powerOn;
  final RxString data;
  
  const DataElement({
    super.key,
    required this.dataElement,
    required this.iconPath,
    required this.powerOn,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {

    // var humidity = "0".obs;
    // var light = "0".obs;
    // List myData = [
    //   [temp],
    //   [humidity],
    //   [light]
    // ];

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Color.fromRGBO(209, 240, 189, 1.000),
            width: 4,
          ),
          borderRadius: BorderRadius.circular(10), //<-- SEE HERE
        ),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: Responsive.isSmallScreen(context) ? 50 : 300,
                  height: Responsive.isSmallScreen(context) ? 50 : 300,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Image.asset(
                    iconPath,
                    height: 25,
                    width: 25,
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        children: [
                          MainCard(
                            data: data, 
                            title: dataElement
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

