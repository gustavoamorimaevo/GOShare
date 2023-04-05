import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:goshare/Utilidades/Utilidades.dart';
import 'package:goshare/Utilidades/block.settings.dart';
import 'package:goshare/Utilidades/endpoinst.dart';
import 'package:goshare/Utilidades/settings.dart';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


int? idPedido;

class Chat extends StatefulWidget {

  int? idPedidoTemp;
  Chat({Key? key, this.idPedidoTemp}) : super(key: key) {
    idPedido = idPedidoTemp;
  }
  
  @override
  ChatState createState() => new ChatState();
}

class ChatState extends State<Chat> {
  bool processamento = false;
  bool processaEnvio = false;
  var controladorMensagem = TextEditingController();
  Timer? _timer;
  var mensagemWait = "";

  List<String> RetornaListaMensagens() {
    try {
      List<String> listaMensagensRetorno = [];

      if (Utilidades.mensagensPedidoTemp != null &&
          Utilidades.mensagensPedidoTemp != "") {
        var listaMensagens = Utilidades.mensagensPedidoTemp.split("##");

        listaMensagens.removeAt(0);

        for (int i = 0; i < listaMensagens.length; i++) {
          listaMensagensRetorno.add(listaMensagens[i]);
        }
      }

      return listaMensagensRetorno;
    } catch (Exception) {
      return [];
    }
  }

  Widget RetornaWidgetMensagens() {
    try {
      List<Widget> listaWidget = [];

      var listaMensagens = RetornaListaMensagens();
      
      listaWidget.add(Container(child: Card(color: Colors.white, child: Center(child: Text("...")))));
      
      for (int i = (listaMensagens.length > 10 ? listaMensagens.length -10 : 0); i < listaMensagens.length; i++) {
        listaWidget.add(cardMensagem(listaMensagens[i]));
      }
      
      return Container(child: Column(children: listaWidget));
    } catch (Exception) {
      return Container();
    }
  }

  Future EnviarMensagem(BuildContext context) async {
    bool enviado = false;
    processaEnvio = true;
    bool tempoConexaoExcedido = false;
    var response;
        
      try {
        var dio = Dio();
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };

        var tryurl = '${API.url}${EndPoints.orderUpdateMessage}';
        HttpClient certificado = new HttpClient()
          ..badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);

        Widget okButton = TextButton(
          child: Text(""),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
        AlertDialog alerta = AlertDialog(
          title: Text("Enviando..."),
          content: 
          Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          child: FlareActor(
                            "assets/loading_laranja_sacola.flr",
                            animation: "loading",
                            fit: BoxFit.contain,
                          ),
                        ),
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

        Map mensagem = {
          "Message": "##" + "USUÁRIO>> " +controladorMensagem.text.replaceAll("##", "") + "||"+DateTime.now().hour.toString()+":"+((DateTime.now().minute < 10) ? "0" + DateTime.now().minute.toString() : DateTime.now().minute.toString()),//(Utilidades.mensagensPedidoTemp == null ? "" : Utilidades.mensagensPedidoTemp) + "##" + "USUÁRIO>> " +controladorMensagem.text.replaceAll("##", ""),
          "Id": idPedido,
        };

        var _body = jsonEncode(mensagem);

        try {
          var token = Utilidades.token;
          response = await dio
              .put(
                tryurl,
                data: _body,
                options: Options(
                  headers: {'Authorization': 'Bearer $token'},
                ),
              )
              .timeout(
                Duration(seconds: 9),
              );
          Navigator.of(context).pop();
        } catch (Exception) {
          Navigator.of(context).pop();
        }

        if (response.statusCode == 200) {
          var responseApi = response.data;
          if (responseApi['status'] == 200) {
            enviado = true;
          } else {
            enviado = false;
          }
        } else {
          enviado = false;
        }
      } catch (Exception) {
        if(Exception.toString().contains("Http status error [401]")){
          tempoConexaoExcedido = true;
        }
        else{
          tempoConexaoExcedido = false;
        }
        enviado = false;
      }

    if (enviado) {
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
              child: Image.asset("assets/ok.png"),
            ),
            SizedBox(height: 20),
            Text("Mensagem enviada."),
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
      
      if(Utilidades.mensagensPedidoTemp == null){
        Utilidades.mensagensPedidoTemp = "";
      }

      Utilidades.mensagensPedidoTemp += "##" + "USUÁRIO>> " + controladorMensagem.text.replaceAll("##", "");
      controladorMensagem.text = "";
      
      processaEnvio = false;

      RecebeMensagem();

