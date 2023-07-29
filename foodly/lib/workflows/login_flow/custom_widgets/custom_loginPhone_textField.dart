import 'package:flutter/material.dart';

class CustomLoginPhoneTextField extends StatelessWidget {
  const CustomLoginPhoneTextField({
    super.key,
    required TextEditingController phoneNumberController,
  }) : _phoneNumberController = phoneNumberController;

  final TextEditingController _phoneNumberController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.done,
      controller: _phoneNumberController,
      keyboardType: TextInputType.number,
      autofocus: true,
      autofillHints: [AutofillHints.telephoneNumber],
      maxLength: 10,
      cursorColor: Colors.black,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        counterText: "",
        hintText: "00000 00000",
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
      ),
    );
  }
}
