import 'package:banking_application/models/transactionDetails.dart';
import 'package:banking_application/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MoneyTransfer extends StatefulWidget {
  @override
  _MoneyTransferState createState() => _MoneyTransferState();
}

class _MoneyTransferState extends State<MoneyTransfer> {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  DateTime _currentDate=DateTime.now();

  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  int _accIdReceiver;
  String _receiverName;
  int _amountTransfer;
  int _senderBankBalance;
  int _receiverBankBalance;


  DatabaseHelper _dbHelper;
  List<dynamic> _bankInfoSender;
  List<dynamic> _bankInfoReceiver;

  TransactionDetail _transactionDetail=TransactionDetail();


  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper=DatabaseHelper.instance;
    });
  }

  getAllData() async{
    SharedPreferences prefs = await _prefs;
    _bankInfoSender=await _dbHelper.getBankInfo(prefs.getString("mobileno"));
    _senderBankBalance=_bankInfoSender[0]["accountBalance"];
    _bankInfoReceiver=await _dbHelper.getBankInfoReceiver(_accIdReceiver, _receiverName);
    print(_bankInfoReceiver);
    if(_accIdReceiver!=prefs.getInt("accId")){
      if(_bankInfoSender[0]['accountBalance']>0 && _amountTransfer<_bankInfoSender[0]['accountBalance']){
        if(_bankInfoReceiver!=null){
           _receiverBankBalance=_bankInfoReceiver[0]['accountBalance']+_amountTransfer;
           _senderBankBalance=_bankInfoSender[0]['accountBalance']-_amountTransfer;
           _transactionDetail.senderAccId=prefs.getInt('accId');
           _transactionDetail.senderName=prefs.getString('name');
           _transactionDetail.receiverAccId=_accIdReceiver;
           _transactionDetail.receiverName=_receiverName;
           _transactionDetail.amount=_amountTransfer;
           _transactionDetail.transactionDate=_currentDate.toString();
           int res= await _dbHelper.insertTransaction(_transactionDetail);
           if(res!=null){
             bool rel1=await _dbHelper.updateBankBalance(_accIdReceiver, _receiverBankBalance);
             bool rel2=await _dbHelper.updateBankBalance(prefs.getInt('accId'), _senderBankBalance);
             if(rel1 && rel2){
               print("Data Updated");
               Fluttertoast.showToast(
                   msg: "Transaction Id : ${res}",
                   toastLength: Toast.LENGTH_LONG,
                   gravity: ToastGravity.BOTTOM,
                   timeInSecForIos: 1,
                   backgroundColor: Colors.black,
                   textColor: Colors.white
               );
             }
           }else{
             print("Data Not Updated");
           }
        }
        else{
          Fluttertoast.showToast(
              msg: "Invalid Account!",
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
            msg: "Insufficient Fund!!",
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
          msg: "You can't send to the same account!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white
      );
    }
  }

  void validate(){
   if(_formKey.currentState.validate()){
     _formKey.currentState.save();
     getAllData();
     _formKey.currentState.reset();
   }
  }

  String validateAccountId(String value){
    if(value.isEmpty){
      return "Required";
    }else{
      return null;
    }
  }

  String validateName(String value){
    if(value.isEmpty){
      return "Required";
    }
    else{
      return null;
    }
  }

  String validateMoneyField(String value){
    if(value.isEmpty){
      return "Required";
    }
    else{
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Money Transfer"),
        backgroundColor: Colors.redAccent,
      ),
      body:Padding(
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
                      labelText: 'Account No',
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value){
                      value=value.trim();
                      _accIdReceiver=int.parse(value);
                    },
                    validator: validateAccountId,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Account Holder Name',
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: validateName,
                    onSaved: (value){
                      _receiverName=value.trim();
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Transfer Amount',
                    ),
                    onSaved: (value){
                      _amountTransfer=int.parse(value);
                    },
                    keyboardType: TextInputType.number,
                    validator: validateMoneyField,
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.greenAccent,
                      child: Text('Make Payment'),
                      onPressed: () {
                        validate();
                      },
                    )),
                SizedBox(height: 10,),
              ],
            ),
          ))
    );
  }
}
