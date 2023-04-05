class Usuario{
  int? id;
  String? guid;
  String? nome;
  String? email;
  String? login;
  String? senha;
  String? telefone;
  String? rua;
  String? bairro;
  int? numero;
  String? complemento;
  String? referencia;
  String? cidade;
  String? estado;
  String? cep;
  int? idEndereco1;
  String? distrito;
  String? ruaSegundoEndereco;
  String? bairroSegundoEndereco;
  int? numeroSegundoEndereco;
  String? complementoSegundoEndereco;
  String? referenciaSegundoEndereco;
  String? cidadeSegundoEndereco;
  String? estadoSegundoEndereco;
  String? cepSegundoEndereco;
  String? distritoSegundoEndereco;
  int? idEndereco2;
  bool? enderecoPrincipal;
  int? avaliacao;

  Usuario({
   this.id,
   this.guid, 
   this.nome,
   this.email, 
   this.login, 
   this.senha, 
   this.telefone, 
   this.avaliacao, 
   this.rua, 
   this.bairro, 
   this.numero, 
   this.complemento, 
   this.referencia, 
   this.cidade, 
   this.estado, 
   this.cep,
   this.idEndereco1,
   this.distrito,
   this.ruaSegundoEndereco, 
   this.bairroSegundoEndereco, 
   this.numeroSegundoEndereco, 
   this.complementoSegundoEndereco, 
   this.referenciaSegundoEndereco, 
   this.cidadeSegundoEndereco, 
   this.estadoSegundoEndereco, 
   this.cepSegundoEndereco,
   this.distritoSegundoEndereco,
   this.idEndereco2,
   this.enderecoPrincipal
  });

  fromJson(Map<String, dynamic> json){
    id = json['id'];
    guid = json['guid'];
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
    telefone = json['telefone'];
    avaliacao = json['avaliacao'];
    rua = json['rua'];
    bairro = json['bairro'];
    numero = json['numero'];
    complemento = json['complemento'];
    referencia = json['referencia'];
    cidade = json['cidade'];
    estado = json['estado'];
    idEndereco1 = json['idEndereco1'];
    cep = json['cep'];
    distrito = json['distrito'];
    ruaSegundoEndereco = json['ruaSegundoEndereco'];
    bairroSegundoEndereco = json['bairroSegundoEndereco'];
    numeroSegundoEndereco = json['numeroSegundoEndereco'];
    complementoSegundoEndereco = json['complementoSegundoEndereco'];
    referenciaSegundoEndereco = json['referenciaSegundoEndereco'];
    cidadeSegundoEndereco = json['cidadeSegundoEndereco'];
    estadoSegundoEndereco = json['estadoSegundoEndereco'];
    idEndereco2 = json['idEndereco2'];
    cepSegundoEndereco = json['cepSegundoEndereco'];
    distritoSegundoEndereco = json['distritoSegundoEndereco'];
    enderecoPrincipal = json['enderecoPrincipal'];
  }

  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['guid'] = this.guid;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['telefone'] = this.telefone;
    data['avaliacao'] = this.avaliacao;
    data['rua'] = this.rua;
    data['bairro'] = this.bairro;
    data['numero'] = this.numero;
    data['complemento'] = this.complemento;
    data['referencia'] = this.referencia;
    data['cidade'] = this.cidade;
    data['estado'] = this.estado;
    data['idEstado1'] = this.idEndereco1;
    data['cep'] = this.cep;
    data['distrito'] = this.distrito;
    data['ruaSegundoEndereco'] = this.ruaSegundoEndereco;
    data['bairroSegundoEndereco'] = this.bairroSegundoEndereco;
    data['numeroSegundoEndereco'] = this.numeroSegundoEndereco;
    data['complementoSegundoEndereco'] = this.complementoSegundoEndereco;
    data['referenciaSegundoEndereco'] = this.referenciaSegundoEndereco;
    data['cidadeSegundoEndereco'] = this.cidadeSegundoEndereco;
    data['estadoSegundoEndereco'] = this.estadoSegundoEndereco;
    data['idEndereco2'] = this.idEndereco2;
    data['cepSegundoEndereco'] = this.cepSegundoEndereco;
    data['distritoSegundoEndereco'] = this.distritoSegundoEndereco;
    data['enderecoPrincipal'] = this.enderecoPrincipal;
    return data;
  }
}