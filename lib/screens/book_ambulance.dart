import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../Components/notification_ui.dart';

class BookAmbulance extends StatefulWidget {
  const BookAmbulance({Key? key}) : super(key: key);

  @override
  State<BookAmbulance> createState() => _BookAmbulanceState();
}

class _BookAmbulanceState extends State<BookAmbulance> {
  var userLat;
  var userLong;
  final _firestore = FirebaseFirestore.instance;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userCoordinates();
  }

  void userCoordinates() async {
    Position position1 = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    userLat = position1.latitude;
    userLong = position1.longitude;
    if (mounted) setState(() {});
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(222, 224, 252, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(143, 148, 251, 1),
        title: Text("Book Ambulance"),
      ),
      body: SafeArea(
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  StreamBuilder(
                      stream: _firestore.collection('ambulance').snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Expanded(
                          child: ListView(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: snapshot.data!.docs.map((ambulance) {
                              return NotificationUI(
                                // address: ambulance['address'],
                                request: ambulance['request'],
                                name: ambulance['name'],
                                mobileNo: ambulance['mobile'],
                                distance: Geolocator.distanceBetween(
                                        ambulance['lat'],
                                        ambulance['long'],
                                        userLat,
                                        userLong) /
                                    1000,
                              );
                            }).toList(),
                          ),
                        );
                      }),
                ],
              ),
      ),
    );
  }
}
