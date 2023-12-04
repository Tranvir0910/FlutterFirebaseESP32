import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainCard extends StatelessWidget {
  const MainCard({
    super.key,
    required this.data,
    required this.title,
  });

  final RxString data;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Obx(
          () => SizedBox(
            // width: Get.width / 3,
            // height: Get.height / 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title.toString(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 30,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    //color: Colors.blue,
                    //borderRadius: BorderRadius.all(Radius.circular(100)),
                    border: Border(
                      // bottom: BorderSide(width: 2.0, color: Colors.blue),
                      // top: BorderSide(width: 3.0, color: Colors.black),
                      // left: BorderSide(width: 3.0, color: Colors.black),
                      // right: BorderSide(width: 3.0, color: Colors.black),
                    ),
                  ),
                  child: Text(
                    "$data",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 30,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}