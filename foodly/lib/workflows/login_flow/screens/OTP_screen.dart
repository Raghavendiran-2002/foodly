import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodly/services/UID_tracker.dart';
import 'package:foodly/workflows/home_flow/screens/main_home_nav.dart';
import 'package:foodly/workflows/login_flow/services/phoneNumber_helper.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utilities.dart';

class OTPScreen extends StatefulWidget {
  final String verificationID;
  final String phoneNumber;
  OTPScreen({required this.verificationID, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late String code;
  bool validated = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Text(
                  "Enter your\nverification code",
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xFF151D56),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "We sent a verification code\nto ${() {
                    return PhoneNumberHelper().formatPhoneNumberWithCountryCode(
                        widget.phoneNumber, 2);
                  }()}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Pinput(
                length: 6,
                defaultPinTheme: PinTheme(
                  width: 100,
                  height: 65,
                  textStyle: TextStyle(
                    fontSize: 25,
                    color: Color(0xFF151D56),
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? pin) {
                  RegExp regex = RegExp(r'^\d{6}$');

                  if (!regex.hasMatch(pin!)) {
                    return "Invalid code!";
                  }
                  validated = true;
                  code = pin;
                  return null;
                },
                onChanged: (String pin) => validated = false,
                showCursor: true,
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
                  width: 170,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF151D56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (validated) {
                              setState(() {
                                isLoading = true;
                              });
                              PhoneAuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: widget.verificationID,
                                      smsCode: code);
                              try {
                                //todo: handle login exceptions here, switch case
                                await FirebaseAuth.instance
                                    .signInWithCredential(credential);
                                //todo: check if error in signing in, will it still proceed?
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                    "phone", widget.phoneNumber);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => MainHomeNav(
                                        phoneNumber: widget.phoneNumber,
                                      ),
                                    ),
                                    (Route<dynamic> route) => false);
                              } catch (e) {
                                Utilities.displaySnackBar(
                                    "Invalid Code!  😓", context);
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                    child: isLoading
                        ? SpinKitWave(
                            color: Colors.white,
                            size: 25.0,
                          )
                        //todo: make it bigger
                        : Text(
                            "Verify",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "Change phone number",
                    style: TextStyle(
                      color: Color(0xFF34D0E9),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
