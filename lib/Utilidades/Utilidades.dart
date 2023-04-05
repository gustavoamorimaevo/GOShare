import 'package:goshare/models/categoria.dart';
import 'package:goshare/models/cidade.dart';
import 'package:goshare/models/empresa.dart';
import 'package:goshare/models/itempedido.dart';
import 'package:goshare/models/pedido.dart';
import 'package:goshare/models/produto.dart';
import 'package:goshare/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum TipoBusca { texto, oferta, categoria, todosProdutos }
enum Tema { laranjado,verde,azul}
  
class Utilidades{
  //versão
  static String numeroVersao = "Versão: 1.0.0.0";
  
  //configuração de recursos 
  static bool apresentacaoChat = true;

  //parametro api 
  static String ipSession = "192.168.1.109";
  static String portaSession = "9500";
  static String siteApiSession = "192.168.1.109:9500"; //"compreaquiapiapp.azurewebsites.net";
  static String token = "";
  
  //email
  static String emailCompreAqui = "compreaquiaplicativo@gmail.com";
  static String senhaCompreAqui = "****";
  
  //respostas form erro
  static String erroTokenInvalido = "Você esteve conectado por muito tempo. Para sua segurança sua sessão foi encerrada. Faça login novamente no aplicativo para continuar (MENU> SAIR)";

  //variaveis de controle formulários
  static bool menuAberto = false;
  static bool selecaoCidadeAutomatica = false;
  static bool buscar = false;
  static bool consultaProdutos = false;
  static bool consultaPedidos = false;
  static bool timerStart = false;
  static bool carregamantoInicialEdicaoUsuario = true;
  static bool pageScreenAberta = false;
  static bool timerScreen = true;
  static bool carregamentoProdutosFormEspera = false;
  static int idCategoriaPesquisada = 0;
  static TipoBusca tipoBusca = TipoBusca.todosProdutos;
  static Tema tema = Tema.verde;
  static bool novaMensagem = false;
  static bool notificacaoNovaMensagem = false;
  static bool notificarUsuarioNovaMensagem = true;
  static bool slidePropaganda = false;
  static bool processandoFinalizarPedido = false;
  static bool erroConsultaPedidos = false;
  static bool erroConsultarProdutos = false;
  
  //variaveis de inicialização de formulários
  static String textoBusca = "";
  static int imagemPropaganda = 0;
  static int valorAvaliacao = 1;
  static int start = 0;
  static String mensagensPedidoTemp = "";
  
  //dados do usuário logado, empresa selecionada e cidade selecionada
  static String? cidadeUsuario = "";
  static Empresa empresaSession = new Empresa(id:0,imagem:"",nome:"",cartao:false,taxa:0,funcionamento:"",contato:"",aberto:false,email:"",rua:"",numero:0,complemento:"",bairro:"",referencia:"",cidade:"",estado:"",valorMinimo:0,entregaFimDoDia:false);
  static Usuario usuarioLogado = new Usuario();
  
  //listas em memória. Usadas para fazer pedidos, armazenar em carrinho, listagem de produtos, categoria.
  static List listaEmpresas = [];
  static List listaTodasEmpresas = [];
  static List<Categoria> listaCategoria = [];
  static List<ItemPedido> listaProdutosCarrinho = [];
  static List<Produto> listaProdutos = [];
  static List<Pedido> listaPedidos = [];
  static List<Image> listaImagens = [];
  
  //endereco alternativo não armazenado na base
  static String enderecoAlternativoCidade = '';
  static String enderecoAlternativoEstado = '';
  static String enderecoAlternativoBairro = '';
  static String enderecoAlternativoRua = '';
  static String enderecoAlternativoNumero = '';
  static String enderecoAlternativoComplemento = '';
  static String enderecoAlternativoReferencia = '';
  
