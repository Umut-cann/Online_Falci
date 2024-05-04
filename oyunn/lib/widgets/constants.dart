
import 'package:flutter/material.dart';



var  TextInputdecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(color: Colors.black, width: 2),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
  ),
 
 
);




void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: ((context) => page)));
}

void nextScreenReplace(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: ((context) => page)));
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "ok",
        onPressed: (() {}),
        textColor: Colors.white,
      )));
}
