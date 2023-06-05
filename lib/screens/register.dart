import 'package:blogapp/constant.dart';
import 'package:blogapp/models/api_response.dart';
import 'package:blogapp/models/user.dart';
import 'package:blogapp/screens/home.dart';
import 'package:blogapp/screens/login.dart';
import 'package:blogapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  bool loading = false;

  void _registerUser() async {
    ApiResponse response = await register(nameController.text, emailController.text,passwordController.text);
    if(response.error == null){
      _saveAndRedirectToHome(response.data as User);
    }
    else{
      setState(() {
        loading = !loading;
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
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Form(child: ListView(
        padding: EdgeInsets.all(32),
        children: [
          TextFormField(
            controller: nameController,
            validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
            decoration: KInputDecoration('Name'),
          ),
          SizedBox(height: 10,),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            validator: (val) => val!.isEmpty ? 'Invalid Email Adress' : null,
            decoration: KInputDecoration('Email'),
          ),
          SizedBox(height: 10,),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            validator: (val) => val!.length < 6 ? 'Required at least 6 chars' : null,
            decoration: KInputDecoration('Password'),
          ),
          SizedBox(height: 10,),
          TextFormField(
            controller: passwordConfirmController,
            obscureText: true,
            validator: (val) => val != passwordController.text ? 'Confirm password does not match' : null,
            decoration: KInputDecoration('Confirm Password'),
          ),
          SizedBox(height: 10,),
          loading? Center(child: CircularProgressIndicator(),)
              :
          KTextButton('Register', (){
            if(formkey.currentState!.validate()){
              setState(() {
                loading = !loading;
                _registerUser();
              });
            }
          }),
          SizedBox(height: 10,),
          KLoginRegisterHint('Already have an account? ', 'Login',(){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false);
          }),
        ],
      )),
    );
  }
}
