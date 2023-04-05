import 'dart:convert';
import 'dart:io';
import 'package:goshare/Utilidades/Utilidades.dart';
import 'package:goshare/Utilidades/endpoinst.dart';
import 'package:goshare/Utilidades/settings.dart';
import 'package:goshare/models/usuario.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NovoEnderecoState extends State<NovoEndereco> {
  var controladorCidade = TextEditingController();
  var controladorBairro = TextEditingController();
  var controladorRua = TextEditingController();
  var controladorNumero = TextEditingController();
  var controladorComplemento = TextEditingController();
  var controladorReferencia = TextEditingController();
  var controladorDistrito = TextEditingController();
  var controladorCEP = TextEditingController();

  Future<void> InsercaoEndereco() async {
    //setState(() async {
      if (_itemSelecionado != "" &&
          _itemSelecionadoEstado != "" &&
          controladorBairro.text != "" &&
          controladorRua.text != "" &&
          controladorNumero.text != "") {
        var responseInsertEndereco1;
        if (Utilidades.RetornaNumeroValido(controladorNumero.text)) {
          try {
            var token = Utilidades.token;
            bool sessaoExpirada = false;
            var dio = Dio();
            (dio.httpClientAdapter as DefaultHttpClientAdapter)
                .onHttpClientCreate = (HttpClient client) {
              client.badCertificateCallback =
                  (X509Certificate cert, String host, int port) => true;
              return client;
            };

            bool edicaoInsercao = false;

            AlertDialog alerta = AlertDialog(
              title: Text("Editando..."),
              content: Center(
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
            );
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return alerta;
              },
            );

            Map endereco1 = {
              "userId": Utilidades.usuarioLogado.id,
              "zipCode": controladorCEP.text,
              "mainAddress": true,
              "street": controladorRua.text,
              "district": controladorDistrito.text,
              "neighborhood": controladorBairro.text,
              "number": controladorNumero.text,
              "reference": controladorReferencia.text,
              "complement": controladorComplemento.text,
              "city": _itemSelecionado,
              "state": _itemSelecionadoEstado,
              "id": Utilidades.usuarioLogado.idEndereco1
            };

            var _body = jsonEncode(endereco1);

            responseInsertEndereco1 = await dio
                .put(
                  '${API.url}${EndPoints.userAddressUpdateById}',
                  data: _body,
                  options: Options(
                    headers: {'Authorization': 'Bearer $token'},
                  ),
                )
                .timeout(
                  Duration(seconds: 10),
                );

            if (responseInsertEndereco1.statusCode == 200) {
              var responseInsertEnderecoApi1 = responseInsertEndereco1.data;
              if (responseInsertEnderecoApi1['status'] == 200) {
                Utilidades.usuarioLogado.cep = controladorCEP.text;
                Utilidades.usuarioLogado.distrito = controladorDistrito.text;
                Utilidades.usuarioLogado.rua = controladorRua.text;
                Utilidades.usuarioLogado.bairro = controladorBairro.text;
                Utilidades.usuarioLogado.numero = int.parse(controladorNumero.text.replaceAll(".", "").replaceAll(",", "").replaceAll("-", ""));
                Utilidades.usuarioLogado.referencia = controladorReferencia.text;
                Utilidades.usuarioLogado.complemento =controladorComplemento.text;
                Utilidades.usuarioLogado.cidade = _itemSelecionado;
                Utilidades.usuarioLogado.estado = _itemSelecionadoEstado;
                edicaoInsercao = true;
              }
            }

            Navigator.of(context).pop();

            
              if(edicaoInsercao){
              Widget okButton = TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
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
                      child: Image.asset("assets/ok.png"),
                    ),
                    SizedBox(height: 20),
                    Text("Endereço cadastrado com sucesso!"),
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
                  Text("Falha na edição do endereço." +
                      (Exception.toString().contains("Http status error [401]")
                          ? Utilidades.erroTokenInvalido
                          : "")),
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
                Text("Número inválido."),
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
              Text("Campos de preenchimento obrigatório incompletos!"),
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
  var _cidades = Utilidades.RetornaListaCidade_();
  String? _itemSelecionado = '';

  String estado = "";
  List<String> _estados = Utilidades.RetornaListaEstado_();
  String? _itemSelecionadoEstado = '';

  void InsereDadosFormularioSessao() {
    Utilidades.tempUsuarioEdicaoCidade = _itemSelecionado ?? "";
    Utilidades.tempUsuarioEdicaoEstado = _itemSelecionadoEstado ?? "";
    Utilidades.tempUsuarioEdicaoBairro = controladorBairro.text;
    Utilidades.tempUsuarioEdicaoRua = controladorRua.text;
    Utilidades.tempUsuarioEdicaoNumero = controladorNumero.text;
    Utilidades.tempUsuarioEdicaoComplemento = controladorComplemento.text;
    Utilidades.tempUsuarioEdicaoReferencia = controladorReferencia.text;
    Utilidades.tempUsuarioEdicaoCep = controladorCEP.text;
    Utilidades.tempUsuarioEdicaoDistrito = controladorDistrito.text;
  }

  void RecuperaDadosFormularioSessao() {
    _itemSelecionado = Utilidades.tempUsuarioEdicaoCidade;
    _itemSelecionadoEstado = Utilidades.tempUsuarioEdicaoEstado;
    controladorBairro.text = Utilidades.tempUsuarioEdicaoBairro;
    controladorRua.text = Utilidades.tempUsuarioEdicaoRua;
    controladorNumero.text = Utilidades.tempUsuarioEdicaoNumero;
    controladorComplemento.text = Utilidades.tempUsuarioEdicaoComplemento;
    controladorReferencia.text = Utilidades.tempUsuarioEdicaoReferencia;
    controladorCEP.text = Utilidades.tempUsuarioEdicaoCep;
    controladorDistrito.text = Utilidades.tempUsuarioEdicaoDistrito;
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
    InsereDadosFormularioSessao();
    Utilidades.carregamantoInicialEdicaoUsuario = false;
    setState(() {
      this._itemSelecionado = novoItem;
      Utilidades.tempUsuarioEdicaoCidade = novoItem ?? "";
    });
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

  void _dropDownItemSelectedEstado(String? novoItem) {
    InsereDadosFormularioSessao();
    Utilidades.carregamantoInicialEdicaoUsuario = false;
    setState(() {
      this._itemSelecionadoEstado = novoItem;
      Utilidades.tempUsuarioEdicaoEstado = novoItem ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    _itemSelecionado = Utilidades.usuarioLogado.cidade;
    _itemSelecionadoEstado = Utilidades.usuarioLogado.estado;
    controladorBairro.text = Utilidades.usuarioLogado.bairro ?? "";
    controladorRua.text = Utilidades.usuarioLogado.rua ?? "";
    controladorNumero.text = Utilidades.usuarioLogado.numero == null ? "" : Utilidades.usuarioLogado.numero.toString();
    controladorComplemento.text = Utilidades.usuarioLogado.complemento ?? "";
    controladorReferencia.text = Utilidades.usuarioLogado.referencia ?? "";
    controladorDistrito.text = Utilidades.usuarioLogado.distrito ?? "";
    controladorCEP.text = Utilidades.usuarioLogado.cep ?? "";

    if (!Utilidades.carregamantoInicialEdicaoUsuario) {
      RecuperaDadosFormularioSessao();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utilidades.RetornaCorTema(),
        title: Center(
          child: Text('Cadastro/Edição de Endereço  ',
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
            Text("Cidade:", style: TextStyle(color: Colors.grey[400])),
            criaDropDownButton(),
            SizedBox(
              height: 10,
            ),
            Text("Estado:", style: TextStyle(color: Colors.grey[400])),
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
                labelText: "Bairro:",
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
                labelText: "CEP:",
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
                labelText: "Rua/Avenida:",
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
                labelText: "Número:",
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
                    "Continuar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: InsercaoEndereco,
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

class NovoEndereco extends StatefulWidget {
  var newTaskCtrl = TextEditingController();

  @override
  NovoEnderecoState createState() => NovoEnderecoState();
}
