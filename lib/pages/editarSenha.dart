import 'dart:convert';
import 'dart:io';
import 'package:goshare/Utilidades/Utilidades.dart';
import 'package:goshare/Utilidades/endpoinst.dart';
import 'package:goshare/Utilidades/settings.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class EdicaoSenhaState extends State<EdicaoSenha> {
  var controladorSenha = TextEditingController();
  var controladorSenhaConfirmacao = TextEditingController();
  var controladorSenhaAntiga = TextEditingController();

  void EdicaoSenha() {
    setState(() async {
      if (controladorSenha.text.contains("|")) {
        Widget okButton = TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
        AlertDialog alerta = AlertDialog(
          title: Text(""),
          content: Text("Caracteres inválidos para o campo de senha!"),
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
        if (controladorSenha.text != "" &&
            controladorSenhaAntiga.text != "" &&
            controladorSenhaConfirmacao.text != "") {
          if (controladorSenha.text == controladorSenhaConfirmacao.text) {
            if (controladorSenha.text != controladorSenhaAntiga.text) {
              if (controladorSenhaAntiga.text ==
                  Utilidades.usuarioLogado.senha) {
                try {
                  var dio = Dio();
                  (dio.httpClientAdapter as DefaultHttpClientAdapter)
                      .onHttpClientCreate = (HttpClient client) {
                    client.badCertificateCallback =
                        (X509Certificate cert, String host, int port) => true;
                    return client;
                  };

                  var tryurl = '${API.url}${EndPoints.userChangePassword}';
                  HttpClient certificado = new HttpClient()
                    ..badCertificateCallback =
                        ((X509Certificate cert, String host, int port) => true);
                  IOClient ioClient = new IOClient(certificado);

                  Map usuario = {
                    //"oldPassword": controladorSenhaAntiga.text,
                    "guid": Utilidades.usuarioLogado.guid.toString(),
                    "password": controladorSenha.text
                  };

                  AlertDialog alerta = AlertDialog(
                    title: Text("Salvando..."),
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

                  var _body = jsonEncode(usuario);

                  var token = Utilidades.token;

                  var response;
                  try {
                    response = await dio
                        .put(
                          tryurl,
                          data: _body,
                          options: Options(
                            headers: {'Authorization': 'Bearer $token'},
                          ),
                        )
                        .timeout(
                          Duration(seconds: 10),
                        );
                    Utilidades.usuarioLogado.senha = controladorSenha.text;
                    Navigator.of(context).pop();
                  } catch (Exception) {
                    Navigator.of(context).pop();
                  }

                  if (response.statusCode == 200) {
                    var responseApi = response.data;
                    if (responseApi['status'] == 200) {
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
                              width: 50,
                              height: 50,
                              child: Image.asset("assets/ok.png"),
                            ),
                            SizedBox(height: 20),
                            Text("Senha alterada com sucesso!"),
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
                      if (responseApi['status'] == 403) {
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
                              Text("Falha ao alterar a senha."),
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
                              Text("Falha ao efetuar edição."),
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
                          Text("Falha ao efetuar edição."),
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
                } catch (Exception) {
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
                        Text("Falha ao efetuar cadastro."+(Exception.toString().contains("Http status error [401]") ? Utilidades.erroTokenInvalido: "" )),
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
                      Text("Senha antiga incorreta."),
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
                    Text("A senha atual não pode ser igual a nova senha."),
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
                  Text("As senha não conferem."),
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
                Text("Campos de preenchimento obrigatório inválidos."),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utilidades.RetornaCorTema(),
        title: Center(
          child: Text('Edição de senha      ',
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
        padding: EdgeInsets.only(top: 10, left: 40, right: 40),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              controller: controladorSenhaAntiga,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha atual:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              controller: controladorSenha,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Nova senha:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              controller: controladorSenhaConfirmacao,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirmação de nova senha:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
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
                    "Salvar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: EdicaoSenha,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class EdicaoSenha extends StatefulWidget {
  var newTaskCtrl = TextEditingController();

  @override
  EdicaoSenhaState createState() => EdicaoSenhaState();
}
