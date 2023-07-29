import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodly/utilities.dart';
import '../../../services/UID_tracker.dart';
import '../../home_flow/screens/main_home_nav.dart';
import '../custom_widgets/custom_loginPhone_textField.dart';
import 'OTP_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  late TextEditingController _phoneNumberController;
  bool isLoading = false;

  Future<void> verifyPhoneNumber() async {
    if (isLoading) return;
    RegExp phoneRegExp = RegExp(r"^\d{10}$");
    if (!phoneRegExp.hasMatch(_phoneNumberController.text)) {
      Utilities.displaySnackBar("Invalid Phone Number!", context,
          durationInSeconds: 2);
      return;
    }
    setState(() {
      isLoading = true;
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91" + _phoneNumberController.text,
      verificationCompleted: autoVerifiedCallback,
      verificationFailed: verificationFailedCallback,
      codeSent: codeSentCallback,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void codeSentCallback(String verificationID, int? resendToken) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationID: verificationID,
          phoneNumber: "+91" + _phoneNumberController.text,
        ),
      ),
    );
  }

  void verificationFailedCallback(FirebaseAuthException e) {
    Utilities.displaySnackBar(
        "Verification failed! (Err: (${e.code})${e.message}", context,
        durationInSeconds: 8);

    setState(() {
      isLoading = false;
    });
  }

  void autoVerifiedCallback(PhoneAuthCredential phoneAuthCredential) async {
    Utilities.displaySnackBar("Phone auto verified", context,
        color: Colors.green);
    //empty show dialog to prevent users from doing anything else
    //when signing in after auto-verification
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => Container(),
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      //popping everything and pushing on homeScreen
      UIDTracker.userUID = FirebaseAuth.instance.currentUser!.uid;

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MainHomeNav(
              phoneNumber: "+91" + _phoneNumberController.text,
            ),
          ),
          (Route<dynamic> route) => false);
    } catch (e) {}
  }

  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Continue with Phone",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(40),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/loginPhoneImg.jpg",
                  height: MediaQuery.of(context).size.height / 3.626,
                ),
                Text(
                  "You'll receive a 6 digit code\nto verify next.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  offset: Offset(0, 0),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter your phone number",
                      style: TextStyle(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          "+91 ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: CustomLoginPhoneTextField(
                              phoneNumberController: _phoneNumberController),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: verifyPhoneNumber,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFDC3D),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    //todo: check if animation is working
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      child: isLoading
                          ? SpinKitWave(
                              color: Colors.white,
                              size: 22.0,
                            )
                          : Icon(
                              Icons.check,
                              color: Colors.black,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
