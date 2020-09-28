class TransactionDetail{
  static const tblTransaction="transactiontable";
  static const colTransactionId='transactionId';
  static const colSenderAccId='senderAccId';
  static const colSenderName='senderName';
  static const colReceiverAccId='receiverAccId';
  static const colReceiverName='receiverName';
  static const colAmountTransfer='amount';
  static const colTransactionDate='transactionDate';

  int transactionId;         // AUTO GENERATED
  int senderAccId;
  String senderName;
  int receiverAccId;
  String receiverName;
  int amount;
  String transactionDate;

  TransactionDetail({this.transactionId, this.senderAccId, this.senderName,
      this.amount, this.receiverAccId, this.receiverName,this.transactionDate});

  Map<String,dynamic> toMap(){
    var map=<String,dynamic>{
      colSenderAccId:senderAccId,
      colSenderName:senderName,
      colReceiverAccId:receiverAccId,
      colReceiverName:receiverName,
      colAmountTransfer:amount,
      colTransactionDate:transactionDate
    };
    if(transactionId != null){
      map[colTransactionId]=transactionId;
    }
    return map;
  }

  TransactionDetail.fromMap(Map<String,dynamic> map){
    transactionId=map[colTransactionId];
    senderAccId=map[colSenderAccId];
    senderName=map[colSenderName];
    receiverAccId=map[colReceiverAccId];
    receiverName=map[colReceiverName];
    amount=map[colAmountTransfer];
    transactionDate=map[colTransactionDate];
  }

}