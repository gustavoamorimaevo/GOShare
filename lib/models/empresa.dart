class Empresa{
  int? id;
  String? imagem;
  String? nome;
  bool? aberto;
  bool? cartao;
  double? taxa;
  String? funcionamento;
  String? contato;
  String? email;
  String? rua;
  String? bairro;
  int? numero;
  String? complemento;
  String? referencia;
  String? cidade;
  String? estado;
  double? valorMinimo;
  bool? entregaFimDoDia;

  Empresa({
    this.id,
    this.imagem, 
    this.nome, 
    this.cartao,
    this.taxa, 
    this.funcionamento, 
    this.contato, 
    this.aberto, 
    this.email, 
    this.rua, 
    this.numero, 
    this.complemento,
    this.bairro, 
    this.referencia, 
    this.cidade,
    this.estado, 
    this.valorMinimo,
    this.entregaFimDoDia});
  
  fromJson(Map<String, dynamic> json){
    id = json['id'];
    imagem = json['imagem'];
    nome = json['nome'];
    cartao = json['cartao'];
    taxa = json['taxa'];
    funcionamento = json['funcionamento'];
    contato = json["contato"];
    aberto = json['aberto'];
    email = json['email'];
    rua = json['rua'];
    numero = json['numero'];
    complemento = json['complemento'];
    referencia = json['referencia'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    estado = json['estado'];
    valorMinimo = json['valorMinimo'];
    entregaFimDoDia = json['entregaFimDoDia'];
  }

  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagem'] = this.imagem;
    data['nome'] = this.nome;
    data['cartao'] = this.cartao;
    data['taxa'] = this.taxa;
    data['funcionamento'] = this.funcionamento;
    data['contato'] = this.contato;
    data['email'] = this.email;
    data['rua'] = this.rua;
    data['numero'] = this.numero;
    data['complemento'] = this.complemento;
    data['referencia'] = this.referencia;
    data['bairro'] = this.bairro;
    data['cidade'] = this.cidade;
    data['valorMinimo'] = this.valorMinimo;
    data['entregaFimDoDia'] = this.entregaFimDoDia;
    return data;
  }
}