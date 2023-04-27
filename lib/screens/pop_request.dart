import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class PopUpRequest extends StatefulWidget {
  static const String id = 'popup';
  final name;
  final address;
  final mobileNo;
  final userEmail;
  final requestLatitude;
  final requestLongitude;
  final uid;

  PopUpRequest({
    Key? key,
    @required this.name,
    this.address,
    this.mobileNo,
    this.uid,
    this.userEmail,
    this.requestLatitude,
    this.requestLongitude,
  }) : super(key: key);

  @override
  _PopUpRequestState createState() => _PopUpRequestState();
}

class _PopUpRequestState extends State<PopUpRequest> {
  final _firestore = FirebaseFirestore.instance;
  var finalAddress = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 400,
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Text(
              widget.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontStyle: FontStyle.normal,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(widget.address,
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                )),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: Text(widget.mobileNo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                      ),
                      Text(
                        'Accept',
                      ),
                    ],
                  ),
                  color: Colors.green,
                  onPressed: () async {
                    var id = await _firestore
                        .collection('booking')
                        .doc(widget.uid)
                        .get();

                    Map<String, dynamic>? data = id.data();
                    var value =
                        data?['id']; // <-- The value you want to retrieve.

                    print(value);
                    _firestore
                        .collection('ambulance')
                        .doc(value)
                        .update({'request': true});
                    Navigator.pop(context);
                  },

                  //
                ),
                MaterialButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.close,
                      ),
                      Text(
                        'Reject',
                      ),
                    ],
                  ),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Navigate',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Icon(Icons.location_history)
                ],
              ),
              color: Colors.orange,
              onPressed: () {
                MapsLauncher.launchCoordinates(
                    widget.requestLatitude, widget.requestLongitude);
              },
            ),
          ],
        ),
      ),
    );
  }
}
