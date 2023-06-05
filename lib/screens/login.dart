import 'package:blogapp/constant.dart';
import 'package:blogapp/models/api_response.dart';
import 'package:blogapp/models/user.dart';
import 'package:blogapp/screens/home.dart';
import 'package:blogapp/screens/register.dart';
import 'package:blogapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
     ApiResponse response = await login(textEmail.text, textPassword.text);
     if(response.error == null){
       _saveAndRedirectToHome(response.data as User);
     }
     else{
       setState(() {
         loading = false;
       });
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
     }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Form(child: ListView(
        padding: EdgeInsets.all(32),
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: textEmail,
            validator: (val) => val!.isEmpty ? 'Invalid Email Adress' : null,
            decoration: KInputDecoration('Email'),
          ),
          SizedBox(height: 10,),
          TextFormField(
            controller: textPassword,
            obscureText: true,
            validator: (val) => val!.length < 6 ? 'Required at least 6 chars' : null,
            decoration: KInputDecoration('Password'),
          ),
          SizedBox(height: 10,),
          loading? Center(child: CircularProgressIndicator(),)
          :
          KTextButton('Login', (){
            if(formkey.currentState!.validate()){
              setState(() {
                loading = true;
                _loginUser();
              });
            }
          }),
          SizedBox(height: 10,),
          KLoginRegisterHint('Dont have an account? ', 'Register',(){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Register()), (route) => false);
          }),
        ],
      )),
    );
  }
}
