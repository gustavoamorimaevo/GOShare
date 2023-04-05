class Produto{
  int? id;
  String? guid;
  int? idCategoria;
  int? idEmpresa;
  String? nome;
  String? imagem;
  bool? ativo;
  bool? fracionado;
  double? preco;
  double? precoNaoPromocional;
  String? unidade;
  bool? promocao;
  
  Produto({
    this.id, 
    this.guid, 
    this.nome, 
    this.imagem, 
    this.promocao, 
    this.preco, 
    this.precoNaoPromocional,
    this.fracionado, 
    this.unidade, 
    this.idCategoria, 
    this.idEmpresa,
    this.ativo});

  fromJson(Map<String, dynamic> json){
    id = json['id'];
    guid = json['guid'];
    idCategoria = json['idCategoria'];
    idEmpresa = json['idEmpresa'];
    nome = json['nome'];
    imagem = json['imagem'];
    ativo = json['ativo'];
    fracionado = json['fracionado'];
    preco = json['preco'];
    precoNaoPromocional = json['precoNaoPromocional'];
    unidade = json['unidade'];
    promocao = json['promocao'];
  }

  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['guid'] = this.guid;
    data['idCategoria'] = this.idCategoria;
    data['idEmpresa'] = this.idEmpresa;
    data['nome'] = this.nome;
    data['imagem'] = this.imagem;
    data['ativo'] = this.ativo;
    data['fracionado'] = this.fracionado;
    data['preco'] = this.preco;
    data['precoNaoPromocional'] = this.precoNaoPromocional;
    data['unidade'] = this.unidade;
    data['promocao'] = this.promocao;
    return data;
  }
}