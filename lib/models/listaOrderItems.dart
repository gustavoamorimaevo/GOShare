import 'orderItem.dart';

class ListOrderItems{
  List<OrderItem> lista = [];
  
  ListOrderItems({required this.lista});

  ListOrderItems.fromJson(Map<String, dynamic> json){
    lista = json['lista'];
  }

  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String, dynamic>();
    data['lista'] = this.lista;
    return data;
  }
}