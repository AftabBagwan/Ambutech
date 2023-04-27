import 'package:flutter/material.dart';
import '../screens/pop_request.dart';

class RequestUI extends StatelessWidget {
  RequestUI({
    this.address,
    this.name,
    this.mobileNo,
    this.distance,
    this.uid,
    this.requestLatitude,
    this.requestLongitude,
  });

  final address;
  final name;
  final mobileNo;
  final distance;
  final uid;
  final requestLatitude;
  final requestLongitude;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet<void>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              context: context,
              builder: (BuildContext context) {
                return PopUpRequest(
                  name: name,
                  address: address,
                  mobileNo: mobileNo,
                  uid: uid,
                  requestLatitude: requestLatitude,
                  requestLongitude: requestLongitude,
                );
              });
        },
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(143, 148, 251, 1),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                Text(
                  "Patient's name: " + name,
                  style: TextStyle(
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
