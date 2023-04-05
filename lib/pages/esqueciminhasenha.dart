import 'dart:convert';
import 'dart:io';
import 'package:goshare/Utilidades/Utilidades.dart';
import 'package:goshare/Utilidades/endpoinst.dart';
import 'package:goshare/Utilidades/mailer/smtp_server/gmail.dart';
import 'package:goshare/Utilidades/mailer/src/entities/address.dart';
import 'package:goshare/Utilidades/mailer/src/entities/message.dart';
import 'package:goshare/Utilidades/mailer/src/smtp/mail_sender.dart';
import 'package:goshare/Utilidades/settings.dart';
import 'package:goshare/models/novoUsuarioSenhaEmail.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';

class EsqueciMinhaSenha extends StatelessWidget {
  var controladorEmail = TextEditingController();

  Future<void> EnviarEmailViaFlutter(String destinatario) async {
    try{
      final smtpServer = gmail('compreaquiaplicativo@gmail.com', '****');
      final message = Message()
      ..from = Address('compreaquiaplicativo@gmail.com', '****')
      ..recipients.add(destinatario)
      ..subject = 'Título'..text = ''
      ..html =  "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";
      var connection = PersistentConnection(smtpServer);
      
      //comentado para atualização flutter v2
      ////await connection.send(message);
      await connection.close();
    }
    catch(Exception){
    }
  }

  String RetornaStringTextoEmail(String user, String password){
    return " <p><h1 style=\"background - color:DodgerBlue;\"><b> GoShare </b></h1></p> " +
      "<img src=\"https://www.eshopex.com/br/assets/img/icons/eshopex-compra.png\"> " +
      "<p> Usuário: <b> "+user+"</b></p>" +
      "<p> Sua nova senha é: <b> "+password+"</b></p>" +
      "<p> Se desejar, você pode mudá-la no aplicativo! </p>";
  }

  Future EnviarEmail(BuildContext context) async {
    bool enviado = false;
    // var con = await SettingsBlock().testaConexaoInternet();
    // if (con == 1) {
      try {
        var dio = Dio();
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
        AlertDialog alerta = AlertDialog(
          title: Text("Enviando..."),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                child: FlareActor(
                  "assets/loading_laranja_sacola.flr",
                  animation: "loading",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        );
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return alerta;
          },
        );
        
        // HttpClient certificado = new HttpClient()
        //       ..badCertificateCallback =
        //           ((X509Certificate cert, String host, int port) => true);
        // IOClient ioClient = new IOClient(certificado);
        
        var parametro = {
              "email": controladorEmail.text
            };
            
        var _body = jsonEncode(parametro);

        var response_ = await dio
            .post(
              API.url + '${EndPoints.userResetPassword}',
              data: _body
            )
            .timeout(
              Duration(seconds: 15),
            );
       
        if (response_.statusCode == 200) {
          if (response_.data['status'] == 200) {
 
            //EnviarEmailViaFlutter(controladorEmail.text);
          
            //enviar email 
            // String messageUserEmail = response_.data['message'];
            // var novoUsuarioSenhaEmail = jsonDecode(messageUserEmail);
            // try{
            //   final smtpServer = gmail(Utilidades.emailCompreAqui, Utilidades.senhaCompreAqui);
            //   final message = Message()
            //   ..from = Address(Utilidades.emailCompreAqui, 'CompreAqui')
            //   ..recipients.add(controladorEmail.text)
            //   ..subject = 'CompreAqui - Recuperação de senha!'..text = ''
            //   ..html =  RetornaStringTextoEmail(novoUsuarioSenhaEmail['usuario'], novoUsuarioSenhaEmail['senha']);
            //   var connection = PersistentConnection(smtpServer);
              
            //   //comentado para atualização flutter v2 
            //   ////await connection.send(message);
            //   await connection.close();
              enviado = true;
            // }
            // catch(Exception){
            //   enviado = false;
            // }
          } else {
          enviado = false;
          }
        } else {
          enviado = false;
        }
        Navigator.pop(context);
      } catch (Exception) {
        enviado = false;
        Navigator.pop(context);
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
            Text(
                "E-mail de recuperação de senha encaminhado. Aguarde o recebimento do e-mail para verificar sua nova senha."),
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              child: Image.asset("assets/alert.png"),
            ),
            SizedBox(height: 20),
            Text(
                "Erro ao enviar E-mail de recuperação de senha! Verifique se o e-mail digitado está correto.\n\nSe o erro persistir, contate-nos em compreaquiaplicativo@gmail.com que te enviaremos uma nova senha!"),
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
          child: Text('Esqueci minha senha     ',
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
            TextFormField(
              controller: controladorEmail,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: "Informe o e-mail de recuperação:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w200,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 40,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Enviar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          child: SizedBox(
                            height: 28,
                            width: 28,
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      if (controladorEmail.text != "") {
                        EnviarEmail(context);
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
                              Text("Campo de preenchimento obrigatório."),
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
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