  //dados do usuario temporários para preenchimento dos campos de usuário ao setar estado do formulário
  static String tempUsuariopEdicaoUsuario = '';
  static String tempUsuarioEdicaoNome = '';
  static String tempUsuarioEdicaoEmail = '';
  static String tempUsuarioEdicaoSenha = '';
  static String tempUsuarioEdicaoTelefone = '';
  static String tempUsuarioEdicaoCidade = '';
  static String tempUsuarioEdicaoEstado = '';
  static String tempUsuarioEdicaoBairro = '';
  static String tempUsuarioEdicaoRua = '';
  static String tempUsuarioEdicaoNumero = '';
  static String tempUsuarioEdicaoComplemento = '';
  static String tempUsuarioEdicaoReferencia = '';
  static String tempUsuarioEdicaoCep = '';
  static String tempUsuarioEdicaoDistrito = '';
  static String tempUsuarioEdicaoCidadeSegundoEndereco = '';
  static String tempUsuarioEdicaoEstadoSegundoEndereco = '';
  static String tempUsuarioEdicaoBairroSegundoEndereco = '';
  static String tempUsuarioEdicaoRuaSegundoEndereco = '';
  static String tempUsuarioEdicaoNumeroSegundoEndereco = '';
  static String tempUsuarioEdicaoComplementoSegundoEndereco = '';
  static String temUsuariopEdicaoReferenciaSegundoEndereco = '';
  static String tempUsuarioEdicaoCepSegundoEndereco = '';
  static String temUsuariopEdicaoDistritoSegundoEndereco = '';
  
  static String sobre = "Sobre o GoShare. \n\nSomos uma rede social com a finalilade de criação de listas e recomendação de filmes, séries, jogos ou qualquer tipo de mídia. \n\n"+
  "Faça já as suas Compras pelo App e aguarde no conforto de sua casa!";
  static String termosUso = "Termos de uso e política de privacidade do app: \n\n"+
  "Este app tem a finalilade de criação de listas e recomendação de filmes, séries, jogos ou qualquer tipo de mídia"; 
  static String creditos ="Créditos à direitos:\n\n"
  //"Créditos à Martin Garrix (efeito sonoro). [PIZZA - MARTIN GARRIX]\n"+
  "Créditos à CompreAquiDevs pelo trabalho de design compartilhado.\n\n";
  static String termosUsoTextoCurto = 
  "Este app tem a finalilade de criação de listas e recomendação de filmes, séries, jogos ou qualquer tipo de mídia"; 
  
  static bool VerificaEnderecoUsuario() {
    if (Utilidades.usuarioLogado.cidade == "" ||
          Utilidades.usuarioLogado.cidade == null ||
          Utilidades.usuarioLogado.estado == "" ||
          Utilidades.usuarioLogado.estado == null ||
          Utilidades.usuarioLogado.numero == "" ||
          Utilidades.usuarioLogado.numero == null ||
          Utilidades.usuarioLogado.bairro == "" ||
          Utilidades.usuarioLogado.bairro == null ||
          Utilidades.usuarioLogado.rua == "" ||
          Utilidades.usuarioLogado.rua == null) {
      return false;
    } else {
      return true;
    }
  }

  static Color RetornaCorTemaMenu(){
    switch(Utilidades.tema){
      case Tema.laranjado:
      {
        return Color.fromARGB(255, 254, 202, 124);
      }
      case Tema.verde:
      {
        return Color.fromARGB(255, 125, 197, 129);
      }
      case Tema.azul:
      {
        return Color.fromARGB(255, 19, 99, 192);
      }
    }
    return Color.fromARGB(255, 99, 186, 103);
  }

  static Color RetornaCorTema(){
    switch(Utilidades.tema){
      case Tema.laranjado:
      {
        return Color.fromARGB(255, 254, 202, 124);
      }
      case Tema.verde:
      {
        return Color.fromARGB(255, 125, 197, 129);
      }
      case Tema.azul:
      {
        return Color.fromARGB(255, 19, 99, 192);
      }
    }
    return Color.fromARGB(255, 99, 186, 103);
  }
  
