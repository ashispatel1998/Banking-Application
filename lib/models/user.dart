class User{

  static const tblUser='user';         //  Table Name
  static const colaccId='accId';
  static const colName='name';
  static const colEmail='email';
  static const colMobileno="mobileNo";
  static const colPassword="password";
  static const colDob='dob';
  static const colAgeLimit='ageLimitType';
  static const colLastLogin='lastLogin';

  int accId;   // AUTO GENERATED
  String name;
  String email;
  String mobileNo;
  String password;
  String dob;
  String ageLimitType;
  String lastLogin;

  User({this.accId, this.name, this.email, this.mobileNo, this.password,
      this.dob, this.ageLimitType,this.lastLogin});

  Map<String,dynamic> toMap(){
    var map=<String,dynamic>{
      colName:name,
      colEmail:email,
      colMobileno:mobileNo,
      colPassword:password,
      colDob:dob,
      colAgeLimit:ageLimitType,
      colLastLogin:lastLogin
    };
    if(accId != null){
      map[colaccId]=accId;
    }
    return map;
  }

  User.fromMap(Map<String,dynamic> map){
    accId=map[colaccId];
    name=map[colName];
    email=map[colEmail];
    mobileNo=map[colMobileno];
    password=map[colPassword];
    dob=map[colDob];
    ageLimitType=map[colAgeLimit];
    lastLogin=map[colLastLogin];
  }

}