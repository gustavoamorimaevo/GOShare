class OrderItem{
  //int Id;
  int? OrderId;
  double? Price;
  double? Quantity;
  int? ProductId;
  String? Description;
  String? Unity;
  
  OrderItem({this.OrderId, this.Price, this.Quantity, this.ProductId, this.Description, this.Unity});

  fromJson(Map<String, dynamic> json){
    // id = json['id'];
    OrderId = json['OrderId'];
    Price = json['Price'];
    Quantity = json['Quantity'];
    ProductId = json['ProductId'];    
    Description = json['Description'];
    Unity = json['Unity'];
  }

  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['OrderId'] = this.OrderId;
    data['Price'] = this.Price;
    data['ProductId'] = this.ProductId;
    data['Description'] = this.Description;
    data['Unity'] = this.Unity;
    data['Quantity'] = this.Quantity;
    return data;
  }
}