      setState((){});
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
            Text("Erro ao enviar mensagem" +(tempoConexaoExcedido ? "\n"+Utilidades.erroTokenInvalido: "")),
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
    processaEnvio = false;
  }

  Future<void> RecebeMensagem() async {
    try {
      if (!processaEnvio) {
        mensagemWait = "atualizando mensagens...";
        
        var dio = Dio();
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };

        Map id = {
          "Id": idPedido,
        };

        String token_ = Utilidades.token;

        final responseMessages = await dio
            .post(
              API.url + '${EndPoints.orderMessage}',
              data: id,
              options: Options(
                headers: {'Authorization': 'Bearer $token_'},
              ),
            )
            .timeout(
              Duration(seconds: 7),
            );
        
        String textoMensagem = "";
        
        if (responseMessages.statusCode == 200) {
          var respostaApi = responseMessages.data['status'];
          if (respostaApi == 200) {
            try {
              textoMensagem = responseMessages.data["data"][0]['message'];
            } catch (Exception) {
            }
          }
        }
        
        if(Utilidades.mensagensPedidoTemp == null){
          Utilidades.mensagensPedidoTemp = "";
        }
        Utilidades.mensagensPedidoTemp = textoMensagem;
        
        mensagemWait = "";
        
        
        AtualizaComMensagemLida();

        setState(() {});
      }
    } catch (Exception) {
      Utilidades.consultaPedidos = true;
      setState(() {});
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 20);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              RecebeMensagem();
            }));
  }
    
  Future<void> AtualizaComMensagemLida() async {
    try{
      var dio = Dio();
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };

        Map body = {
          "Id": idPedido,
          "UserViewed": true
        };

        String token_ = Utilidades.token;

        final responseMessages = await dio
            .put(
              API.url + '${EndPoints.orderUpdateUserViewed}',//'api/Order/Update/userviewed',
              data: body,
              options: Options(
                headers: {'Authorization': 'Bearer $token_'},
              ),
            )
            .timeout(
              Duration(seconds: 8),
            );
    }
    catch(Exception){

    }
  }

  @override
  void initState() {
    super.initState();
    try {
      Utilidades.notificacaoNovaMensagem = false;
      AtualizaComMensagemLida();
      startTimer();
      Utilidades.mensagensPedidoTemp = "";
      RecebeMensagem();
    } catch (Exception) {}
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () {
          _timer?.cancel();
          Navigator.pop(context);
          return Future<bool>(() => false);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Utilidades.RetornaCorTema(),
            title: Center(
              child: Text('Chat - Pedido '+idPedido.toString(),
                  style: TextStyle(color: Colors.black)),
            ),
            leading: Container(
              height: 40,
              width: 40,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: AssetImage("assets/esquerda.png"),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: TextButton(
                onPressed: () {
                  _timer?.cancel();
                  Navigator.of(context).pop();
                }, child: Container(),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (!processamento) {
                RecebeMensagem();
              }
            },
            child: Icon(Icons.refresh, color: Colors.black),
            backgroundColor: Utilidades.RetornaCorTema(),
          ),
          body: Container(
            padding: EdgeInsets.only(top: 60, left: 40, right: 40),
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: controladorMensagem,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Digite aqui sua mensagem",
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w200,
                      fontSize: 18,
                    ),
                  ),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.3, 1],
                      colors: [
                        Utilidades.RetornaCorTemaBotaoGradiente1(),
                        Utilidades.RetornaCorTemaBotaoGradiente2(),
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: SizedBox.expand(
                    child: TextButton(
                        child: Text(
                          "Enviar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: processamento
                            ? null
                            : () {
                                if (processamento == false) {
                                  EnviarMensagem(context);
                                }
                              }),
                  ),
                ),
                SizedBox(height: 20),
                Container(child: Center(child:Text(mensagemWait,style: TextStyle(fontSize: 12)))),
                SizedBox(height: 20),
                Container(child: RetornaWidgetMensagens()),
              ],
            ),
          ),
        ));
  }
}

Widget cardMensagem(String mensagem) {
  try {
    return Card(
      color: mensagem.contains("USUÁRIO>>") ? Colors.white : Colors.grey[100],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Expanded(
              //child: 
              Container(
            alignment: Alignment.centerLeft,
            child: Row(children: <Widget>[
               Container(
                      child: Text(mensagem.split("||")[1],style: TextStyle(fontSize: 7,color: Colors.grey))),
              //Expanded(
                  //child: 
                  Container(
                      child: Text(mensagem.contains("USUÁRIO>>") ? "USUÁRIO>>" : "EMPRESA>>",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold,color: mensagem.contains("USUÁRIO>>") ? Colors.green : Colors.grey))),
                          //),
              Expanded(
                  child: 
                  Container(
                      child: Text(mensagem.split("||")[0].replaceAll("USUÁRIO>>", "").replaceAll("EMPRESA>>", ""),
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[500]))),
                              ),
            ]),
          ),
          //),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  } catch (Exception) {
    return Text("");
  }
}
