class ItemPedido{
  int? id;
  int? idPedido;
  double? valorUnitario;
  double? quantidade;
  int? idProduto;
  String? descricaoProduto;
  String? unidade;
  
  ItemPedido({
    this.id, 
    this.idPedido, 
    this.valorUnitario, 
    this.quantidade, 
    this.idProduto, 
    this.descricaoProduto,
    this.unidade});

  fromJson(Map<String, dynamic> json){
    id = json['id'];
    idPedido = json['idPedido'];
    valorUnitario = json['valorUnitario'];
    quantidade = json['quantidade'];
    idProduto = json['idProduto'];    
    descricaoProduto = json['descricaoProduto'];
  }

  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idPedido'] = this.idPedido;
    data['valorUnitario'] = this.valorUnitario;
    data['idProduto'] = this.idProduto;
    data['descricaoProduto'] = this.descricaoProduto;
    data['unidade'] = this.unidade;
    return data;
  }
}