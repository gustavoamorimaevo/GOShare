import 'endereco.dart';
import 'itempedido.dart';

class Pedido{
  int? id;
  DateTime? data;
  double? total;
  int? idEmpresa;
  int? status;
  String? descricao;
  bool? pagamentoCartao;
  List<ItemPedido>? itensPedido;
  int? idUsuario;
  Endereco? endereco;
  bool? visualizadoPeloUsuario;
  bool? retirarNoBalcao;
  

  Pedido({
      this.id,
      this.data,
      this.total,
      this.idEmpresa,
      this.status,
      this.descricao,
      this.pagamentoCartao,
      this.itensPedido, 
      this.idUsuario,
      this.endereco,
      this.visualizadoPeloUsuario,
      this.retirarNoBalcao
    });

  fromJson(Map<String, dynamic> json){
    id = json['id'];
    data = json['data'];
    total = json['total'];
    idEmpresa = json['idempresa'];
    status = json['status'];
    descricao = json['descricao'];
    pagamentoCartao = json['pagamentoCartao'];
    itensPedido = json['itensPedido'];
    idUsuario = json['idUsuario'];
    endereco = json['endereco'];
    visualizadoPeloUsuario = json['visualizadoPeloUsuario'];
    retirarNoBalcao = json['this.retirarNoBalcao'];
  }

  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    data['total'] = this.total;
    data['status'] = this.status;
    data['descricao'] = this.descricao;
    data['pagamentoCartao'] = this.pagamentoCartao;
    data['itensPedido'] = this.itensPedido;
    data['idUsuario'] = this.idUsuario;
    data['idEmpresa'] = this.idEmpresa;
    data['endereco'] = this.endereco;
    data['visualizadoPeloUsuario'] = this.visualizadoPeloUsuario;
    data['retirarNoBalcao'] = this.retirarNoBalcao;
    return data;
  }
}