  static Color RetornaCorTemaBotaoGradiente1(){
    switch(Utilidades.tema){
      case Tema.laranjado:
      {
        return Color.fromARGB(255, 254, 202, 124);
      }
      case Tema.verde:
      {
        return Color.fromARGB(255, 125, 197, 129);
      }
      case Tema.azul:
      {
        return Color.fromARGB(255, 19, 99, 192);
      }
    }
    return Color.fromARGB(255, 99, 186, 103);
  }

  static Color RetornaCorTemaBotaoGradiente2(){
    switch(Utilidades.tema){
      case Tema.laranjado:
      {
        return Color.fromARGB(255, 254, 202, 124);
      }
      case Tema.verde:
      {
        return Color.fromARGB(255, 125, 197, 129);
      }
      case Tema.azul:
      {
        return Color.fromARGB(255, 19, 99, 192);
      }
    }
    return Color.fromARGB(255, 99, 186, 103);
  }

  static bool RetornaEmailValido(String email){
    try{
      if(email.split("@")[0].length == 0 || email.split("@")[1].length == 0 ||
       !email.contains(".") || !email.contains("@")){
        return false;
      }
      else{
        return true;
      }
    }
    catch(Exception){
      return false;
    }
  }

  static bool RetornaNumeroValido(String numero){
    try{
      if((numero.replaceAll("0","")
      .replaceAll("1","")
      .replaceAll("2","")
      .replaceAll("3","")
      .replaceAll("4","")
      .replaceAll("5","")
      .replaceAll("6","")
      .replaceAll("7","")
      .replaceAll("8","")
      .replaceAll("9","")).length != 0){
        return false;
      }
      else{
        return true;
      }
    }
    catch(Exception){
      return false;
    }
  }

  static List<Image> RetornaListaImagens(){
    try{
      List<Image> listaImagens_ = [];
      for(int i = 0; i < listaEmpresas.length; i++){
        var empresaApi = Utilidades.listaEmpresas[i];
        var imagem = empresaApi["imageUrl"];
        //##BURGDELIVERY ALTERAÇÃO
        if(empresaApi["companyName"].toString().contains("##")){
          if((imagem == null || imagem == "")){
            listaImagens_.add(Image.asset('assets/app-logo.png'));
          }
          else{
            listaImagens_.add(Image.network(imagem));
          }
        }
      }
      listaImagens =  listaImagens_;
      return listaImagens;
    }
    catch(Exception){
      return [];
    }
  }

  static String RetornaStringEnderecoAlternativoConcatenado(){
    return Utilidades.enderecoAlternativoRua +
                  ", " +
                  Utilidades.enderecoAlternativoNumero.toString() +
                  ". " +
                  Utilidades.enderecoAlternativoBairro +
                  ". " +
                  (Utilidades.enderecoAlternativoComplemento == ""
                      ? ""
                      : Utilidades.enderecoAlternativoComplemento + ". ") +
                  (Utilidades.enderecoAlternativoReferencia == ""
                      ? ""
                      : Utilidades.enderecoAlternativoReferencia + ". ") +
                  (Utilidades.enderecoAlternativoReferencia);
  }

