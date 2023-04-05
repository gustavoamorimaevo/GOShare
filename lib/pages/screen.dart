import 'dart:async';
import 'dart:io';
import 'package:goshare/Utilidades/Utilidades.dart';
import 'package:goshare/Utilidades/block.settings.dart';
import 'package:goshare/Utilidades/endpoinst.dart';
import 'package:goshare/Utilidades/settings.dart';
import 'package:goshare/models/empresa.dart';
import 'package:goshare/pages/pedidos.dart';
import 'package:goshare/pages/produtos.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:video_player/video_player.dart';

class ScreenWidget extends StatefulWidget {
  final Function onTap;
  final Function onTap2;

  const ScreenWidget({Key? key, required this.onTap, required this.onTap2}) : super(key: key);

  @override
  _DrawerWidgetState createState() => new _DrawerWidgetState();
}

class _DrawerWidgetState extends State<ScreenWidget> {
  // VideoPlayerController _controller;
  static Image propaganda = Utilidades.listaImagens[
      Utilidades.imagemPropaganda == null ? 0 : Utilidades.imagemPropaganda];
  Timer? _timer;
  int _start = 0;
  bool processandoMensagemNotificacao = false;

  Widget RetornaCardEmpresa(Empresa empresa) {
    return Container(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      SizedBox(height: 10),
      Text(
          (empresa.nome??"").replaceAll("##", "").length > 22
              ? (empresa.nome ??"").replaceAll("##", "").substring(0, 22) + ".."
              : (empresa.nome??"").replaceAll("##", ""),
          //style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold)
          style: GoogleFonts.mcLaren(
              fontSize: 13,
              fontWeight: FontWeight.bold)), //GoogleFonts.mcLaren()
      SizedBox(height: 15),
      TextButton(
          child: Container(
            width: 110,
            height: 110,
            child: Container(
              child: Container(
                  width: 20,
                  height: 20,
                  child: Image.asset(empresa.cartao ?? false
                      ? "assets/pag_dinheiro_cartao.png"
                      : "assets/pag_dinheiro.png")),
              width: 110,
              height: 110,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: (empresa.aberto ?? false)
                      ? new ColorFilter.mode(
                          Colors.black.withOpacity(1), BlendMode.dstATop)
                      : new ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: new NetworkImage(empresa.imagem ?? ""),
                ),
              ),
            ),
          ),
          onPressed: () {
            if (Utilidades.VerificaEnderecoUsuario()) {
              Utilidades.empresaSession = empresa;
              if (!Utilidades.menuAberto) {
                if (empresa.aberto ?? false) {
                  Utilidades.listaProdutosCarrinho.clear();
                  Utilidades.textoBusca = "";
                  Utilidades.buscar = false;
                  Utilidades.consultaProdutos = false;

                  Utilidades.timerScreen = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => (Produtos()),
                    ),
                  );
                } else {
                  Widget okButton = TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                  AlertDialog alerta = AlertDialog(
                    title: Text(""),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 80,
                          child: Image.asset("assets/alert.png"),
                        ),
                        SizedBox(height: 20),
                        Text("Lista Inativa"),
                      ],
                    ),
                    actions: [
                      okButton,
                    ],
                  );
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return alerta;
                    },
                  );
                }
              }
            } else {
              AlertDialog alerta = AlertDialog(
                title: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        width: 18,
                        height: 18,
                        child:
                            Image.asset('assets/setaatualizarendereco.png'))),
                backgroundColor: Colors.transparent, //.green[200],
                content: Align(
                  alignment: Alignment.topLeft,
                  child: Card(
                    color: Colors.green[400],
                    child: TextButton(
                      child: Container(
                        height: 120,
                        child: Center(
                            child: Text(
                                "Campos de endereço incompletos. Atualize seu endereço no menu editar perfil para continuar com a compra.\n\nOK",
                                style: TextStyle(color: Colors.white))),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              );
              showDialog(
                context: context,
                //barrierDismissible: false,
                builder: (BuildContext context) {
                  return alerta;
                },
              );
            }
          }),
      SizedBox(height: 10),
      // Text((empresa.taxa ?? 0) > 0
      //     ? "Entrega: R\$ " +
      //         Utilidades.AjusteCasaDecimal(empresa.taxa.toString())
      //     : "Entrega grátis"),
      TextButton(
          child: Container(child: Text("Mais informações")),
          onPressed: () {
            if (!Utilidades.menuAberto) {
              Widget okButton = TextButton(
                child: Text("Voltar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
              AlertDialog alerta = AlertDialog(
                title: Center(
                    child: Text(empresa.nome??"".replaceAll("##", ""),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900]))),
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Container(
                    // width: 200,
                    height: 130,
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child:
                            // Container(color: Colors.white,width:33,height:33,
                            // child:
                            Card(
                          child: Container(
                            width: 50,
                            height: 50,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 45,
                                height: 45,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      width: 45,
                                      height: 45,
                                      child: Image.asset(
                                          "assets/circleavatarbranco.png")),
                                ),
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: new NetworkImage(empresa.imagem??""),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        // ),
                        ),
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: new NetworkImage(empresa.imagem ?? ""),
                      ),
                    ),
                  ),

                  SizedBox(height: 5),
                  Center(child: Text((empresa.funcionamento??"").split('##')[1] != null ? (empresa.funcionamento??"").split('##')[1]: "", style: GoogleFonts.mcLaren(fontSize: 11,fontWeight: FontWeight.bold,color: Colors.green[600]))),
                  SizedBox(height: 5),
                  Row(children: <Widget>[
                    Container(
                        width: 15,
                        height: 15,
                        child: Image.asset('assets/cifrao.png')),
                    Text(
                        empresa.cartao??false
                            ? "Pagamento: Cartão/Dinheiro"
                            : "Pagamento: Somente dinheiro",
                        style: TextStyle(
                            fontSize: 10,
                            backgroundColor: Colors.green,
                            color: Colors.white)),
                  ]),
                  Row(children: <Widget>[
                    Container(
                        width: 15,
                        height: 15,
                        child: Image.asset('assets/telefone.png')),
                    Text(("Contato: " + (empresa.contato).toString()),
                        style: TextStyle(fontSize: 10, color: Colors.black)),
                  ]),
                  Row(children: <Widget>[
                    Container(
                        width: 15,
                        height: 15,
                        child: Image.asset('assets/email.png')),
                    Text("E-mail: " + empresa.email.toString(),
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ]),
                  Row(children: <Widget>[
                    empresa.entregaFimDoDia??false
                        ? Container(
                            width: 15,
                            height: 15,
                            child: Image.asset('assets/delivery.png'))
                        : Text(""),
                    Text(
                        empresa.entregaFimDoDia??false
                            ? "ENTREGA NO FINAL DO DIA"
                            : "",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  ]),
                  SizedBox(height: 5),
                  Text(
                      (empresa.funcionamento != null
                              ? "Horário de funcionamento: " +
                                  (empresa.funcionamento??"")
                              : "") +
                          "\n"
                              "Endereço: " +
                          (empresa.rua??"") +
                          ", Nº " +
                          empresa.numero.toString() +
                          ". " +
                          "Bairro: " +
                          (empresa.bairro??"") +
                          ". " +
                          (empresa.cidade??"") +
                          "\n" +
                          (empresa.complemento != null &&
                                  empresa.complemento != ""
                              ? ("Complemento: " + (empresa.complemento??"") + "\n")
                              : "") +
                          (empresa.referencia != null &&
                                  empresa.complemento != ""
                              ? ("Referência: " + (empresa.referencia??"") + "\n")
                              : ""),
                      style: TextStyle(fontSize: 8)),
                ]),
                actions: [
                  okButton,
                ],
              );
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return alerta;
                },
              );
            }
          }),
    ]));
  }

  List<Widget> RetornaWidgetPonto() {
    List<Widget> listaWidget = [];

    for (int i = 0; i < Utilidades.listaImagens.length; i++) {
      if (i == Utilidades.start) {
        listaWidget.add(Expanded(
            child: Container(
                width: 10,
                height: 10,
                child: Image.asset('assets/ponto_escuro.png'))));
      } else {
        listaWidget.add(Expanded(
            child: Container(
                width: 10,
                height: 10,
                child: Image.asset('assets/ponto_claro.png'))));
      }
      listaWidget.add(SizedBox(width: 10));
    }

    return listaWidget;
  }

  Future<void> AtualizaDadosEmpresa() async {
    //ATUALIZA DADOS EMPRESAS
    if (Utilidades.start % 2 == 0) {
      try {
        var dio = Dio();

        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
        };

        String token = Utilidades.token;

        List listaTemporaria = [];

        final response_ = await dio
            .get(
              API.url + '${EndPoints.customer}',
              options: Options(
                headers: {'Authorization': 'Bearer $token'},
              ),
            )
            .timeout(
              Duration(seconds: 8),
            );

        if (response_.statusCode == 401) {
          Widget okButton = TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
          AlertDialog alerta_ = AlertDialog(
            title: Text(""),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  child: Image.asset("assets/alert.png"),
                ),
                SizedBox(height: 20),
                Text(Utilidades.erroTokenInvalido),
              ],
            ),
            actions: [
              okButton,
            ],
          );
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return alerta_;
            },
          );
        }

        for (int i = 0; i < response_.data['data'].length; i++) {
          //##BURGDELIVERY ALTERAÇÃO
          if (response_.data["data"][i]["companyName"].contains("##") ||
              response_.data["data"][i]["companyName"].toString() ==
                  "CompreAqui") {
            listaTemporaria.add(response_.data["data"][i]);
          }
        }
        Utilidades.listaEmpresas = listaTemporaria;
      } catch (Exception) {}
    }
    //FIM ATUALIZA DADOS
  }

  void DismissDirectionCallback(DismissDirection direction) {
    if (direction == DismissDirection.startToEnd ||
        direction == DismissDirection.endToStart ||
        direction == DismissDirection.down ||
        direction == DismissDirection.up ||
        direction == DismissDirection.vertical ||
        direction == DismissDirection.horizontal) {
      processandoMensagemNotificacao = false;
      Navigator.pop(context);
    }
  }

  void DismissDirectionCallbackPropaganda(DismissDirection direction) {
    Utilidades.slidePropaganda = true;
    if (direction == DismissDirection.startToEnd) {
      setState(
        () {
          if (Utilidades.start == 0) {
            Utilidades.start = Utilidades.listaImagens.length - 1;
          } else {
            Utilidades.start = Utilidades.start - 1;
          }
        },
      );
    } else {
      if (direction == DismissDirection.endToStart) {
        setState(
          () {
            if (Utilidades.start == Utilidades.listaImagens.length - 1) {
              Utilidades.start = 0;
            } else {
              Utilidades.start = Utilidades.start + 1;
            }
          },
        );
      }
    }
  }

  Future<bool> NovaMensagem() async {
    bool novaMensagem = false;

    try {
      var dio = Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      String token_ = Utilidades.token;

      Map id = {
        "userId": Utilidades.usuarioLogado.id,
      };
      final responseMessages = await dio
          .post(
            API.url + '${EndPoints.orderNewMessages}',
            data: id,
            options: Options(
              headers: {'Authorization': 'Bearer $token_'},
            ),
          )
          .timeout(
            Duration(seconds: 10),
          );

      if (responseMessages.statusCode == 200) {
        var respostaApi = responseMessages.data['status'];
        if (respostaApi == 200) {
          try {
            novaMensagem = !responseMessages.data["data"][0]['userViewed'];
          } catch (Exception) {}
        }
      }

      //comentar linha abaixo
      //Utilidades.notificacaoNovaMensagem = false;
      if (novaMensagem) {
        Utilidades.novaMensagem = true;
        if (!Utilidades.notificacaoNovaMensagem) {
          //descomentar ->
          Utilidades.notificacaoNovaMensagem = true;

          if (Utilidades.notificarUsuarioNovaMensagem) {
            // _controller = VideoPlayerController.asset('assets/beep.mp4')
            //   ..initialize().then((_) {
            //     _controller.play();
            //     setState(() {});
            //   });

            var containerNotificacao = ListView.builder(
                itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key("chave"),
                direction: DismissDirection.up,
                onDismissed: DismissDirectionCallback,
                child: Container(
                  height: 860,
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Card(
                        child: TextButton(
                          child: Container(
                            color: Colors.white,
                            height: 100,
                            child: Column(children: <Widget>[
                              SizedBox(height: 12),
                              Row(children: <Widget>[
                                SizedBox(width: 25),
                                Container(
                                    width: 18,
                                    height: 18,
                                    child: Image.asset('assets/app-logo.png')),
                                SizedBox(width: 10),
                                Text("CompreAqui",
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 11)),
                                SizedBox(width: 20),
                                Text(
                                    DateTime.now().hour.toString() +
                                        ":" +
                                        (DateTime.now().minute < 10
                                                ? "0" +
                                                    DateTime.now()
                                                        .minute
                                                        .toString()
                                                : DateTime.now()
                                                    .minute
                                                    .toString())
                                            .toString(),
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10)),
                              ]),
                              SizedBox(height: 7),
                              Row(children: <Widget>[
                                SizedBox(width: 25),
                                Container(
                                    child: Text("Você tem uma nova mensagem",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600]))),
                              ]),
                              SizedBox(height: 7),
                              Row(children: <Widget>[
                                SizedBox(width: 25),
                                Container(
                                    child: Text(
                                        "Verifique as mensagens em menu> pedidos> mensagens",
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[400]))),
                              ]),
                              SizedBox(height: 3),
                              Container(
                                  height: 7,
                                  alignment: Alignment.center,
                                  child: Image.asset('assets/slide_up.png')),
                              SizedBox(height: 3),
                            ]),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Pedidos(),
                              ),
                            );
                          },
                        ),
                      )),
                ),
              );
            });

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return containerNotificacao;
              },
            );
          }
          processandoMensagemNotificacao = true;
        }
      } else {
        Utilidades.novaMensagem = false;
      }

      return novaMensagem;
    } catch (Exception) {
      return false;
    }
  }

  List<Widget> RetornaWidgetsEmpresas_(BuildContext context) {
    List<Widget> listaWidget = [];
    try {
      if (Utilidades.listaImagens == null ||
          Utilidades.listaImagens.length == 0) {
        Utilidades.listaImagens = Utilidades.listaImagens;
      }

      //slide lateral
      var containerSlideLateral = Dismissible(
          key: Key(DateTime.now().toString()),
          onDismissed: DismissDirectionCallbackPropaganda,
          direction: DismissDirection.horizontal,
          child: Utilidades.listaImagens[Utilidades.start]);

      //fim slide lateral
      if (Utilidades.listaImagens[Utilidades.start] == null) {
        listaWidget.add(Container(child: Image.asset('assets/app-logo.png')));
      } else {
        listaWidget.add(Container(child: containerSlideLateral));
      }

      if (Utilidades.listaImagens.length < 10) {
        listaWidget.add(SizedBox(height: 10));
        listaWidget.add(Container(
            child: Row(children: <Widget>[
          Expanded(child: Container(child: Text(""))),
          Expanded(
            child: Container(
              child: Align(
                  alignment: Alignment.center,
                  child: Row(children: RetornaWidgetPonto())),
            ),
          ),
          Expanded(child: Container(child: Text(""))),
        ])));
      }

      listaWidget.add(SizedBox(height: 20));
      listaWidget.add(Container(
          color: Colors.white,
          child: Row(children: <Widget>[
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(Utilidades.cidadeUsuario ?? "",
                        style: TextStyle(fontSize: 8, color: Colors.grey)))),
            Expanded(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        width: 12,
                        height: 12,
                        child: Image.asset('assets/location.png'))))
          ])));
      listaWidget.add(SizedBox(height: 20));

      AtualizaDadosEmpresa();

      Empresa compreAqui = new Empresa();

      List<Empresa> listaEmpresas_ = [];
      List<Empresa> listaEmpresasFechadas = [];

      if (Utilidades.listaEmpresas != null) {
        for (int i = 0; i < Utilidades.listaEmpresas.length; i++) {
          var empresaApi = Utilidades.listaEmpresas[i];
          var cidade = empresaApi["addressCity"];
          if (cidade.toString().toUpperCase() ==
              Utilidades.cidadeUsuario?.toUpperCase()) {

              Empresa empresa = new Empresa();

              empresa.nome = empresaApi["companyName"];
              empresa.email = empresaApi["email"];
              empresa.id = empresaApi["id"];
              empresa.imagem = empresaApi["imageUrl"];
              empresa.contato = empresaApi["phonenumber"];

              try {
                int taxa_ = empresaApi["deliveryFee"];
                empresa.taxa = double.parse(taxa_.toString());
              } catch (exception) {
                empresa.taxa = empresaApi["deliveryFee"];
              }

              empresa.aberto = empresaApi["opened"];
              empresa.cartao = empresaApi["creditCard"];
              empresa.entregaFimDoDia = empresaApi["deliveryEndOfDay"];

              try {
                int valorMinimo_ = empresaApi["minimumValue"];
                empresa.valorMinimo = double.parse(valorMinimo_.toString());
              } catch (exception) {
                empresa.valorMinimo = empresaApi["minimumValue"];
              }

              empresa.funcionamento = empresaApi[
                  'businessHours']; //"Horário de funcionamento: segunda-feira a sexta-feira de 08:00 hs às 18:00 hs e sábados de 08:00 hs as 12:00 hs.";

              try {
                empresa.numero = int.parse(empresaApi["addressNumber"]);
                empresa.referencia = empresaApi["addressReference"];
                empresa.rua = empresaApi["addressStreet"];
                empresa.bairro = empresaApi["addressNeighborhood"];
                empresa.cidade = empresaApi["addressCity"];
                empresa.estado = empresaApi["addressState"];
                empresa.complemento = empresaApi["addressComplement"];
              } catch (Exception) {}

            if (empresaApi["opened"]) {
              if (empresa.nome != "CompreAqui") {
                listaEmpresas_.add(empresa);
              } else {
                compreAqui = empresa;
              }
            } else {
              if (empresa.nome != "CompreAqui") {
                listaEmpresasFechadas.add(empresa);
              } else {
                compreAqui = empresa;
              }
            }
          }
        }
      }

      List<Widget> listaDuplas = [];
      for (int i = 0;
          i <
              ((listaEmpresas_.length % 2 == 0)
                  ? listaEmpresas_.length
                  : listaEmpresas_.length + 1);
          i = i + 2) {
        try {
          var container1 = RetornaCardEmpresa(listaEmpresas_[i]);
          var container2 = null;
          var elementoImpar = false;
          try {
            container2 = listaEmpresas_[i + 1] != null
                ? RetornaCardEmpresa(listaEmpresas_[i + 1])
                : Text("");
          } catch (Exception) {
            elementoImpar = true;
            container2 = null; //Text("");
          }

          if (elementoImpar) {
            listaDuplas.add(Container(
                child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              SizedBox(height: 15),
              Card(child: Container(child: container1)),
              SizedBox(height: 15),
            ])));
          } else {
            listaDuplas.add(Container(
                child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              SizedBox(height: 15),
              Expanded(
                child: Card(child: Container(child: container1)),
              ),
              SizedBox(height: 25),
              Expanded(
                child: Card(child: Container(child: container2)),
              ),
              SizedBox(height: 15),
            ])));
          }
        } catch (Exception) {}
      }

      List<Widget> listaFechadas = [];
      for (int i = 0;i < (listaEmpresasFechadas.length); i++) {
        try {
          
          listaFechadas.add(Container(
              //width: 150.0,
              child:Card(child: Container(child: RetornaCardEmpresa(listaEmpresasFechadas[i])))));
        } catch (Exception) {}
      }
      

      listaWidget.add(Container(
          color: Color(0xFFF2F3F6),
          child:
              Column(mainAxisSize: MainAxisSize.min, children: listaDuplas)));

      listaWidget.add(SizedBox(height:20));
      
      listaWidget.add(listaFechadas.length >0? Center(child:
        
      Text("Fechados:", style: GoogleFonts.mcLaren(fontSize: 16,fontWeight: FontWeight.bold))):Text(""));
      
      if(listaFechadas.length == 1){
        listaWidget.add(
        Container(
              child: listaFechadas[0]
              ));
      }
      else{
          listaWidget.add(
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 240.0,
              child: new ListView(
                scrollDirection: Axis.horizontal,
                children: listaFechadas
              )));
      }
      
      if (Utilidades.usuarioLogado.login == "CompreAqui") {
        var containerEmpresaDeTeste = RetornaCardEmpresa(compreAqui);
        listaWidget.add(SizedBox(height: 15));
        listaWidget.add(Container(
            color: Color(0xFFF2F3F6),
            child: Card(child: Container(child: containerEmpresaDeTeste))));
        listaWidget.add(SizedBox(height: 15));
      }

      List<Widget> propagandas = [];
      if (Utilidades.listaEmpresas != null) {
        for (int i = 0; i < Utilidades.listaEmpresas.length; i++) {
          var empresaApi = Utilidades.listaEmpresas[i];
          var cidade = empresaApi["addressCity"];
          if (cidade.toString().toUpperCase() ==
              Utilidades.cidadeUsuario?.toUpperCase()) {
            propagandas.add(Container(
                width: 90.0,
                color: Utilidades.RetornaCorTema(),
                child: Image.network(empresaApi["imageUrl"])));
          }
        }
      }

      if (propagandas.length > 3) {
        listaWidget.add(
          Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 100.0,
              child: new ListView(
                scrollDirection: Axis.horizontal,
                children: propagandas,
              )),
        );
      }
      //comentada a parte que toca o player
      // listaWidget.add(Container(
      //   width: 0,
      //   height: 0,
      //   child: Center(
      //     child: _controller.value.initialized
      //         ? AspectRatio(
      //             aspectRatio: _controller.value.aspectRatio,
      //             child: VideoPlayer(_controller),
      //           )
      //         : Container(),
      //   ),
      // ));

      if (Utilidades.apresentacaoChat) {
        //if(!processandoMensagemNotificacao){
        //if (Utilidades.start % 2 != 0) {
        NovaMensagem();
        //}
        //}
      }
    } catch (Exception) {}

    return listaWidget;
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 25);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => Utilidades.timerScreen
          ? setState(
              () {
                if (!Utilidades.slidePropaganda) {
                  if (Utilidades.start == Utilidades.listaImagens.length - 1) {
                    Utilidades.start = 0;
                  } else {
                    Utilidades.start = Utilidades.start + 1;
                  }
                } else {
                  Utilidades.slidePropaganda = false;
                }
              },
            )
          : null,
    );
  }

  @override
  void initState() {
    super.initState();
    Utilidades.pageScreenAberta = true;
    // _controller = VideoPlayerController.asset('assets/beep.mp4')
    //   ..initialize().then((_) {
    //     setState(() {});
    //   });

    try {
      startTimer();
    } catch (Exception) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void onResume() {}

  @override
  Widget build(BuildContext context) {
    var corpoPage;
    try {
      corpoPage = WillPopScope(
          onWillPop: () {
            //processandoMensagemNotificacao = false;
            return Future.value(false);
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Utilidades.RetornaCorTema(),
              title: Center(
                  child: Text('Início             ',
                      style: TextStyle(color: Colors.black))),
              leading: GestureDetector(
                onTap: widget.onTap.call(),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: ((Utilidades.usuarioLogado.cidade == null ||
                                Utilidades.usuarioLogado.cidade == "" ||
                                Utilidades.novaMensagem)
                            ? AssetImage("assets/perfil_notificacao.png")
                            : AssetImage("assets/perfil.png"))),
                  ),
                ),
              ),
            ),
            body: GestureDetector(
              onTap: widget.onTap2.call(),
              child: Container(
                  color: Color(0xFFF2F3F6),
                  child: ListView(children: RetornaWidgetsEmpresas_(context))),
            ),
          ));
    } catch (Exception) {}
    return corpoPage;
  }
}
