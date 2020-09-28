class BankDetail{
  static const tblBankDetail='bankdetails';
  static const colaccId='accId';
  static const colName='name';
  static const colEmail='email';
  static const colMobile='mobile';
  static const colDob='dob';
  static const colAccountBalance='accountBalance';

  int accId;
  String name;
  String email;
  String mobile;
  String dob;
  int accountBalance;

  BankDetail({this.accId, this.name, this.email, this.mobile, this.dob,
      this.accountBalance});

  BankDetail.fromMap(Map<String,dynamic> map){
    accId=map[colaccId];
    name=map[colName];
    email=map[colEmail];
    mobile=map[colMobile];
    dob=map[colDob];
    accountBalance=map[colAccountBalance];
  }

  Map<String,dynamic> toMap(){
    var map=<String,dynamic>{
      colaccId:accId,
      colName:name,
      colEmail:email,
      colMobile:mobile,
      colDob:dob,
      colAccountBalance:accountBalance
    };
    return map;
  }
}