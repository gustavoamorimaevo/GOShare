import 'dart:convert';
import 'dart:io';
import 'package:goshare/Utilidades/Utilidades.dart';
import 'package:goshare/Utilidades/block.settings.dart';
import 'package:goshare/Utilidades/endpoinst.dart';
import 'package:goshare/Utilidades/settings.dart';
import 'package:goshare/models/usuario.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class _MyHomePageEditState extends State<SignupPageEdit> {
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
  var controladorEstado = TextEditingController();
  var controladorCidadeSegundoEndereco = TextEditingController();
  var controladorBairroSegundoEndereco = TextEditingController();
  var controladorRuaSegundoEndereco = TextEditingController();
  var controladorNumeroSegundoEndereco = TextEditingController();
  var controladorComplementoSegundoEndereco = TextEditingController();
  var controladorReferenciaSegundoEndereco = TextEditingController();
  var controladorEstadoSegundoEndereco = TextEditingController();
  var controladorCEP = TextEditingController();
  var controladorCEPSegundoEndereco = TextEditingController();
  var controladorDistrito = TextEditingController();
  var controladorDistritoSegundoEndereco = TextEditingController();

  Future<void> Cadastro() async {
    //setState(() async {
      if (controladorNome.text != "" &&
          controladorEmail.text != "" &&
          controladorUsuario.text != "" &&
          controladorSenha.text != "" &&
          controladorTelefone.text != "") {
        if (Utilidades.RetornaEmailValido(controladorEmail.text)) {
          if (controladorUsuario.text.contains("'") ||
              controladorUsuario.text.contains("\"") ||
              controladorUsuario.text.toUpperCase().contains("DROP") ||
              controladorUsuario.text.toUpperCase().contains("DELETE") ||
              controladorUsuario.text.contains("@")) {
            Widget okButton = TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
            AlertDialog alerta = AlertDialog(
              title: Text(""),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  child: Image.asset("assets/alert.png"),
                ),
                SizedBox(height: 20),
                Text("Caracteres inválidos para o campo de usuário."),
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
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
                  title: Text("Carregando..."),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
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

                Map usuario = {
                  "guid": Utilidades.usuarioLogado.guid,
                  "userName": controladorUsuario.text,
                  "email": controladorEmail.text,
                  "firstName": controladorNome.text,
                  "phoneNumber": controladorTelefone.text,
                  "rating": Utilidades.usuarioLogado.avaliacao
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
                        Duration(seconds: 15),
                      );
                  Navigator.of(context).pop();
                } catch (Exception) {
                  Navigator.of(context).pop();

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
                            "Usuário ou e-mail existentes. Tente outro usuário ou e-mail."),
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

                if (response.statusCode == 200) {
                  var responseApi = response.data;
                  if (responseApi['status'] == 200) {

                    Utilidades.usuarioLogado.login = controladorUsuario.text;
                    Utilidades.usuarioLogado.email = controladorEmail.text;
                    Utilidades.usuarioLogado.nome = controladorNome.text;
                    Utilidades.usuarioLogado.telefone = controladorTelefone.text;
                    
                    //InsereDadosFormularioSessao();
                    Utilidades.tempUsuariopEdicaoUsuario = controladorUsuario.text;
                    Utilidades.tempUsuarioEdicaoNome = controladorNome.text;
                    Utilidades.tempUsuarioEdicaoEmail = controladorEmail.text;
                    Utilidades.tempUsuarioEdicaoTelefone = controladorTelefone.text;

                    Widget okButton = TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState((){});
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
                            Text("Usuário editado com sucesso!"),
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
                  else{
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
                            Text("Usuário ou e-mail já existente."),
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
    //});
  }

  Future<void> CadastroEndereco() async {
    //setState(() async {
      if (_itemSelecionado != "" &&
          controladorBairro.text != "" &&
          controladorRua.text != "" &&
          controladorNumero.text != "" &&
          _itemSelecionadoEstado != "") {
        if (Utilidades.RetornaNumeroValido(controladorNumero.text)) {
          bool edicaoInsercaoEndereco1 = false;

          var dio = Dio();
          (dio.httpClientAdapter as DefaultHttpClientAdapter)
              .onHttpClientCreate = (HttpClient client) {
            client.badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
            return client;
          };
          try {
            var token = Utilidades.token;

            //INSERT OU UPDATE ENDEREÇO 1
            if (Utilidades.usuarioLogado.cidade == "" ||
                Utilidades.usuarioLogado.cidade == null) {
              //endpoint insert
              Map endereco1 = {
                "userId": Utilidades.usuarioLogado.id,
                "mainAddress": true,
                "zipCode": controladorCEP.text,
                "district": controladorDistrito.text.replaceAll("'",""),
                "street": controladorRua.text.replaceAll("'",""),
                "neighborhood": controladorBairro.text.replaceAll("'",""),
                "number": controladorNumero.text.replaceAll(".", "").replaceAll("-", ""),
                "reference": controladorReferencia.text.replaceAll("'",""),
                "complement": controladorComplemento.text.replaceAll("'",""),
                "city": _itemSelecionado,
                "state": _itemSelecionadoEstado,
              };

              var _body = jsonEncode(endereco1);

              var responseInsertEndereco = await dio
                  .post(
                    '${API.url}${EndPoints.userAddressAdd}',
                    data: _body,
                    options: Options(
                      headers: {'Authorization': 'Bearer $token'},
                    ),
                  )
                  .timeout(
                    Duration(seconds: 15),
                  );

              if (responseInsertEndereco.statusCode == 200) {
                var responseInsertEnderecoApi = responseInsertEndereco.data;
                if (responseInsertEnderecoApi['status'] == 201) {
                  Utilidades.usuarioLogado.cep = controladorCEP.text;
                  Utilidades.usuarioLogado.distrito = controladorDistrito.text;
                  Utilidades.usuarioLogado.rua = controladorRua.text;
                  Utilidades.usuarioLogado.bairro = controladorBairro.text;
                  Utilidades.usuarioLogado.numero = int.parse(controladorNumero.text.toString().replaceAll(".", "").replaceAll(",", "").replaceAll("-", ""));
                  Utilidades.usuarioLogado.referencia =controladorReferencia.text;
                  Utilidades.usuarioLogado.complemento =controladorComplemento.text;
                  Utilidades.usuarioLogado.cidade = _itemSelecionado;
                  Utilidades.usuarioLogado.estado = _itemSelecionadoEstado;
                  Utilidades.usuarioLogado.idEndereco1 = responseInsertEnderecoApi['data'];

                  //InsereDadosFormularioSessao();
                  Utilidades.tempUsuarioEdicaoCidade = _itemSelecionado ?? "";
                  Utilidades.tempUsuarioEdicaoEstado = _itemSelecionadoEstado;
                  Utilidades.tempUsuarioEdicaoBairro = controladorBairro.text;
                  Utilidades.tempUsuarioEdicaoRua = controladorRua.text;
                  Utilidades.tempUsuarioEdicaoNumero = controladorNumero.text.replaceAll(".", "").replaceAll("-", "");
                  Utilidades.tempUsuarioEdicaoComplemento = controladorComplemento.text;
                  Utilidades.tempUsuarioEdicaoReferencia = controladorReferencia.text;
                  Utilidades.tempUsuarioEdicaoCep = controladorCEP.text;
                  Utilidades.tempUsuarioEdicaoDistrito = controladorDistrito.text;
    
                  edicaoInsercaoEndereco1 = true;
                }
              }
            } else {
              //endpoint update
              Map endereco1 = {
                "userId": Utilidades.usuarioLogado.id,
                "mainAddress": true,
                "zipCode": controladorCEP.text,
                "district": controladorDistrito.text,
                "street": controladorRua.text,
                "neighborhood": controladorBairro.text,
                "number": controladorNumero.text.replaceAll(".", "").replaceAll("-", ""),
                "reference": controladorReferencia.text,
                "complement": controladorComplemento.text,
                "city": _itemSelecionado,
                "state": _itemSelecionadoEstado,
                "id": Utilidades.usuarioLogado.idEndereco1
              };

              var _body = jsonEncode(endereco1);

              var responseInsertEndereco1 = await dio
                  .put(
                    '${API.url}${EndPoints.userAddressUpdateById}',
                    data: _body,
                    options: Options(
                      headers: {'Authorization': 'Bearer $token'},
                    ),
                  )
                  .timeout(
                    Duration(seconds: 15),
                  );

              if (responseInsertEndereco1.statusCode == 200) {
                var responseInsertEnderecoApi = responseInsertEndereco1.data;
                if (responseInsertEnderecoApi['status'] == 200) {
                  Utilidades.usuarioLogado.cep = controladorCEP.text;
                  Utilidades.usuarioLogado.distrito = controladorDistrito.text;
                  Utilidades.usuarioLogado.rua = controladorRua.text;
                  Utilidades.usuarioLogado.bairro = controladorBairro.text;
                  Utilidades.usuarioLogado.numero = int.parse(controladorNumero.text.toString().replaceAll(".", "").replaceAll(",", "").replaceAll("-", ""));
                  Utilidades.usuarioLogado.referencia = controladorReferencia.text;
                  Utilidades.usuarioLogado.complemento =controladorComplemento.text;
                  Utilidades.usuarioLogado.cidade = _itemSelecionado;
                  Utilidades.usuarioLogado.estado = _itemSelecionadoEstado;

                  //InsereDadosFormularioSessao();
                  Utilidades.tempUsuarioEdicaoCidade = _itemSelecionado ?? "";
                  Utilidades.tempUsuarioEdicaoEstado = _itemSelecionadoEstado;
                  Utilidades.tempUsuarioEdicaoBairro = controladorBairro.text;
                  Utilidades.tempUsuarioEdicaoRua = controladorRua.text;
                  Utilidades.tempUsuarioEdicaoNumero = controladorNumero.text.replaceAll(".", "").replaceAll("-", "");
                  Utilidades.tempUsuarioEdicaoComplemento = controladorComplemento.text;
                  Utilidades.tempUsuarioEdicaoReferencia = controladorReferencia.text;
                  Utilidades.tempUsuarioEdicaoCep = controladorCEP.text;
                  Utilidades.tempUsuarioEdicaoDistrito = controladorDistrito.text;
                  
                  edicaoInsercaoEndereco1 = true;
                }
              }
            }

            if (edicaoInsercaoEndereco1) {
              Widget okButton = TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();                  
                  setState((){});
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
                    Text("Edição realizada com sucesso!"),
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
                    Text("Falha ao efetuar o cadastro do endereço."),
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
                Text("Número de endereço inválido."),
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
    //});
  }

  String nomeCidade = "";
  List<String> _cidades = Utilidades.RetornaListaCidade_();
  String? _itemSelecionado = '';
  String? _itemSelecionadoSegundoEndereco = '';

  String nomeestado = "";
  var _estados = Utilidades.RetornaListaEstado_();
  var _itemSelecionadoEstado = '';
  var _itemSelecionadoEstadoSegundoEndereco = '';

  void InsereDadosFormularioSessao() {
    Utilidades.tempUsuariopEdicaoUsuario = controladorUsuario.text;
    Utilidades.tempUsuarioEdicaoNome = controladorNome.text;
    Utilidades.tempUsuarioEdicaoEmail = controladorEmail.text;
    Utilidades.tempUsuarioEdicaoSenha = controladorSenha.text;
    Utilidades.tempUsuarioEdicaoTelefone = controladorTelefone.text;
    Utilidades.tempUsuarioEdicaoCidade = _itemSelecionado ?? "";
    Utilidades.tempUsuarioEdicaoEstado = _itemSelecionadoEstado;
    Utilidades.tempUsuarioEdicaoBairro = controladorBairro.text;
    Utilidades.tempUsuarioEdicaoRua = controladorRua.text;
    Utilidades.tempUsuarioEdicaoNumero =
        controladorNumero.text.replaceAll(".", "").replaceAll("-", "");
    Utilidades.tempUsuarioEdicaoComplemento = controladorComplemento.text;
    Utilidades.tempUsuarioEdicaoReferencia = controladorReferencia.text;
    Utilidades.tempUsuarioEdicaoCep = controladorCEP.text;
    Utilidades.tempUsuarioEdicaoDistrito = controladorDistrito.text;
    Utilidades.tempUsuarioEdicaoCidadeSegundoEndereco =
        _itemSelecionadoSegundoEndereco ?? "";
    Utilidades.tempUsuarioEdicaoEstadoSegundoEndereco =
        _itemSelecionadoEstadoSegundoEndereco;
    Utilidades.tempUsuarioEdicaoBairroSegundoEndereco =
        controladorBairroSegundoEndereco.text;
    Utilidades.tempUsuarioEdicaoRuaSegundoEndereco =
        controladorRuaSegundoEndereco.text;
    Utilidades.tempUsuarioEdicaoNumeroSegundoEndereco =
        controladorNumeroSegundoEndereco.text
            .replaceAll(".", "")
            .replaceAll("-", "");
    Utilidades.tempUsuarioEdicaoComplementoSegundoEndereco =
        controladorComplementoSegundoEndereco.text;
    Utilidades.temUsuariopEdicaoReferenciaSegundoEndereco =
        controladorReferenciaSegundoEndereco.text;
    Utilidades.tempUsuarioEdicaoCepSegundoEndereco =
        controladorCEPSegundoEndereco.text;
    Utilidades.temUsuariopEdicaoDistritoSegundoEndereco =
        controladorDistritoSegundoEndereco.text;
  }

  void RecuperaDadosFormularioSessao() {
    controladorUsuario.text = Utilidades.tempUsuariopEdicaoUsuario;
    controladorNome.text = Utilidades.tempUsuarioEdicaoNome;
    controladorEmail.text = Utilidades.tempUsuarioEdicaoEmail;
    controladorSenha.text = Utilidades.tempUsuarioEdicaoSenha;
    controladorTelefone.text = Utilidades.tempUsuarioEdicaoTelefone;
    _itemSelecionado = Utilidades.tempUsuarioEdicaoCidade;
    _itemSelecionadoEstado = Utilidades.tempUsuarioEdicaoEstado;
    controladorBairro.text = Utilidades.tempUsuarioEdicaoBairro;
    controladorRua.text = Utilidades.tempUsuarioEdicaoRua;
    controladorNumero.text = Utilidades.tempUsuarioEdicaoNumero;
    controladorComplemento.text = Utilidades.tempUsuarioEdicaoComplemento;
    controladorReferencia.text = Utilidades.tempUsuarioEdicaoReferencia;
    controladorCEP.text = Utilidades.tempUsuarioEdicaoCep;
    controladorDistrito.text = Utilidades.tempUsuarioEdicaoDistrito;
    _itemSelecionadoSegundoEndereco =
        Utilidades.tempUsuarioEdicaoCidadeSegundoEndereco;
    _itemSelecionadoEstadoSegundoEndereco =
        Utilidades.tempUsuarioEdicaoEstadoSegundoEndereco;
    controladorBairroSegundoEndereco.text =
        Utilidades.tempUsuarioEdicaoBairroSegundoEndereco;
    controladorRuaSegundoEndereco.text =
        Utilidades.tempUsuarioEdicaoRuaSegundoEndereco;
    controladorNumeroSegundoEndereco.text =
        Utilidades.tempUsuarioEdicaoNumeroSegundoEndereco;
    controladorComplementoSegundoEndereco.text =
        Utilidades.tempUsuarioEdicaoComplementoSegundoEndereco;
    controladorReferenciaSegundoEndereco.text =
        Utilidades.temUsuariopEdicaoReferenciaSegundoEndereco;
    controladorCEPSegundoEndereco.text =
        Utilidades.tempUsuarioEdicaoCepSegundoEndereco;
    controladorDistritoSegundoEndereco.text =
        Utilidades.temUsuariopEdicaoDistritoSegundoEndereco;
  }

  criaDropDownButtonSegundoEndereco() {
    try {
      return Container(
        child: DropdownButton<String>(
          items: _cidades?.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(dropDownStringItem),
            );
          }).toList(),
          onChanged: (String? novoItemSelecionado) {
            _dropDownItemSelectedSegundoEndereco(novoItemSelecionado);
            setState(() {
              this._itemSelecionadoSegundoEndereco = novoItemSelecionado;
            });
          },
          value: _itemSelecionadoSegundoEndereco,
        ),
      );
    } catch (Exception) {
      return Container(
        child: DropdownButton<String>(
          items: _cidades.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(dropDownStringItem),
            );
          }).toList(),
          onChanged: (String? novoItemSelecionado) {
            _dropDownItemSelectedSegundoEndereco(novoItemSelecionado);
            setState(() {
              this._itemSelecionadoSegundoEndereco = novoItemSelecionado;
            });
          },
          value: "",
        ),
      );
    }
  }

  criaDropDownButton() {
    try {
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
    } catch (Exception) {}
  }

  criaDropDownButtonSegundoEnderecoEstado() {
    return Container(
      child: DropdownButton<String>(
        items: _estados.map((String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(dropDownStringItem),
          );
        }).toList(),
        onChanged: (String? novoItemSelecionado) {
          _dropDownItemSelectedSegundoEnderecoEstado(novoItemSelecionado);
          setState(() {
            this._itemSelecionadoEstadoSegundoEndereco = novoItemSelecionado ?? "";
          });
        },
        value: _itemSelecionadoEstadoSegundoEndereco,
      ),
    );
  }

  criaDropDownButtonEstado() {
    return Container(
      child: DropdownButton<String>(
        items: _estados.map((String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(dropDownStringItem),
          );
        }).toList(),
        onChanged: (String? novoItemSelecionado) {
          _dropDownItemSelectedEstado(novoItemSelecionado);
          setState(() {
            this._itemSelecionadoEstado = novoItemSelecionado ?? "";
          });
        },
        value: _itemSelecionadoEstado,
      ),
    );
  }

  void _dropDownItemSelected(String? novoItem) {
    InsereDadosFormularioSessao();
    Utilidades.carregamantoInicialEdicaoUsuario = false;
    setState(() {
      this._itemSelecionado = novoItem;
      Utilidades.tempUsuarioEdicaoCidade = novoItem ?? "";
    });
  }

  void _dropDownItemSelectedSegundoEndereco(String? novoItem) {
    InsereDadosFormularioSessao();
    Utilidades.carregamantoInicialEdicaoUsuario = false;
    setState(() {
      this._itemSelecionadoSegundoEndereco = novoItem;
      Utilidades.tempUsuarioEdicaoCidadeSegundoEndereco = novoItem ?? "";
    });
  }

  void _dropDownItemSelectedEstado(String? novoItem) {
    InsereDadosFormularioSessao();
    Utilidades.carregamantoInicialEdicaoUsuario = false;
    setState(() {
      this._itemSelecionadoEstado = novoItem ?? "";
      Utilidades.tempUsuarioEdicaoEstado = novoItem ?? "";
    });
  }

  void _dropDownItemSelectedSegundoEnderecoEstado(String? novoItem) {
    InsereDadosFormularioSessao();
    Utilidades.carregamantoInicialEdicaoUsuario = false;
    setState(() {
      this._itemSelecionadoEstadoSegundoEndereco = novoItem ?? "";
      Utilidades.tempUsuarioEdicaoEstadoSegundoEndereco = novoItem ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    Usuario usuario = Utilidades.usuarioLogado;
    controladorUsuario.text =
        usuario.login == null ? "" : usuario.login.toString();
    controladorNome.text = usuario.nome == null ? "" : usuario.nome.toString();
    controladorSenha.text = usuario.senha.toString();
    controladorEmail.text = usuario.email.toString();
    controladorTelefone.text = usuario.telefone ?? "";
    _itemSelecionado = usuario.cidade == null ? "" : usuario.cidade.toString();
    _itemSelecionadoEstado =
        usuario.estado == null ? "" : usuario.estado.toString();
    controladorBairro.text =
        usuario.bairro == null ? "" : usuario.bairro.toString();
    controladorRua.text = usuario.rua == null ? "" : usuario.rua.toString();
    controladorNumero.text = usuario.numero == null
        ? ""
        : usuario.numero.toString().replaceAll(".", "").replaceAll("-", "");
    controladorComplemento.text =
        usuario.complemento == null ? "" : usuario.complemento.toString();
    controladorReferencia.text =
        usuario.referencia == null ? "" : usuario.referencia.toString();
    controladorCEP.text = usuario.cep == null ? "" : usuario.cep.toString();
    controladorDistrito.text =
        usuario.distrito == null ? "" : usuario.distrito.toString();
    _itemSelecionadoSegundoEndereco = usuario.cidadeSegundoEndereco == null
        ? ""
        : usuario.cidadeSegundoEndereco.toString();
    _itemSelecionadoEstadoSegundoEndereco =
        usuario.estadoSegundoEndereco == null
            ? ""
            : usuario.estadoSegundoEndereco.toString();
    controladorBairroSegundoEndereco.text =
        usuario.bairroSegundoEndereco == null
            ? ""
            : usuario.bairroSegundoEndereco.toString();
    controladorRuaSegundoEndereco.text = usuario.ruaSegundoEndereco == null
        ? ""
        : usuario.ruaSegundoEndereco.toString();
    controladorNumeroSegundoEndereco.text =
        usuario.numeroSegundoEndereco == null
            ? ""
            : usuario.numeroSegundoEndereco
                .toString()
                .replaceAll(".", "")
                .replaceAll("-", "");
    controladorComplementoSegundoEndereco.text =
        usuario.complementoSegundoEndereco == null
            ? ""
            : usuario.complementoSegundoEndereco.toString();
    controladorReferenciaSegundoEndereco.text =
        usuario.referenciaSegundoEndereco == null
            ? ""
            : usuario.referenciaSegundoEndereco.toString();
    controladorCEPSegundoEndereco.text = usuario.cepSegundoEndereco == null
        ? ""
        : usuario.cepSegundoEndereco.toString();
    controladorDistritoSegundoEndereco.text =
        usuario.distritoSegundoEndereco == null
            ? ""
            : usuario.distritoSegundoEndereco.toString();

    if (!Utilidades.carregamantoInicialEdicaoUsuario) {
      RecuperaDadosFormularioSessao();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utilidades.RetornaCorTema(),
        title: Center(
          child: Text('Editar Perfil       ',
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
                LengthLimitingTextInputFormatter(30),
              ],
              controller: controladorUsuario,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Usuário:*",
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
                LengthLimitingTextInputFormatter(50),
              ],
              controller: controladorEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "E-mail:*",
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
                LengthLimitingTextInputFormatter(30),
              ],
              controller: controladorNome,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Nome:*",
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
                MaskTextInputFormatter(
                    mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')}),
              ],
              controller: controladorTelefone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Número Telefone:*",
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
                    "Salvar informações do perfil",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: Cadastro,
                ),
              ),
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            Container(
                child: Center(
                    child: Text("ENDEREÇO",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)))),
            SizedBox(
              height: 20,
            ),
            Text("Cidade:*", style: TextStyle(color: Colors.grey[400])),
            criaDropDownButton(),
            SizedBox(
              height: 20,
            ),
            Text("Estado:*", style: TextStyle(color: Colors.grey[400])),
            criaDropDownButtonEstado(),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
              controller: controladorDistrito,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Distrito (opcional):",
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
                LengthLimitingTextInputFormatter(30),
              ],
              controller: controladorBairro,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Bairro:*",
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
                LengthLimitingTextInputFormatter(8),
              ],
              controller: controladorCEP,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "CEP:*",
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
                LengthLimitingTextInputFormatter(50),
              ],
              controller: controladorRua,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Rua/Avenida:*",
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
                LengthLimitingTextInputFormatter(5),
              ],
              controller: controladorNumero,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Número:*",
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
                LengthLimitingTextInputFormatter(30),
              ],
              controller: controladorComplemento,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Complemento:",
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
                LengthLimitingTextInputFormatter(30),
              ],
              controller: controladorReferencia,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Referência:",
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
                    "Salvar endereço",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: CadastroEndereco,
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

class SignupPageEdit extends StatefulWidget {
  var newTaskCtrl = TextEditingController();

  @override
  _MyHomePageEditState createState() => _MyHomePageEditState();
}
