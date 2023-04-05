import 'dart:convert';
import 'dart:io';
import 'package:goshare/Utilidades/Utilidades.dart';
import 'package:goshare/Utilidades/block.settings.dart';
import 'package:goshare/Utilidades/endpoinst.dart';
import 'package:goshare/Utilidades/settings.dart';
import 'package:goshare/pages/aceitacaotermosdeuso.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goshare/Utilidades/notifications/flutter_local_notifications.dart';


class _MyHomePageState extends State<SignupPage> {
  var controladorUsuario = TextEditingController();
  var controladorNome = TextEditingController();
  var controladorSenha = TextEditingController();
  var controladorEmail = TextEditingController();
  var controladorTelefone = TextEditingController();
  var controladorCidade = TextEditingController();
  var controladorBairro = TextEditingController();
  var controladorRua = TextEditingController();
  var controladorNumero = TextEditingController();
  var controladorComplemento = TextEditingController();
  var controladorReferencia = TextEditingController();
  String nomeCidade = "";
  var _cidades = [
    "Manhuaçu",
    "Manhumirim",
    "Alto Caparaó",
    "Caparaó",
    "Alto Jequitibá",
    "Reduto",
    "Realeza",
    "Martins Soares"
  ];
  String? _itemSelecionado = 'Manhumirim';

  void Cadastro() {
    setState(() async {
      if (controladorUsuario.text.toUpperCase().contains("DROP") ||
          controladorUsuario.text.toUpperCase().contains("DELETE") ||
          controladorUsuario.text.contains("|") ||
          controladorUsuario.text.contains("'") ||
          controladorUsuario.text.contains("\"") ||
          controladorUsuario.text.contains("@")) {
        Widget okButton = TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
        AlertDialog alerta = AlertDialog(
          title: Text(""),
          content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Container(
              width: 50,
              height: 50,
              child: Image.asset("assets/alert.png"),
            ),
            SizedBox(height: 20),
            Text("Caracteres inválidos para o campo de usuário!"),
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
      } else {
        if (controladorUsuario.text.contains(" ")) {
          Widget okButton = TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
          AlertDialog alerta = AlertDialog(
            title: Text(""),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                width: 50,
                height: 50,
                child: Image.asset("assets/alert.png"),
              ),
              SizedBox(height: 20),
              Text("O campo de usuário não pode conter espaços em branco."),
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
        } else {
          if (controladorEmail.text != "" &&
              controladorUsuario.text != "" &&
              controladorSenha.text != "") {
            if (Utilidades.RetornaEmailValido(controladorEmail.text)) {
              try {
                var resposta = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AceitacaoTermosUso(),
                  ),
                );
                if (resposta == "Sim") {
                  var dio = Dio();
                  (dio.httpClientAdapter as DefaultHttpClientAdapter)
                      .onHttpClientCreate = (HttpClient client) {
                    client.badCertificateCallback =
                        (X509Certificate cert, String host, int port) => true;
                    return client;
                  };

                  var tryurl = '${API.url}${EndPoints.userAdd}';
                  HttpClient certificado = new HttpClient()
                    ..badCertificateCallback =
                        ((X509Certificate cert, String host, int port) => true);
                  IOClient ioClient = new IOClient(certificado);

                  Map usuario = {
                    "UserName": controladorUsuario.text.trim(),
                    "Email": controladorEmail.text,
                    "Password": controladorSenha.text
                  };

                  Widget okButton = TextButton(
                    child: Text(""),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                  AlertDialog alerta = AlertDialog(
                    title: Text("Carregando..."),
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

                  var _body = jsonEncode(usuario);

                  var response;
                  
                  try {
                    response = await dio
                        .post(
                          '${API.url}${EndPoints.userAdd}',
                          
                          data: _body,
                          options: Options(
                            headers: {'Content-Type': 'application/json'},
                          ),
                        )
                        .timeout(
                          Duration(seconds: 25),
                        );
                    Navigator.of(context).pop();
                  } catch (Exception) {
                    Navigator.of(context).pop();
                  }

                  if (response == null) {
                    //RETORNO NULL > RESPOSTA PARA USUARIO OU EMAIL EXISTENTE (TRATAR ESTE CASO)
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
                            child: Image.asset("assets/alert.png"),
                          ),
                          SizedBox(height: 20),
                          Text(
                              "Falha ao efetuar cadastro"),
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
                    if (response.statusCode == 200) {
                      var responseApi = response.data;
                      if (responseApi['status'] == 201) {
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
                              Text(
                                  "Cadastro realizado com sucesso!"), //Container(child: LinearProgressIndicator(),),
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
                                Text(
                                    //"Usuário ou e-mail já existente."
                                    "Usuário ou e-mail já existente. Se esqueceu a senha clique em esqueci minha senha na página de login que enviaremos um e-mail com a nova senha."
                                    ), //Container(child: LinearProgressIndicator(),),
                              ],
                            ),
                            //Text("Usuário ou e-mail já existente."),
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
                                Text("Falha ao efetuar cadastro."),
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
                            Text(
                                "Falha ao efetuar cadastro."), //Container(child: LinearProgressIndicator(),),
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
                      Text(
                          "Falha ao efetuar cadastro."), //Container(child: LinearProgressIndicator(),),
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
                    Text("E-mail inválido."),
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
                  Text(
                      "Campos de preenchimento obrigatório inválidos."), //Container(child: LinearProgressIndicator(),),
                ],
              ), //Text("Campos de preenchimento obrigatório inválidos."),
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
      }
    });
  }

  criaDropDownButton() {
    return Container(
      child: DropdownButton<String>(
        items: _cidades.map((String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(dropDownStringItem),
          );
        }).toList(),
        onChanged: (String? novoItemSelecionado) {
          _dropDownItemSelected(novoItemSelecionado);
          setState(() {
            this._itemSelecionado = novoItemSelecionado;
          });
        },
        value: _itemSelecionado,
      ),
    );
  }

  void _dropDownItemSelected(String? novoItem) {
    setState(() {
      this._itemSelecionado = novoItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utilidades.RetornaCorTema(),
        title: Center(
          child:
              Text('Cadastro          ', style: TextStyle(color: Colors.black)),
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
                LengthLimitingTextInputFormatter(30),
              ],
              controller: controladorUsuario,
              // autofocus: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Usuário:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],
              controller: controladorEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "E-mail:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(
                fontSize: 15,
              ),
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
                labelText: "Senha:",
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
                    "Cadastrar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: Cadastro,
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

class SignupPage extends StatefulWidget {
  var newTaskCtrl = TextEditingController();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
