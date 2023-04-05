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

class Avaliacao extends StatefulWidget {
  @override
  AvaliacaoState createState() => new AvaliacaoState();
}

class AvaliacaoState extends State<Avaliacao> {

  Future EnviarAvaliacao(BuildContext context) async {
    bool enviado = false;
        
      try {
        var dio = Dio();
          (dio.httpClientAdapter as DefaultHttpClientAdapter)
              .onHttpClientCreate = (HttpClient client) {
            client.badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
            return client;
          };
          var tryurl = '${API.url}${EndPoints.userUpdateUser}';
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

          Map usuario = {
            "guid": Utilidades.usuarioLogado.guid,
            "userName": Utilidades.usuarioLogado.login,
            "email": Utilidades.usuarioLogado.email,
            "firstName": Utilidades.usuarioLogado.nome,
            "rating": Utilidades.valorAvaliacao,
            "phoneNumber": Utilidades.usuarioLogado.telefone
          };

          var _body = jsonEncode(usuario);

          var response;
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
            }
            else{
              enviado = false;
            }
          } else {
            enviado = false;
          }
          
      } catch (Exception) {
        enviado = false;
      }
    // } else {
    //   enviado = false;
    // }
    
    if (enviado) {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
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
                      Text("Avaliação enviada com sucesso. Agradecemos o feedback!"),
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
    } else {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      AlertDialog alerta = AlertDialog(
        title: Text(""),
        content: 
        Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 80,
                        child: Image.asset("assets/alert.png"),
                      ),
                      SizedBox(height: 20),
                      Text("Erro ao enviar avaliação"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utilidades.RetornaCorTema(),
        title: Center(
          child: Text('Avaliação          ',
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
              Navigator.of(context).pop();
            }, child: Container(),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 60, left: 40, right: 40),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 128,
              height: 128,
              child: Image.asset("assets/logo.png"),
            ),
            SizedBox(
              height: 20,
            ),
            Center(child:Container(child: Center(child: Text("Avalie nosso App.")))),
            SizedBox(height: 20),
            Center(child:Container(child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>
                [
                  Expanded(child:TextButton(child: Container(width:35,height:35,child:Image.asset('assets/avaliacao'+((Utilidades.valorAvaliacao < 1) ?'_.png': '.png'))), onPressed: (){Utilidades.valorAvaliacao = 1; setState(() {});},)),
                  Expanded(child:TextButton(child: Container(width:35,height:35,child:Image.asset('assets/avaliacao'+((Utilidades.valorAvaliacao < 2) ?'_.png': '.png'))), onPressed: (){Utilidades.valorAvaliacao = 2; setState(() {});},)),
                  Expanded(child:TextButton(child: Container(width:35,height:35,child:Image.asset('assets/avaliacao'+((Utilidades.valorAvaliacao < 3) ?'_.png': '.png'))), onPressed: (){Utilidades.valorAvaliacao = 3; setState(() {});},)),
                  Expanded(child:TextButton(child: Container(width:35,height:35,child:Image.asset('assets/avaliacao'+((Utilidades.valorAvaliacao < 4) ?'_.png': '.png'))), onPressed: (){Utilidades.valorAvaliacao = 4; setState(() {});},)),
                  Expanded(child:TextButton(child: Container(width:35,height:35,child:Image.asset('assets/avaliacao'+((Utilidades.valorAvaliacao < 5) ?'_.png': '.png'))), onPressed: (){Utilidades.valorAvaliacao = 5; setState(() {});},)),
                ],
              ),
            ),
            ),
            SizedBox(height: 20),          
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
                        child:
                        Text(
                          "Enviar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ),
                    onPressed: () {
                      EnviarAvaliacao(context);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}