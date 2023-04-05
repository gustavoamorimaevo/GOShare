
class Address{
  int id;
  String city;
  String street;
  int number;
  String complement;
  String reference;
  String neighborhood;
  String state;

 Address({required this.id,required this.city,required this.street,required this.number,required this.complement,required this.reference, required this.neighborhood, required this.state});
  
  fromJson(Map<String, dynamic> json){
    id = json['id'];
    city = json['city'];
    street = json['street'];
    number = json['number'];
    complement = json['complement'];
    reference = json['reference'];
    neighborhood = json['neighborhood'];
    state = json['state'];
  }

  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city'] = this.city;
    data['street'] = this.street;
    data['number'] = this.number;
    data['complement'] = this.complement;
    data['reference'] = this.reference;
    data['neighborhood'] = this.neighborhood;
    data['state'] = this.state;
    return data;
  }
}