  static void LimpaSession(){
    token = "";
    
    if(listaEmpresas != null)
      listaEmpresas.clear();

    menuAberto = false;
    
    if(listaProdutosCarrinho != null)
      listaProdutosCarrinho.clear();

    if(listaProdutos != null)
      listaProdutos.clear();

    if(listaPedidos != null)
      listaPedidos.clear();
      
    if(listaImagens != null)
      listaImagens.clear();
  
    start = 0;

    selecaoCidadeAutomatica = false;

    textoBusca = "";
    
    buscar = false;
    
    consultaProdutos = false;

    consultaPedidos = false;

    enderecoAlternativoCidade = "";
    
    enderecoAlternativoBairro = "";
    
    enderecoAlternativoRua = "";
    
    enderecoAlternativoNumero = "";
    
    enderecoAlternativoComplemento = "";
    
    enderecoAlternativoReferencia = ""; 

    tempUsuariopEdicaoUsuario = "";
    tempUsuarioEdicaoNome = "";
    tempUsuarioEdicaoEmail = "";
    tempUsuarioEdicaoSenha = "";
    tempUsuarioEdicaoTelefone = "";
    tempUsuarioEdicaoCidade = "";
    tempUsuarioEdicaoEstado = "";
    tempUsuarioEdicaoBairro = "";
    tempUsuarioEdicaoRua = "";
    tempUsuarioEdicaoNumero = "";
    tempUsuarioEdicaoComplemento = "";
    tempUsuarioEdicaoReferencia = "";
    tempUsuarioEdicaoCep = "";
    tempUsuarioEdicaoDistrito = "";
    tempUsuarioEdicaoCidadeSegundoEndereco = "";
    tempUsuarioEdicaoEstadoSegundoEndereco = "";
    tempUsuarioEdicaoBairroSegundoEndereco = "";
    tempUsuarioEdicaoRuaSegundoEndereco = "";
    tempUsuarioEdicaoNumeroSegundoEndereco = "";
    tempUsuarioEdicaoComplementoSegundoEndereco = "";
    temUsuariopEdicaoReferenciaSegundoEndereco = "";
    tempUsuarioEdicaoCepSegundoEndereco = "";
    temUsuariopEdicaoDistritoSegundoEndereco = "";
  }

  static String RetornaTotal() {
    String totalString = "";
    double total = 0;
    for (int i = 0; i < Utilidades.listaProdutosCarrinho.length; i++) {
      total += (Utilidades.listaProdutosCarrinho[i].quantidade ?? 0) *
          (Utilidades.listaProdutosCarrinho[i].valorUnitario ?? 0);
    }
    
    if(total != 0)
      total += Utilidades.empresaSession.taxa??0;
    
    try {
        if (total.toString().split(".")[1].length == 1) {
          totalString = total.toStringAsFixed(2) ;
        }
        else{
          totalString = total.toStringAsFixed(2);
        }
    } catch (Exception) {}
    return totalString;
  }

  static double RetornaTotalDouble() {
    double total = 0;
    for (int i = 0; i < Utilidades.listaProdutosCarrinho.length; i++) {
      total += (Utilidades.listaProdutosCarrinho[i].quantidade ?? 0) *
          (Utilidades.listaProdutosCarrinho[i].valorUnitario ?? 0);
    }
    
    if(total != 0)
      total += (Utilidades.empresaSession.taxa ?? 0);
    return total;
  }
   
  static String AjusteCasaDecimal(String campo){
    try {
          campo = campo.split(".")[0]; 
          // if (campo.split(".")[1].length == 1) {
          //   campo = campo + "0";
          // }
          return campo;
        } catch (Exception) { 
          return "";
          }
  }

  static void InsereUsuarioSession(Usuario usuario){
    usuarioLogado.id = usuario.id;
    usuarioLogado.guid = usuario.guid;
    usuarioLogado.nome = usuario.nome;
    usuarioLogado.email = usuario.email;
    usuarioLogado.login = usuario.login;
    usuarioLogado.senha = usuario.senha;
    usuarioLogado.telefone = usuario.telefone;
    usuarioLogado.avaliacao = usuario.avaliacao;
    usuarioLogado.cidade = usuario.cidade;
    usuarioLogado.estado = usuario.estado;
    usuarioLogado.bairro = usuario.bairro;
    usuarioLogado.rua = usuario.rua;
    usuarioLogado.numero = usuario.numero;
    usuarioLogado.complemento = usuario.complemento;
    usuarioLogado.referencia = usuario.referencia;
    usuarioLogado.distrito = usuario.distrito;
    usuarioLogado.cep = usuario.cep;
    usuarioLogado.idEndereco1 = usuario.idEndereco1;
    usuarioLogado.cidadeSegundoEndereco = usuario.cidadeSegundoEndereco;
    usuarioLogado.estadoSegundoEndereco = usuario.estadoSegundoEndereco;
    usuarioLogado.bairroSegundoEndereco = usuario.bairroSegundoEndereco;
    usuarioLogado.ruaSegundoEndereco = usuario.ruaSegundoEndereco;
    usuarioLogado.numeroSegundoEndereco = usuario.numeroSegundoEndereco;
    usuarioLogado.complementoSegundoEndereco = usuario.complementoSegundoEndereco;
    usuarioLogado.referenciaSegundoEndereco = usuario.referenciaSegundoEndereco;
    usuarioLogado.distritoSegundoEndereco = usuario.distritoSegundoEndereco;
    usuarioLogado.cepSegundoEndereco = usuario.cepSegundoEndereco;
    usuarioLogado.idEndereco2 = usuario.idEndereco2;
  }

