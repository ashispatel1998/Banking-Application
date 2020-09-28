import 'package:banking_application/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckBalance extends StatefulWidget {
  @override
  _CheckBalanceState createState() => _CheckBalanceState();
}

class _CheckBalanceState extends State<CheckBalance> {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  DatabaseHelper _dbHelper;
  List<dynamic> _bankinfo;
  int _totalBalance;
  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper=DatabaseHelper.instance;
    });
    getBankInfo();
  }

  getBankInfo() async{
    SharedPreferences prefs = await _prefs;
    _bankinfo= await _dbHelper.getBankInfo(prefs.getString("mobileno"));
    print(_bankinfo);
    setState(() {
      _totalBalance=_bankinfo[0]['accountBalance'];
    });
    print(_totalBalance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Balance"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.account_balance,
              size: 50,color: Colors.lightGreen,),
              title: Text("Avaliable Balance",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              ),
              subtitle: Text("$_totalBalance",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.green
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
