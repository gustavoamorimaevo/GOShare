import 'orderItem.dart';

class Order{
  int? Id;
  int? Guid;
  int? CustomerId;
  int? UserId;
  //DateTime Date;
  double? Total;
  int? Status;
  String? Description;
  bool? CreditCard;
  List<OrderItem>? OrderItemList;
  int? UserAddressId;
  bool? CatchInStore;

  Order({
    this.Id,
    this.Guid,
    this.Total,
    this.CustomerId,
    this.Status,
    this.Description,
    this.CreditCard,
    this.OrderItemList,
    this.UserId,
    this.UserAddressId,
    this.CatchInStore});

  fromJson(Map<String, dynamic> json){
    // Id = json['Id'];
    // Guid = json['Guid'];
    //Date = json['Date'];
    Total = json['Total'];
    CustomerId = json['CustomerId'];
    Status = json['Status'];
    Description = json['Description'];
    CreditCard = json['CreditCard'];
    OrderItemList = json['OrderItemList'];
    UserId = json['userId'];
    UserAddressId = json['UserAddressId'];
    CatchInStore = json['CatchInStore'];
  }

  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String, dynamic>();
    // data['Id'] = this.Id;
    // data['Guid'] = this.Guid;
    //data['Date'] = this.Date;
    data['Total'] = this.Total;
    data['CustomerId'] = this.CustomerId;
    data['Status'] = this.Status;
    data['Description'] = this.Description;
    data['CreditCard'] = this.CreditCard;
    data['OrderItemList'] = this.OrderItemList;
    data['UserId'] = this.UserId;
    data['CustomerId'] = this.CustomerId;
    data['UserAddressId'] = this.UserAddressId;
    data['CatchInStore'] = this.CatchInStore;
    return data;
  }
}



