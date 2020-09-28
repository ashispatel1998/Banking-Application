import 'package:banking_application/models/bankDetails.dart';
import 'package:banking_application/models/transactionDetails.dart';
import 'package:banking_application/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';


class DatabaseHelper{
  static const _databaseName="bank2.db";
  static const _databaseVersion=1;

  // Singleton class
  DatabaseHelper._();
  static final DatabaseHelper instance=DatabaseHelper._();

  Database _database;
  Future<Database >get database async{
    if(_database!=null) return _database;
    _database= await _initDatabase();
    return _database;
  }

   _initDatabase() async {
    Directory dataDirectory=await getApplicationDocumentsDirectory();
    String dbPath=join(dataDirectory.path,_databaseName);
     return await openDatabase(dbPath,version: _databaseVersion,onCreate:_onCreateDB);
  }

  _onCreateDB(Database db,int version) async{
    db.execute('''
    CREATE TABLE ${User.tblUser}(
    ${User.colaccId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${User.colName}  TEXT NOT NULL,
    ${User.colEmail}  TEXT NOT NULL,
    ${User.colMobileno}  TEXT NOT NULL UNIQUE,
    ${User.colPassword}  TEXT NOT NULL,
    ${User.colDob}  TEXT NOT NULL,
    ${User.colAgeLimit} TEXT NOT NULL,
    ${User.colLastLogin} TEXT NOT NULL
    )
    ''');

    db.execute('''
    CREATE TABLE ${BankDetail.tblBankDetail}(
    ${BankDetail.colaccId} INTEGER PRIMARY KEY,
    ${BankDetail.colName} TEXT NOT NULL,
    ${BankDetail.colEmail} TEXT NOT NULL,
    ${BankDetail.colMobile} TEXT NOT NULL UNIQUE,
    ${BankDetail.colDob}  TEXT NOT NULL,
    ${BankDetail.colAccountBalance} INTEGER NOT NULL
    )
    ''');

    db.execute('''
    CREATE TABLE ${TransactionDetail.tblTransaction}(
     ${TransactionDetail.colTransactionId} INTEGER PRIMARY KEY AUTOINCREMENT,
     ${TransactionDetail.colSenderAccId} INTEGER NOT NULL,
     ${TransactionDetail.colSenderName} TEXT NOT NULL,
     ${TransactionDetail.colReceiverAccId} INTEGER NOT NULL,
     ${TransactionDetail.colReceiverName} TEXT NOT NULL,
     ${TransactionDetail.colAmountTransfer} INTEGER NOT NULL,
     ${TransactionDetail.colTransactionDate} TEXT NOT NULL,
    )
    ''');
  }

  Future<int> insertUser(User user) async{
    Database db= await database;
    try {
      return await db.insert(User.tblUser, user.toMap());
    }catch(e){
      Fluttertoast.showToast(
          msg: "Mobile no exists!!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white
      );
    }
  }

  Future<int> insertBankDetails(BankDetail bankDetail) async{
    Database db=await database;
    return await db.insert(BankDetail.tblBankDetail, bankDetail.toMap());
  }

  Future<bool> getLogin(String mobile, String password) async {
    Database db=await database;
    var res = await db.rawQuery("SELECT * FROM user WHERE ${User.colMobileno} = '$mobile' and ${User.colPassword} = '$password'");
    if (res.length > 0) {
      return true;
    }
    return false;
  }

  Future<List> getBankInfo(String mobile) async{
    Database db=await database;
    List<Map> list=await db.rawQuery('''
    SELECT * FROM ${BankDetail.tblBankDetail} WHERE ${BankDetail.colMobile}='$mobile';
    ''');
    if(list.length>0){
      return  list.toList();
    }
  }

  Future<String> getLastLoginStatus(String mobile) async{
    Database db=await database;
    List<Map> list=await db.rawQuery('''
    SELECT * FROM ${User.tblUser} WHERE ${User.colMobileno}='$mobile';
    ''');
    if(list.length>0){
      return  list[0]['${User.colLastLogin}'].toString();
    }
  }

  Future<int> changeLastLogin(String mobile,String lastLogin) async{
    Database db=await database;
    Map<String,dynamic> row={
      User.colLastLogin:lastLogin
    };
    int res=await db.update(User.tblUser, row,where: '${User.colMobileno}=?',whereArgs: [mobile]);
    return res;
  }
}
