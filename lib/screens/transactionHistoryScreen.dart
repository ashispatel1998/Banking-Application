import 'package:banking_application/models/transactionDetails.dart';
import 'package:banking_application/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  DatabaseHelper _dbHelper;
  List<dynamic> _transactionList=[];
  TransactionDetail _detail=TransactionDetail();
  int _length;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper=DatabaseHelper.instance;
    });
    getTransactions();
  }
  getTransactions() async{
    SharedPreferences prefs = await _prefs;
    _transactionList= await _dbHelper.getTransactionDetails(prefs.getInt('accId'));
    setState(() {
      _transactionList=_transactionList.toList();
      _length=_transactionList.length;
    });
    print(_transactionList);
    print(_transactionList.length);
  }

  rowStyle(int accId,int transactionId,String transactionDate,int amount){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
          child: ListTile(
            leading: Icon(Icons.security,size: 40,color: Colors.green,),
            title: Text("Account No : ${accId} ",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("Transaction Id: ${transactionId} ",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("Amount : ${amount} ",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text("Date : ${transactionDate.substring(0,16)} ",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transfer Money"),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        itemCount:_length,
        reverse: true,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return rowStyle(_transactionList[index]['receiverAccId'],_transactionList[index]['transactionId'],_transactionList[index]['transactionDate'],_transactionList[index]['amount']);
        },
      ),
    );
  }
}

