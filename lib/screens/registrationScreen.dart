import 'package:banking_application/main.dart';
import 'package:banking_application/models/bankDetails.dart';
import 'package:banking_application/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:banking_application/screens/loginScreen.dart';
import 'package:banking_application/screens/homeScreen.dart';
import 'package:banking_application/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';


class RegistrationScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<RegistrationScreen> {

  String _name;
  String _email;
  String _mobile;
  String _password;
  String _dob;
  String _ageLimit="";
  int eligibility_status=0;

  // Form Key
  final GlobalKey<FormState> formkey=GlobalKey<FormState>();

  DateTime _currentDate=DateTime.now();
  DateTime _dateTime;

  User _user=User();
  List<User> _users=[];
  BankDetail _bankDetail=BankDetail();

  DatabaseHelper _dbHelper;

  TextEditingController dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper=DatabaseHelper.instance;
    });
  }

  // Validation Function
  void validate() async{
    if(formkey.currentState.validate()){
      formkey.currentState.save();

      _user.name=_name;
      _user.email=_email;
      _user.mobileNo=_mobile;
      _user.password=_password;
      _user.dob=_dob;
      _user.ageLimitType=_ageLimit;
      _user.lastLogin=_currentDate.toString();
      int id=await _dbHelper.insertUser(_user);

      if(id!=null){
        print(id);
        // Add details to bank table
        _bankDetail.accId=id;
        _bankDetail.name=_name;
        _bankDetail.email=_email;
        _bankDetail.mobile=_mobile;
        _bankDetail.dob=_dob;
        _bankDetail.accountBalance=1000;   // Intial Balance 1000
        int id2=await _dbHelper.insertBankDetails(_bankDetail);
        if(id2!=null){
          print(id2);
          Fluttertoast.showToast(
              msg: 'Account Created with AccId: ${id2}',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white
          );
        }else{
          Fluttertoast.showToast(
              msg: 'Some Error occured!!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white
          );
        }
      }
      else{
        Fluttertoast.showToast(
            msg: 'Account not Created!!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white
        );
      }

      formkey.currentState.reset();
      Navigator.pop(context,MaterialPageRoute(builder: (context)=>MyHomePage()));
    }
    else{
      print("Not Validated");
    }
  }

  // Name Validator

  String validateName(String value){
    if(value.isEmpty){
      return "Required";
    }
    else{
      return null;
    }
  }

  // Email Validator
  String validateEmail(String value){
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    if(value.isEmpty){
      return "Required";
    }
    else if(emailValid==false){
      return "Invalid Email ID";
    }
    else{
      return null;
    }

  }

  // Password Validator
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

  // Number Validator
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

  // Age Limit
  String ageLimitValidator(DateTime currentDate,DateTime dob){
    int res=currentDate.year-dob.year;
    print(res);
    if(res>=7 && res<=12){
      setState(() {
        eligibility_status=1;
      });
      return "7-12";
    }
    else if(res>=13 && res<=18){
      setState(() {
        eligibility_status=1;
      });
      return "13-18";
    }
    else if(res>18){
      setState(() {
        eligibility_status=1;
      });
      return "18+";
    }
    else {
      setState(() {
        eligibility_status=0;
      });
      return "Age must greater then 6";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Account'),
          backgroundColor: Colors.redAccent,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: formkey,
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: validateName,
                      onSaved: (value)=>_name=value.trim(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: validateEmail,
                      onSaved: (value)=>_email=value.trim(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mobile',
                      ),
                        validator: validateMobile,
                        keyboardType: TextInputType.number,
                        onSaved: (value)=>_mobile=value.trim()
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
                        onSaved: (value)=>_password=value
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: RaisedButton(
                      child: Text(_dateTime == null ? 'Date Of Birth':_dob),
                      color: Colors.white,
                      elevation: 0,
                      textColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.grey)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 23),
                      onPressed: () {
                        showDatePicker(
                            context: context,
                            initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2021)
                        ).then((date) {
                          setState(() {
                            _dateTime = date;
                            _dob=_dateTime.toString().substring(0,11);
                            _ageLimit=ageLimitValidator(_currentDate, _dateTime);
                          });
                        });
                      },
                    ),
                  ),
                  SizedBox(height:8,),
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: RaisedButton(
                      child: Text(_ageLimit == "" ? 'Age Limit':_ageLimit),
                      color: Colors.white,
                      elevation: 0,
                      onPressed: (){},
                      textColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.grey)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 23),
                    ),
                  ),
                  SizedBox(height: 10,),
                  eligibility_status == 0 ? Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.greenAccent,
                        child: Text('Create'),
                      )):Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.greenAccent,
                        child: Text('Create'),
                        onPressed: () {
                          validate();
                        },
                      )),
                  SizedBox(height: 10,),
                ],
              ),
            )));
  }
}