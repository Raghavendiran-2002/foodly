import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/UID_tracker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          UIDTracker.userUID = null;
          UIDTracker.userDocID = null;
          UIDTracker.vendorID = null;
          FirebaseAuth.instance.signOut();
          Navigator.pushNamedAndRemoveUntil(
              context, "/", (Route<dynamic> route) => false);
        },
        child: Text("Sign Out"),
      ),
    );
  }
}
