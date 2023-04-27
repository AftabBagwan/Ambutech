import 'package:ambulance_tracker/Components/request_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Request extends StatefulWidget {
  const Request({Key? key}) : super(key: key);

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  var userLat;
  var userLong;
  final _firestore = FirebaseFirestore.instance;
  bool loading = true;

  @override
  void initState() {
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
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
      ),
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  StreamBuilder(
                      stream: _firestore.collection('booking').snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: snapshot.data!.docs.map((booking) {
                              return RequestUI(
                                address: booking['address'],
                                name: booking['name'],
                                mobileNo: booking['mobile'],
                                distance: Geolocator.distanceBetween(
                                        booking['lat'],
                                        booking['long'],
                                        userLat,
                                        userLong) /
                                    1000,
                                uid: booking.id,
                                // userEmail: widget.uid,
                                requestLatitude: booking['lat'],
                                requestLongitude: booking['long'],
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