  static void AlteraUsuarioSession(Map usuarioApi){
    try
    {
      usuarioLogado.login = usuarioApi['userName'];
      usuarioLogado.email = usuarioApi['email'];
      usuarioLogado.nome = usuarioApi['firstName'];
      usuarioLogado.telefone = usuarioApi['telefone'];
      usuarioLogado.cidade = usuarioApi['cidade'];
      usuarioLogado.rua = usuarioApi['rua'];
      if(usuarioApi['numero'] != "")
        usuarioLogado.numero = int.parse(usuarioApi['numero']);
      usuarioLogado.bairro = usuarioApi['bairro'];
      usuarioLogado.complemento = usuarioApi['complemento'];
      usuarioLogado.referencia = usuarioApi['referencia'];
      usuarioLogado.cep = usuarioApi['cep'];
      usuarioLogado.distrito = usuarioApi['distrito'];
      usuarioLogado.cidadeSegundoEndereco = usuarioApi['cidadeSegundoEndereco'];
      usuarioLogado.ruaSegundoEndereco = usuarioApi['ruaSegundoEndereco'];
      if(usuarioApi['numeroSegundoEndereco'] != "")
        usuarioLogado.numeroSegundoEndereco = int.parse(usuarioApi['numeroSegundoEndereco']);
      usuarioLogado.bairroSegundoEndereco = usuarioApi['bairroSegundoEndereco'];
      usuarioLogado.complementoSegundoEndereco = usuarioApi['complementoSegundoEndereco'];
      usuarioLogado.referenciaSegundoEndereco = usuarioApi['referenciaSegundoEndereco'];
      usuarioLogado.cepSegundoEndereco = usuarioApi['cepSegundoEndereco'];
      usuarioLogado.distritoSegundoEndereco = usuarioApi['distritoSegundoEndereco'];
    }
    catch(Exception){

    }
  }

  static List<String> RetornaListaCidade_(){
    try{
      List<String> lista = [];
    lista.add("");
    lista.add("Manhuaçu");
    lista.add("Manhumirim");
    lista.add("Alto Caparaó");
    lista.add("Caparaó");
    lista.add("Alto Jequitibá");
    lista.add("Reduto");
    lista.add("Realeza");
    lista.add("Martins Soares");

    for(int i = 0; i < listaEmpresas.length; i++){
      bool existeElemento = false;
      
      for(int j = 0; j < lista.length; j++){
        if(lista[j] == listaEmpresas[i]["addressCity"]){
          existeElemento = true;
        }
      }

      if(!existeElemento){
        lista.add(listaEmpresas[i]["addressCity"]);  
      }
    }

    return lista;
    }
    catch(Exception){
      return [];
    }
  }

  static List<String> RetornaListaEstado_(){
    List<String> lista = [];
    lista.add("");
    lista.add("MG");
    lista.add("ES");
    lista.add("SP");
    lista.add("RJ");
    return lista;
  }

