
class Endereco{
  int? id;
  String? cidade;
  String? rua;
  int? numero;
  String? complemento;
  String? referencia;
  String? bairro;
  String? estado;

  Endereco({
    this.id,
    this.cidade,
    this.rua,
    this.numero,
    this.complemento,
    this.referencia, 
    this.bairro, 
    this.estado});
  
  fromJson(Map<String, dynamic> json){
    id = json['id'];
    cidade = json['cidade'];
    rua = json['rua'];
    numero = json['numero'];
    complemento = json['complemento'];
    referencia = json['referencia'];
    bairro = json['bairro'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cidade'] = this.cidade;
    data['rua'] = this.rua;
    data['numero'] = this.numero;
    data['complemento'] = this.complemento;
    data['referencia'] = this.referencia;
    data['bairro'] = this.bairro;
    data['estado'] = this.estado;
    return data;
  }
}