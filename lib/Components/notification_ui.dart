import 'package:flutter/material.dart';
import '../screens/pop_up.dart';

class NotificationUI extends StatelessWidget {
  const NotificationUI({
    Key? key,
    this.address,
    this.name,
    this.mobileNo,
    this.distance,
    this.request,
  }) : super(key: key);

  final address;
  final name;
  final mobileNo;
  final distance;
  final request;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet<void>(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              context: context,
              builder: (BuildContext context) {
                return PopUp(
                  name: name,
                  address: address,
                  mobileNo: mobileNo,
                );
              });
        },
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          color: request == false
              ? const Color.fromRGBO(143, 148, 251, 1)
              : Colors.green,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                Text(
                  "Name: " + name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "Mobile No: " + mobileNo,
                ),
                Text(
                  "Distance: " + distance.round().toString() + "KM",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
