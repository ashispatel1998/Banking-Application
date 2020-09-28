import 'package:banking_application/main.dart';
import 'package:banking_application/screens/accountInformationScreen.dart';
import 'package:banking_application/screens/moneyTransfer.dart';
import 'package:banking_application/screens/transactionHistoryScreen.dart';
import 'package:banking_application/utils/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  DateTime _currentDate=DateTime.now();

  String mobileno;
  int accountId;
  String name;
  String email;
  String dob;
  int accountBalance;

  List<dynamic> _bankInfo;
  DatabaseHelper _dbHelper;

  String _lastLogin;


  List<IconData> _icons = [
    Icons.account_circle,
    Icons.account_balance,
    Icons.security,
    Icons.history,
    Icons.access_time
  ];

  void initState() {
    super.initState();
    setState(() {
      _dbHelper=DatabaseHelper.instance;
    });
    getInitialization();
  }

  getBankInfo() async{
    _bankInfo= await _dbHelper.getBankInfo(mobileno);
    print(_bankInfo.toList());
    SharedPreferences prefs = await _prefs;
    _lastLogin= await _dbHelper.getLastLoginStatus(mobileno);
    _lastLogin=_lastLogin.substring(0,16);
    setState(() {
      accountId=_bankInfo[0]['accId'];
      name=_bankInfo[0]['name'];
      email=_bankInfo[0]['email'];
      dob=_bankInfo[0]['dob'];
      accountBalance=_bankInfo[0]['accountBalance'];
      prefs.setInt("accId",accountId);
      prefs.setString('name', name);
      prefs.setString('email', email);
      prefs.setString('dob', dob);
      prefs.setInt('accountBalance', accountBalance);
      prefs.setString('lastLogin', _lastLogin);
    });
  }

  getInitialization() async{
    SharedPreferences prefs = await _prefs;
    setState(() {
      mobileno=prefs.getString("mobileno");
    });
    getBankInfo();
  }

  _cardStyle(String title,String subTitle,IconData iconName,int selectedItem){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
      child: Card(
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              title: Text("${title}",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("${subTitle}"),
              ),
              leading: Icon(iconName,color: Colors.redAccent,size:50,),
              onTap:(){
                if(selectedItem==1){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>AccountInformationScreen()));
                }
                else if(selectedItem==2){
                  print("2");
                }
                else if(selectedItem==3){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>MoneyTransfer()));
                }
                else if(selectedItem==4){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>TransactionScreen()));
                }
                else if(selectedItem==5){

                }
              }
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async{
               _dbHelper.changeLastLogin(mobileno,_currentDate.toString());
              SharedPreferences prefs = await _prefs;
              prefs.clear();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'MyBanking')
                  ),
                  ModalRoute.withName("/WelcomeScreen")
              );
            },
          )
        ],
      ),
      body: Container(
            child: ListView(
              children: <Widget>[
                _cardStyle("Account Information","Holder: ${name}",_icons[0],1),
                _cardStyle("Account Balance","Rs. ${accountBalance}",_icons[1],2),
                _cardStyle("Money Transfer","Secure Transaction",_icons[2],3),
                _cardStyle("Transactions","All your transactions",_icons[3],4),
              ],
            )
      ),
    );
  }
}