  //testes
  static List<Empresa> RetornaListaEmpresas(){
    List<Empresa> lista = [];
    lista = [];
    lista.add(Empresa(
      id:1,
      imagem:"",
      nome:"Pais & Filhos Supermercado",
      cartao:true,
      taxa:2.00,
      funcionamento:"Segunda à sexta",
      contato: "(33)3341-2227",
      aberto:true,
      email:"paisefilhos@gmail.com",
      rua:"joão maroni",
      numero:49,
      complemento:"ap 303",
      bairro: "centro", 
      cidade: "Manhuaçu",
      estado: "MG",
      referencia:"perto do cabeleireiro",
      valorMinimo: 10.0,
      entregaFimDoDia: false));

    lista.add(Empresa(
      id:2,
      imagem:"",
      nome:"Coelho Diniz Supermercado",
      aberto:false,
      cartao:false,
      taxa:0.00,
      funcionamento:"Segunda à sexta de 8h às 18h: e sábado de 8h à 12h", 
      contato: "(33)3341-2897", 
      rua:"joão maroni", 
      bairro: "centro", 
      cidade: "Manhuacu", 
      numero:49, 
      complemento:"ap 304",
      referencia:"perto do cabeleireiro", 
      email:"cd@gmail.com",
      estado: "MG",
      valorMinimo: 10.0,
      entregaFimDoDia: false));
    return lista;
  }

  static List<Produto> RetornaListaProdutos(){
    List<Produto> lista = [];
    lista = [];
    lista.add(Produto(id:1,guid:"",precoNaoPromocional:10.10,idEmpresa:1,ativo:true, imagem:"",preco:10.55,nome:"coca-cola 1L", promocao:false, fracionado: false, unidade: "UN",idCategoria:1));
    lista.add(Produto(id:2,guid:"",precoNaoPromocional:11.10,idEmpresa:1,ativo:true,imagem:"",preco:12.50,nome:"chocolate", promocao:true, fracionado: true, unidade: "KG", idCategoria:2));
    lista.add(Produto(id:3,guid:"",precoNaoPromocional:12.10,idEmpresa:1,ativo:true,imagem:"",preco:13.50,nome:"biscoito aymore", promocao:true, fracionado:false, unidade: "UN", idCategoria:3));
    lista.add(Produto(id:4,guid:"",precoNaoPromocional:13.10,idEmpresa:1,ativo:true,imagem:"",preco:14.50,nome:"biscoito princesa", promocao:false, fracionado:false, unidade: "UN", idCategoria:4));
    lista.add(Produto(id:5,guid:"",precoNaoPromocional:16.10,idEmpresa:1,ativo:true,imagem:"",preco:16.50,nome:"biscoito wafer", promocao:false, fracionado:false, unidade: "UN", idCategoria:5));
    return lista;
  } 

  static List<Cidade> RetornaListaCidade(){
    List<Cidade> lista = [];
    lista = [];
    lista.add(Cidade(id:1,nome:"Manhuaçu"));
    lista.add(Cidade(id:2,nome:"Manhumirim"));
    lista.add(Cidade(id:2,nome:"Alto Caparaó"));
    lista.add(Cidade(id:2,nome:"Caparaó"));
    lista.add(Cidade(id:2,nome:"Alto Jequitibá"));
    lista.add(Cidade(id:2,nome:"Reduto"));
    lista.add(Cidade(id:2,nome:"Realeza"));
    lista.add(Cidade(id:2,nome:"Martins Soares"));
    return lista;
 }
 
 static List<ItemPedido> RetornaListaItemPedidos(){
    List<ItemPedido> lista = [];
    lista = [];
    lista.add(ItemPedido(id:1, quantidade: 2, valorUnitario: 10.45, idPedido: 1, idProduto: 1, descricaoProduto:"ao lado do shopping",unidade:"UN"));
    lista.add(ItemPedido(id:2, quantidade: 2, valorUnitario: 9.45, idPedido: 2, idProduto: 2, descricaoProduto:"ao lado do shopping 2",unidade:"UN"));
    return lista;
 }

 static List<Pedido> RetornaListaPedidos(){
    List<Pedido> lista = [];
    lista = [];
    lista.add(Pedido(id:1, total: 55.85, data: DateTime.now(), idEmpresa: 1));
    lista.add(Pedido(id:2, total: 54.15, data: DateTime.now(), idEmpresa: 2));
    return lista;
 }
}