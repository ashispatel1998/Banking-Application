import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountInformationScreen extends StatefulWidget {
  @override
  _AccountInformationScreenState createState() => _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int accId;
  String name;
  String email;
  String mobileno;
  String dob;
  String lastLogin;

  @override
  void initState() {
    super.initState();
    getInitialization();
  }

  getInitialization() async{
    SharedPreferences prefs = await _prefs;
    setState(() {
      accId= prefs.getInt("accId");
      name=prefs.getString("name");
      email=prefs.getString("email");
      dob=prefs.getString("dob");
      mobileno=prefs.get("mobileno");
      lastLogin=prefs.getString("lastLogin");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Information"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
           child: ListView(
           children: <Widget>[
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Card(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: ListTile(
                     leading: Icon(Icons.account_circle,size: 50,color: Colors.lightGreen,),
                     title: Text("Account Number",
                     style: TextStyle(
                       fontSize: 20,
                       fontWeight: FontWeight.bold
                     ),
                     ),
                     subtitle: Text("Account Number : ${accId}",
                     style: TextStyle(
                       fontWeight: FontWeight.w400,
                       fontSize: 15
                     ),
                     ),
                   ),
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Card(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: ListTile(
                     leading: Icon(Icons.person,size: 50,color: Colors.lightGreen,),
                     title: Text("Holder Name",
                       style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold
                       ),
                     ),
                     subtitle: Text("${name}",
                       style: TextStyle(
                           fontWeight: FontWeight.w400,
                           fontSize: 15
                       ),
                     ),
                   ),
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Card(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: ListTile(
                     leading: Icon(Icons.email,size: 50,color: Colors.redAccent,),
                     title: Text("Email Address",
                       style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold
                       ),
                     ),
                     subtitle: Text("${email}",
                       style: TextStyle(
                           fontWeight: FontWeight.w400,
                           fontSize: 15
                       ),
                     ),
                   ),
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Card(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: ListTile(
                     leading: Icon(Icons.calendar_today,size: 50,color: Colors.blueAccent,),
                     title: Text("Date of Birth",
                       style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold
                       ),
                     ),
                     subtitle: Text("${dob}",
                       style: TextStyle(
                           fontWeight: FontWeight.w400,
                           fontSize: 15
                       ),
                     ),
                   ),
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Card(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: ListTile(
                     leading: Icon(Icons.phone,size: 50,color: Colors.blueAccent,),
                     title: Text("Mobile Number",
                       style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold
                       ),
                     ),
                     subtitle: Text("${mobileno}",
                       style: TextStyle(
                           fontWeight: FontWeight.w400,
                           fontSize: 15
                       ),
                     ),
                   ),
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Card(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: ListTile(
                     leading: Icon(Icons.exit_to_app,size: 50,color: Colors.blueAccent,),
                     title: Text("Last Login",
                       style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold
                       ),
                     ),
                     subtitle: Text("${lastLogin}",
                       style: TextStyle(
                           fontWeight: FontWeight.w400,
                           fontSize: 15
                       ),
                     ),
                   ),
                 ),
               ),
             ),
           ],
           ),
      ),
    );
  }
}


