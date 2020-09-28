import 'package:banking_application/screens/homeScreen.dart';
import 'package:banking_application/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:banking_application/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginScreen> {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  String _mobile,_password;
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

  // Instance of User
  User _user=User();
  DatabaseHelper _dbHelper;
  bool loginStatus;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper=DatabaseHelper.instance;
    });
  }

  void validate() async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
       // TODO Code
      loginStatus=await _dbHelper.getLogin(_mobile, _password);
      print(loginStatus);
      if(loginStatus==true){
        SharedPreferences prefs = await _prefs;
        prefs.setString("mobileno", _mobile);
        print("Mobile no: ${prefs.getString("mobileno")}");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen()
            ),
            ModalRoute.withName("/Home")
        );
      }else{
        Fluttertoast.showToast(
            msg: "Wrong Credentials!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white
        );
      }
      _formKey.currentState.reset();
    }
    else{
      print("Not Validated");
    }
  }

  String validateMobile(String value){
    if(value.isEmpty){
      return "Required";
    }
    else if(value.length<10){
      return "Incorrect Number";
    }
    else{
      return null;
    }
  }
  String validatePassword(String value){
    if(value.isEmpty){
      return "Required";
    }
    else if(value.length<6){
      return "Password length must be of 6 Character";
    }
    else if(value.length>15){
      return "Password length must be less then 15 Character";
    }
    else{
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          backgroundColor: Colors.redAccent,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mobile No',
                      ),
                      validator: validateMobile,
                      keyboardType: TextInputType.number,
                      onSaved: (value)=>_mobile=value,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: validatePassword,
                      onSaved: (value)=>_password=value,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.greenAccent,
                        child: Text('Login'),
                        onPressed: () {
                        validate();
                        },
                      )),
                  SizedBox(height: 10,),
                  FlatButton(
                    onPressed: (){
                      //forgot password screen
                    },
                    textColor: Colors.blue,
                    child: Text('Forgot Password'),
                  ),
                ],
              ),
            )));
  }
}