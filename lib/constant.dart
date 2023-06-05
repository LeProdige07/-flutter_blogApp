// ----Strings-----
import 'package:flutter/material.dart';

const baseURL = 'http://172.20.10.2:8000/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const postsURL = baseURL + '/posts';
const commentsURL = baseURL + '/comments';

// ----Errors-----
const serverError = 'Server error';
const unauthorized = 'unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

// ----- Input decoration

InputDecoration KInputDecoration(String label){
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black))
  );
}

//---- button

TextButton KTextButton(String label, Function onpressed){
  return TextButton(
    child: Text(label, style: TextStyle(color: Colors.white),),
    style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
        padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 10))
    ),
    onPressed: ()=> onpressed(),
  );
}
// --LoginRegisterHint
Row KLoginRegisterHint(String text, String label, Function ontap){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(label, style: TextStyle(color: Colors.blue),),
        onTap: ()=>ontap(),
      )
    ],
  );
}
