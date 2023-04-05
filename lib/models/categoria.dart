class Categoria{
  int? id;
  String? tipo;
  String? imagem;

  Categoria({ this.id, this.tipo, this.imagem});

  fromJson(Map<String, dynamic> json){
    id = json['id'];
    tipo = json['tipo'];
    imagem = json['imagem'];
  }

  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tipo'] = this.tipo;
    data['imagem'] = this.imagem;
    return data;
  }

}