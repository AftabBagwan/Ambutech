import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class PopUp extends StatefulWidget {
  static const String id = 'popup';
  final name;
  final address;
  final mobileNo;
  final uid;

  PopUp({
    Key? key,
    @required this.name,
    this.address,
    this.mobileNo,
    this.uid,
  }) : super(key: key);

  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  final _firestore = FirebaseFirestore.instance;
  var finalAddress = "";
  String pname = "";
  String pmobile = "";
  var plat;
  var plong;
  @override
  Widget build(BuildContext context) {
    Position position;
    return SingleChildScrollView(
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Text(
              widget.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontStyle: FontStyle.normal,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: Text(widget.mobileNo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
                onChanged: (value) {
                  pname = value;
                },
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    hintText: 'Enter patients name',
                    labelText: 'Patients name',
                    labelStyle: const TextStyle(
                      color: Color.fromRGBO(143, 148, 251, 1),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ))),
            const SizedBox(
              height: 10,
            ),
            TextField(
                onChanged: (value) {
                  pmobile = value;
                },
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    hintText: 'Enter mobile number',
                    labelText: 'Mobile',
                    labelStyle: const TextStyle(
                      color: Color.fromRGBO(143, 148, 251, 1),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ))
                // signInFormFieldDecoration(
                //     emailText, Icons.email, 'Enter your email'),
                ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 50,
                  width: 280,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Text(
                        finalAddress,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);
                      plat = position.latitude;
                      plong = position.longitude;
                      final coordinates =
                          Coordinates(position.latitude, position.longitude);
                      var addresses = await Geocoder.local
                          .findAddressesFromCoordinates(coordinates);
                      var first = addresses.first;
                      setState(() {
                        finalAddress =
                            "${first.featureName} : ${first.addressLine}";
                      });
                    },
                    icon: const Icon(
                      Icons.location_searching,
                      size: 30,
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 300,
                height: 50,
                color: const Color.fromRGBO(143, 148, 251, 1),
                child: MaterialButton(
                  onPressed: () {
                    String id;
                    if (widget.name == "EMS Ambulance") {
                      id = "ems_ambulance";
                    } else if (widget.name == "Gurukrupa Ambulance") {
                      id = "gurukrupa_ambulance";
                    } else {
                      id = "janseva_ambulance";
                    }
                    _firestore.collection('booking').add({
                      'mobile': pmobile,
                      'name': pname,
                      'address': finalAddress,
                      'time': DateTime.now(),
                      'ambulance': widget.name,
                      'lat': plat,
                      'long': plong,
                      'id': id,
                    });
                    Navigator.pop(context);

                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Successfully Booked'),
                        content: const Text(
                            'The Ambulance will reach on your location soon.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    'Book',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            // TextField(
            //     keyboardType: TextInputType.emailAddress,
            //     textAlign: TextAlign.center,
            //     decoration: InputDecoration(
            //         prefixIcon: Icon(Icons.person),
            //         suffixIcon: IconButton(
            //             onPressed: () async {
            //               position = await Geolocator.getCurrentPosition(
            //                   desiredAccuracy: LocationAccuracy.high);
            //               final coordinates = new Coordinates(
            //                   position.latitude, position.longitude);
            //               var addresses = await Geocoder.local
            //                   .findAddressesFromCoordinates(coordinates);
            //               var first = addresses.first;
            //               setState(() {
            //                 finalAddress =
            //                     "${first.featureName} : ${first.addressLine}";
            //                 print(finalAddress);
            //               });
            //             },
            //             icon: Icon(Icons.location_searching)),
            //         // Icon(Icons.location_searching),
            //         floatingLabelBehavior: FloatingLabelBehavior.always,
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(15.0)),
            //         hintText: 'Click on position icon.',
            //         labelText: 'Current Location',
            //         labelStyle: TextStyle(
            //           color: Colors.red,
            //           fontSize: 15.0,
            //           fontWeight: FontWeight.w500,
            //         ))
            //     // signInFormFieldDecoration(
            //     //     emailText, Icons.email, 'Enter your email'),
            //     ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     MaterialButton(
            //       child: Row(
            //         children: [
            //           Icon(
            //             Icons.check,
            //           ),
            //           Text(
            //             'Accept',
            //           ),
            //         ],
            //       ),
            //       color: Colors.green,
            //       onPressed: () {
            //         //   _firestore
            //         //       .collection('request')
            //         //       .doc(widget.uid)
            //         //       .update({'AcceptedBy': widget.userEmail});
            //         //   Navigator.pop(context);
            //       },
            //       //
            //     ),
            //     // MaterialButton(
            //     //   child: Row(
            //     //     children: [
            //     //       Icon(
            //     //         Icons.close,
            //     //       ),
            //     //       Text(
            //     //         'Reject',
            //     //       ),
            //     //     ],
            //     //   ),
            //     //   color: Colors.red,
            //     //   onPressed: () {
            //     //     setState(() {
            //     //       Navigator.pop(context);
            //     //     });
            //     //   },
            //     // ),
            //     // MaterialButton(
            //     //     color: Colors.blue,
            //     //     child: Row(
            //     //       children: [
            //     //         Icon(
            //     //           Icons.share,
            //     //         ),
            //     //         Text("Share"),
            //     //       ],
            //     //     ),
            //     //     onPressed: () {
            //     //       share = 'Name : ' +
            //     //           widget.name +
            //     //           ',' +
            //     //           'Address : ' +
            //     //           widget.address +
            //     //           ', Mobile : ' +
            //     //           widget.mobileNo;
            //     //
            //     //       final RenderBox box = context.findRenderObject();
            //     //
            //     //       Share.share(share,
            //     //           subject: widget.name,
            //     //           sharePositionOrigin:
            //     //               box.localToGlobal(Offset.zero) & box.size);
            //     //     }),
            //   ],
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // MaterialButton(
            //   padding: EdgeInsets.all(15),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         'Navigate',
            //         style: TextStyle(
            //           fontSize: 20,
            //         ),
            //       ),
            //       Icon(Icons.location_history)
            //     ],
            //   ),
            //   color: Colors.orange,
            //   onPressed: () {
            //     // MapsLauncher.launchCoordinates(lat, long);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
