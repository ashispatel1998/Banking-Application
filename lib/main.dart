import 'package:banking_application/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'screens/loginScreen.dart';
import 'screens/registrationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayNet Bank',
      theme: ThemeData(
        primaryColor: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'PayNet Bank'),
      routes: <String, WidgetBuilder> {
        '/Home': (BuildContext context) => new HomeScreen(),
        '/LoginScreen': (BuildContext context) => new LoginScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String mobileno;

  @override
  void initState(){
    super.initState();
    getUser();
  }

  getUser() async{
    SharedPreferences prefs = await _prefs;
    setState(() {
      mobileno=prefs.getString("mobileno");
      signIn(mobileno);
    });
  }

  void signIn(String mobileno){
    if(mobileno!=null){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen()
        ),
        ModalRoute.withName("/Home")
    );
    }else{

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        elevation: 0,
      ),
      body:  Container(
        color: Colors.redAccent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: 50,
                    width: 400,

                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.greenAccent,
                      child: Text('Login'),
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
                      },
                    )),
                SizedBox(height: 10,),
                Container(
                    height: 50,
                    width: 400,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('SignUp'),
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>RegistrationScreen()));
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
