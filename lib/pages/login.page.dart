import 'dart:convert';
import 'dart:io';
import 'package:goshare/Utilidades/Utilidades.dart';
import 'package:goshare/Utilidades/block.settings.dart';
import 'package:goshare/Utilidades/endpoinst.dart';
import 'package:goshare/Utilidades/settings.dart';
import 'package:goshare/models/auth.model.dart';
import 'package:goshare/models/usuario.dart';
import 'package:goshare/pages/esqueciminhasenha.dart';
import 'package:goshare/pages/homepagemenu.dart';
import 'package:goshare/pages/notificacao.dart';
import 'package:goshare/pages/selecaoCidade.dart';
import 'package:goshare/pages/signup.page.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  var controladorNome = TextEditingController();
  var controladorSenha = TextEditingController();
  var controladorAguarde = TextEditingController();
  var busy = false;
  var done = false;
  var codigo = '', senha = '';
  static bool processamento = false;
  bool existeFormAberto = false;
  String cidadeDefault = "MANHUMIRIM";

  //video
  // VideoPlayerController _controller;

  var progressBar = Center(
    child: Container(
      width: 300,
      height: 300,
      child: FlareActor(
        "assets/loading_laranja_sacola.flr",
        animation: "loading",
        fit: BoxFit.contain,
      ),
    ),
  );

  var botaoEprogressBar;

  Future<void> AtualizaArquivoConfiguracaoTema() async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/configTema.txt');
      text = await file.readAsString();
    } catch (e) {
      text = "";
    }

    if (text == "") {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/configTema.txt');
      await file.writeAsString("verde");
      
      //default verde (remover quando tiver opção de escolha de cor)
      Utilidades.tema = Tema.verde;
    } else {
      //default verde (remover quando tiver opção de escolha de cor)
      text = "verde";

      switch (text) {
        case "laranjado":
          {
            Utilidades.tema = Tema.laranjado;
            break;
          }
        case "verde":
          {
            Utilidades.tema = Tema.verde;
            break;
          }
        case "azul":
          {
            Utilidades.tema = Tema.azul;
            break;
          }
      }
    }
  }

  Future<void> AtualizaCampoNotificacao() async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/configNotificacao.txt');
      text = await file.readAsString();
    } catch (e) {
      text = "";
    }

    if (text == "") {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/configNotificacao.txt');
      await file.writeAsString("true");
    } else {
      if (text == "true") {
        Utilidades.notificarUsuarioNovaMensagem = true;
      } else {
        Utilidades.notificarUsuarioNovaMensagem = false;
      }
    }
  }

  void VerificaUsuario(BuildContext context) async {
    Utilidades.LimpaSession();
    existeFormAberto = true;
    controladorAguarde.text = "Aguarde... Carregando";
    setState(() {
      botaoEprogressBar = progressBar;
    });
    processamento = true;

    var retorno = 1;
    if (controladorNome.text != "" && controladorSenha.text != "") {
      if (controladorNome.text.contains("'") ||
          controladorNome.text.contains("\"") ||
          controladorNome.text.toUpperCase().contains("DROP") ||
          controladorNome.text.toUpperCase().contains("DELETE") ||
          controladorNome.text.toUpperCase().contains(" ")) {
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
              Text("Caracteres inválidos para o campo de usuário"),
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
        // var con = await SettingsBlock().testaConexaoInternet();
        // if (con == 1) {
        try {
          if (controladorNome.text.contains(":")) {
            try {
              Utilidades.ipSession = controladorNome.text.split(":")[1];
              controladorNome.text = controladorNome.text.split(":")[0];
            } catch (Exception) {}
          }

          // var dio = Dio();
          // (dio.httpClientAdapter as DefaultHttpClientAdapter)
          //     .onHttpClientCreate = (HttpClient client) {
          //   client.badCertificateCallback =
          //       (X509Certificate cert, String host, int port){
          //         final isValidHost = ["localhost"].contains(host); // <-- allow only hosts in array
          //         return isValidHost;
          //       };
          //   return client;
          // };

          var dio = Dio();
                  (dio.httpClientAdapter as DefaultHttpClientAdapter)
                      .onHttpClientCreate = (HttpClient client) {
                    client.badCertificateCallback =
                        (X509Certificate cert, String host, int port) => true;
                    return client;
                  };
          
          Map parametro;

          if (!controladorNome.text.contains("@")) {
            parametro = {
              "username": controladorNome.text.trim(),
              "password": controladorSenha.text,
            };
          } else {
            parametro = {
              "email": controladorNome.text.trim(),
              "password": controladorSenha.text,
            };
          }
          var body = jsonEncode(parametro);
          var response = await dio
                        .post(
                          API.url +
                          (controladorNome.text.contains("@")
                          ? '${EndPoints.userLoginEmail}'
                          : '${EndPoints.userLoginUserName}'
                          ),
                          data: body,
                          options: Options(
                            headers: {'Content-Type': 'application/json'},
                          ),
                        )
                        .timeout(
                          Duration(seconds: 25),
                        );
          
          if (response.statusCode == 200) {
            if (response.data['status'] == 200) {
              Auth auth = new Auth(status:response.data['status'],success:response.data['success'],message: response.data['message'],data:response.data['data']);
              SettingsBlock().setToken(response.data['data']);
              Utilidades.token = response.data['data'].toString();
              try {
                String token = await SettingsBlock().getToken();

                var usuario_;
                if (!controladorNome.text.contains("@")) {
                  parametro = {
                    "username": controladorNome.text.trim(),
                    "password": controladorSenha.text,
                  };

                  var _body = jsonEncode(parametro);

                  final response_ = await dio
                      .post(
                        API.url + '${EndPoints.userLoginUserName}',
                        data: _body,
                        options: Options(
                          headers: {'Authorization': 'Bearer $token'},
                        ),
                      )
                      .timeout(
                        Duration(seconds: 17),
                      );

                  usuario_ = response_.data["data"];
                } else {
                  parametro = {
                    "email": controladorNome.text.trim(),
                    "password": controladorSenha.text,
                  };

                  var _body = jsonEncode(parametro);

                  final response_ = await dio
                      .post(
                        API.url + '${EndPoints.userEmail}',
                        data: _body,
                        options: Options(
                          headers: {'Authorization': 'Bearer $token'},
                        ),
                      )
                      .timeout(
                        Duration(seconds: 17),
                      );
                  usuario_ = response_.data["data"];
                }

                bool autenticacao = false;
                if (!controladorNome.text.contains("@")) {
                  autenticacao = usuario_['userName'].trim() ==
                      controladorNome.text.trim();
                } else {
                  autenticacao =
                      usuario_['email'].trim() == controladorNome.text.trim();
                }

                if (autenticacao) {
                  Usuario usuario = new Usuario();

                  usuario.login = usuario_['userName'];
                  usuario.guid = usuario_['guid'];
                  usuario.senha = controladorSenha.text; 
                  usuario.id = usuario_['id'];
                  usuario.email = usuario_['email'];

                  try {
                    usuario.nome = usuario_['firstName'];
                    usuario.telefone = usuario_['phoneNumber'];
                    usuario.avaliacao = usuario_['rating'];
                  } catch (Exception) {}
                  //pegar endereco 1 e 2 e inserir na sessao

                  Utilidades.InsereUsuarioSession(usuario);

                  try {
                    final responseEndereco = await dio
                        .post(
                          API.url + '${EndPoints.userAddressUserId}',
                          data: {"UserId": usuario.id},
                          options: Options(
                            headers: {'Authorization': 'Bearer $token'},
                          ),
                        )
                        .timeout(
                          Duration(seconds: 15),
                        );

                    for (int i = 0;
                        i < responseEndereco.data['data'].length;
                        i++) {
                      if (responseEndereco.data['data'][i]['mainAddress'] == true) {
                        usuario.cidade =
                            responseEndereco.data['data'][i]['city'];
                        usuario.estado =
                            responseEndereco.data['data'][i]['state'];
                        usuario.bairro =
                            responseEndereco.data['data'][i]['neighborhood'];
                        usuario.rua =
                            responseEndereco.data['data'][i]['street'];

                        try {
                          usuario.numero = int.parse(
                              responseEndereco.data['data'][i]['number']);
                        } catch (Exception) {
                          usuario.numero = 0;
                        }
                        usuario.complemento =
                            responseEndereco.data['data'][i]['complement'];
                        usuario.referencia =
                            responseEndereco.data['data'][i]['reference'];
                        usuario.distrito =
                            responseEndereco.data['data'][i]['district'];
                        usuario.cep =
                            responseEndereco.data['data'][i]['zipCode'];
                        usuario.idEndereco1 =
                            responseEndereco.data['data'][i]['id'];
                      } else {
                        usuario.cidadeSegundoEndereco =
                            responseEndereco.data['data'][i]['city'];
                        usuario.estadoSegundoEndereco =
                            responseEndereco.data['data'][i]['state'];
                        usuario.bairroSegundoEndereco =
                            responseEndereco.data['data'][i]['neighborhood'];
                        usuario.ruaSegundoEndereco =
                            responseEndereco.data['data'][i]['street'];
                        usuario.numeroSegundoEndereco = int.parse(
                            responseEndereco.data['data'][i]['number']);
                        usuario.complementoSegundoEndereco =
                            responseEndereco.data['data'][i]['complement'];
                        usuario.referenciaSegundoEndereco =
                            responseEndereco.data['data'][i]['reference'];
                        usuario.distritoSegundoEndereco =
                            responseEndereco.data['data'][i]['district'];
                        usuario.cepSegundoEndereco =
                            responseEndereco.data['data'][i]['zipCode'];
                        usuario.idEndereco2 =
                            responseEndereco.data['data'][i]['id'];
                      }
                    }

                    Utilidades.InsereUsuarioSession(usuario);

                    (dio.httpClientAdapter as DefaultHttpClientAdapter)
                        .onHttpClientCreate = (HttpClient client) {
                      client.badCertificateCallback =
                          (X509Certificate cert, String host, int port) => true;
                    };
                    List listaTemporaria = [];
                    token = await SettingsBlock().getToken();
                    final response_ = await dio
                        .get(
                          API.url + '${EndPoints.customer}',
                          options: Options(
                            headers: {'Authorization': 'Bearer $token'},
                          ),
                        )
                        .timeout(
                          Duration(seconds: 12),
                        );

                    try {
                      var listaTodasEmpresas = [];
                      for (int i = 0; i < response_.data['data'].length; i++) {
                        listaTodasEmpresas.add(response_.data["data"][i]);
                        //##BURGDELIVERY ALTERAÇÃO
                        if (response_.data["data"][i]["companyName"]
                                .contains("##") ||
                            response_.data["data"][i]["companyName"]
                                    .toString() ==
                                "CompreAqui") {
                          listaTemporaria.add(response_.data["data"][i]);
                        }
                      }
                      Utilidades.listaTodasEmpresas = listaTodasEmpresas;
                      Utilidades.listaEmpresas = listaTemporaria;

                      Utilidades.RetornaListaImagens();
                      Utilidades.pageScreenAberta = false;
                      retorno = 3;
                    } catch (Exception) {
                      retorno = 1;
                    }
                  } catch (Exception) {
                    retorno = 1;
                  }
                }
              } catch (Exception) {
                retorno = 1;
              }
            } else {
              if (response.data['status'] == 404) {
                retorno = 2;
              } else {
                retorno = 1;
              }
            }
          } else {
            if (response.statusCode == 400) {
              retorno = 2;
            } else {
              retorno = 1;
            }
          }
        } catch (Exception) {
          retorno = 1;
        }
      }
    } else {
      retorno = 4;
    }

    //TESTE 
    //TO DO: criar método genérico
    //segunda tentativa (trata falha carregamento arquivos sessions, falha carregamento sharedsettings, tempo de conexão, geração do token api)
    /// INICIO ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if(retorno != 3){
    try {
          if (controladorNome.text.contains(":")) {
            try {
              Utilidades.ipSession = controladorNome.text.split(":")[1];
              controladorNome.text = controladorNome.text.split(":")[0];
            } catch (Exception) {}
          }

          var dio = Dio();
          (dio.httpClientAdapter as DefaultHttpClientAdapter)
              .onHttpClientCreate = (HttpClient client) {
            client.badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
            return client;
          };

          Map parametro;

          if (!controladorNome.text.contains("@")) {
            parametro = {
              "username": controladorNome.text.trim(),
              "password": controladorSenha.text,
            };
          } else {
            parametro = {
              "email": controladorNome.text.trim(),
              "password": controladorSenha.text,
            };
          }
        var _body = jsonEncode(parametro);
        
        //   HttpClient certificado = new HttpClient()
        //     ..badCertificateCallback =
        //         ((X509Certificate cert, String host, int port) => true);
        //   IOClient ioClient = new IOClient(certificado);

          
        // Uri uri = new Uri(host:API.url +
        //               (controladorNome.text.contains("@")
        //                   ? '${EndPoints.userLoginEmail}'
        //                   : '${EndPoints.userLoginUserName}'));
        //   final response = await ioClient
        //       .post(
        //           uri,
                  // headers: API.header,
        //           body: _body)
        //       .timeout(
        //         Duration(seconds: 20),
        //       );

        final response = await dio
              .post(
                  API.url +
                      (controladorNome.text.contains("@")
                          ? '${EndPoints.userLoginEmail}'
                          : '${EndPoints.userLoginUserName}'),
                  options: Options(
                            headers: {'Content-Type': 'application/json'},
                          ),
                  data: _body
              )
              .timeout(
                Duration(seconds: 20),
              );

          if (response.statusCode == 200) {
            if (response.data['status'] == 200) {
              Auth auth = new Auth(status:response.data['status'],success:response.data['success'],message: response.data['message'],data:response.data['data']);
              SettingsBlock().setToken(response.data['data']);
              Utilidades.token = response.data['data'].toString();
              try {
                String token = await SettingsBlock().getToken();

                var usuario_;
                if (!controladorNome.text.contains("@")) {
                  parametro = {
                    "username": controladorNome.text.trim(),
                    "password": controladorSenha.text,
                  };

                  var _body = jsonEncode(parametro);

                  final response_ = await dio
                      .post(
                        API.url + '${EndPoints.userUserName}',
                        data: _body,
                        options: Options(
                          headers: {'Authorization': 'Bearer $token'},
                        ),
                      )
                      .timeout(
                        Duration(seconds: 17),
                      );

                  usuario_ = response_.data["data"];
                } else {
                  parametro = {
                    "email": controladorNome.text.trim(),
                    "password": controladorSenha.text,
                  };

                  var _body = jsonEncode(parametro);

                  final response_ = await dio
                      .post(
                        API.url + '${EndPoints.userEmail}',
                        data: _body,
                        options: Options(
                          headers: {'Authorization': 'Bearer $token'},
                        ),
                      )
                      .timeout(
                        Duration(seconds: 17),
                      );
                  usuario_ = response_.data["data"];
                }

                bool autenticacao = false;
                if (!controladorNome.text.contains("@")) {
                  autenticacao = usuario_['userName'].trim() ==
                      controladorNome.text.trim();
                } else {
                  autenticacao =
                      usuario_['email'].trim() == controladorNome.text.trim();
                }

                if (autenticacao) {
                  Usuario usuario = new Usuario();

                  usuario.login = usuario_['userName'];
                  usuario.guid = usuario_['guid'];
                  usuario.senha = controladorSenha.text; //usuario_['password'];
                  usuario.id = usuario_['id'];
                  usuario.email = usuario_['email'];

                  try {
                    usuario.nome = usuario_['firstName'];
                    usuario.telefone = usuario_['phoneNumber'];
                    usuario.avaliacao = usuario_['rating'];
                  } catch (Exception) {}
                  //pegar endereco 1 e 2 e inserir na sessao

                  Utilidades.InsereUsuarioSession(usuario);

                  try {
                    final responseEndereco = await dio
                        .post(
                          API.url + '${EndPoints.userAddressUserId}',
                          data: {"UserId": usuario.id},
                          options: Options(
                            headers: {'Authorization': 'Bearer $token'},
                          ),
                        )
                        .timeout(
                          Duration(seconds: 15),
                        );

                    for (int i = 0;
                        i < responseEndereco.data['data'].length;
                        i++) {
                      if (responseEndereco.data['data'][i]['mainAddress'] ==
                          true) {
                        //if (i == 0) {
                        usuario.cidade =
                            responseEndereco.data['data'][i]['city'];
                        usuario.estado =
                            responseEndereco.data['data'][i]['state'];
                        usuario.bairro =
                            responseEndereco.data['data'][i]['neighborhood'];
                        usuario.rua =
                            responseEndereco.data['data'][i]['street'];

                        try {
                          usuario.numero = int.parse(
                              responseEndereco.data['data'][i]['number']);
                        } catch (Exception) {
                          usuario.numero = 0;
                        }
                        usuario.complemento =
                            responseEndereco.data['data'][i]['complement'];
                        usuario.referencia =
                            responseEndereco.data['data'][i]['reference'];
                        usuario.distrito =
                            responseEndereco.data['data'][i]['district'];
                        usuario.cep =
                            responseEndereco.data['data'][i]['zipCode'];
                        usuario.idEndereco1 =
                            responseEndereco.data['data'][i]['id'];
                      } else {
                        usuario.cidadeSegundoEndereco =
                            responseEndereco.data['data'][i]['city'];
                        usuario.estadoSegundoEndereco =
                            responseEndereco.data['data'][i]['state'];
                        usuario.bairroSegundoEndereco =
                            responseEndereco.data['data'][i]['neighborhood'];
                        usuario.ruaSegundoEndereco =
                            responseEndereco.data['data'][i]['street'];
                        usuario.numeroSegundoEndereco = int.parse(
                            responseEndereco.data['data'][i]['number']);
                        usuario.complementoSegundoEndereco =
                            responseEndereco.data['data'][i]['complement'];
                        usuario.referenciaSegundoEndereco =
                            responseEndereco.data['data'][i]['reference'];
                        usuario.distritoSegundoEndereco =
                            responseEndereco.data['data'][i]['district'];
                        usuario.cepSegundoEndereco =
                            responseEndereco.data['data'][i]['zipCode'];
                        usuario.idEndereco2 =
                            responseEndereco.data['data'][i]['id'];
                      }
                    }

                    Utilidades.InsereUsuarioSession(usuario);

                    (dio.httpClientAdapter as DefaultHttpClientAdapter)
                        .onHttpClientCreate = (HttpClient client) {
                      client.badCertificateCallback =
                          (X509Certificate cert, String host, int port) => true;
                    };
                    List listaTemporaria = [];
                    token = await SettingsBlock().getToken();
                    final response_ = await dio
                        .get(
                          API.url + '${EndPoints.customer}',
                          options: Options(
                            headers: {'Authorization': 'Bearer $token'},
                          ),
                        )
                        .timeout(
                          Duration(seconds: 12),
                        );

                    try {
                      var listaTodasEmpresas = [];
                      for (int i = 0; i < response_.data['data'].length; i++) {
                        listaTodasEmpresas.add(response_.data["data"][i]);
                        //##BURGDELIVERY ALTERAÇÃO
                        if (response_.data["data"][i]["companyName"]
                                .contains("##") ||
                            response_.data["data"][i]["companyName"]
                                    .toString() ==
                                "CompreAqui") {
                          listaTemporaria.add(response_.data["data"][i]);
                        }
                      }
                      Utilidades.listaTodasEmpresas = listaTodasEmpresas;
                      Utilidades.listaEmpresas = listaTemporaria;

                      Utilidades.RetornaListaImagens();
                      Utilidades.pageScreenAberta = false;
                      retorno = 3;
                    } catch (Exception) {
                      retorno = 1;
                    }
                  } catch (Exception) {
                    retorno = 1;
                  }
                }
              } catch (Exception) {
                retorno = 1;
              }
            } else {
              if (response.data['status'] == 404) {
                retorno = 2;
              } else {
                retorno = 1;
              }
            }
          } else {
            if (response.statusCode == 400) {
              retorno = 2;
            } else {
              retorno = 1;
            }
          }
        } catch (Exception) {
          retorno = 1;
        }
      }
      /// FIM (segunda tentativa de conexão) ////////////////////////////////////////////////////////////////////////////////////////////
      
    controladorAguarde.text = "";

    var mensagem = "";
    if (retorno == 0) {
      mensagem = "Falha na conexão com a internet.";
    } else {
      if (retorno == 1) {
        mensagem = "Falha ao tentar conectar com o servidor. \n\nTENTE NOVAMENTE.";
      } else {
        if (retorno == 2) {
          mensagem = "Usuário ou senha inválidos.";
        } else {
          if (retorno == 4) {
            mensagem = "Campos de preenchimento obrigatório inválidos.";
          }
        }
      }
    }

    if (retorno == 3) {
      try {
        //AtualizaArquivoConfiguracaoTema();
        VerificaExistencia(
            controladorNome.text.trim() + "||" + controladorSenha.text);
      } catch (e) {}
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
            Text(mensagem),
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
    
    if(retorno != 3)
      processamento = false;

    setState(() {
      botaoEprogressBar = Container(
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
                "Entrar",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              onPressed: (){
                if (processamento == false) {
                  VerificaUsuario(context);
                }
              }
          ),
        ),
      );
    });

    existeFormAberto = false;
  }

  Future<String> VerificaLocalizacao() async {
    try{

      String latitude = "";
      String longitude = "";
      String cidade_= cidadeDefault;
      // Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      //                     .timeout(Duration(seconds: 8),
      //                   );
                     
      try{
        // latitude = position.latitude.toString();
        // longitude = position.latitude.toString();
      }catch(Exception){
      } 

      //teste location manhuaçu
      // latitude = "-20.247000";
      // longitude = "-42.032000";
      
      //teste location outro lugar
      // latitude = "-20.247000";
      // longitude = "-43.032000";

      if(latitude != "" && longitude != ""){
        HttpClient certificado = new HttpClient()
            ..badCertificateCallback =
                ((X509Certificate cert, String host, int port) => true);
        IOClient ioClient = new IOClient(certificado);

        Map parametro = {
              "latitude": latitude,
              "longitude": longitude,
            };
        var _body = jsonEncode(parametro);
        Uri uri = new Uri(host:API.url +'${EndPoints.userLocation}');
        final response = await ioClient
              .post(uri,
                  headers: API.header,
                  body: _body)
              .timeout(
                Duration(seconds: 15),
              );

        if (response.statusCode == 200) {
          Map mapResponse = jsonDecode(response.body);
          if (mapResponse['status'] == 200) {
            cidade_ = mapResponse['data'];
          }
        }
        return (cidade_  == "") ? cidadeDefault : cidade_;
      }
      else{
        return cidadeDefault;
      }
    }
    catch(Exception){
      return cidadeDefault;
    }
  }

  Future VerificaExistencia(String token) async {
    String text;
    bool existeCidadeArquivo = false;
    String cidadeArquivo = "";
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/config.txt');
      text = await file.readAsString();
    } catch (e) {
      text = "";
    }

    if (text != "") {
      if (text.split("||")[0] + "||" + text.split("||")[1] != token) {
        Widget cancelButton = TextButton(
          child: Text("Não"),
          onPressed: () async {
            Navigator.of(context).pop();
            Utilidades.cidadeUsuario = await VerificaLocalizacao();
            Utilidades.selecaoCidadeAutomatica = true;
            Utilidades.timerScreen = true;
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePageMenu(),// HomePage(),
              ),
            );
            processamento = false;
          },
        );
        Widget continueButton = TextButton(
          child: Text("Sim"),
          onPressed: () async {
            final Directory directory =
                await getApplicationDocumentsDirectory();
            final File file = File('${directory.path}/config.txt');
            await file.writeAsString(token);
            Navigator.of(context).pop();

            Utilidades.cidadeUsuario = await VerificaLocalizacao();
            Utilidades.selecaoCidadeAutomatica = true;
            Utilidades.timerScreen = true;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePageMenu()// HomePage(),
              ),
            );
            
            processamento = false;
          },
        );
        AlertDialog alert = AlertDialog(
          title: Text(""),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                child: Image.asset("assets/pergunta.png"),
              ),
              SizedBox(height: 20),
              Text("Deseja salvar as informações de login?"),
            ],
          ),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return alert;
          },
        );
      } else {
        try {
            Utilidades.cidadeUsuario = await VerificaLocalizacao();
            Utilidades.selecaoCidadeAutomatica = true;
            Utilidades.timerScreen = true;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePageMenu(),// HomePage(),
              ),
            );      
            
            processamento = false;    
        } catch (Exception) {
          
            processamento = false;
        }
      }
    } else {
      Widget cancelButton = TextButton(
        child: Text("Não"),
        onPressed: () async {
          Navigator.of(context).pop();

          Utilidades.cidadeUsuario = await VerificaLocalizacao();
          Utilidades.selecaoCidadeAutomatica = true;
          Utilidades.timerScreen = true;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  HomePageMenu(),//HomePage(),
              ),
          );
          
          processamento = false;
        },
      );
      Widget continueButton = TextButton(
        child: Text("Sim"),
        onPressed: () async {
          final Directory directory = await getApplicationDocumentsDirectory();
          final File file = File('${directory.path}/config.txt');
          await file.writeAsString(token);
          Navigator.of(context).pop();
          
          Utilidades.cidadeUsuario = await VerificaLocalizacao();
          Utilidades.selecaoCidadeAutomatica = true;
          Utilidades.timerScreen = true;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  HomePageMenu(),//HomePage(),
              ),
          );
          
          processamento = false;
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text(""),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              child: Image.asset("assets/pergunta.png"),
            ),
            SizedBox(height: 20),
            Text("Deseja salvar as informações de login?"),
          ],
        ),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/config.txt');
    await file.writeAsString(text);
  }

  Future<String> _read() async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/config.txt');
      text = await file.readAsString();
    } catch (e) {
      return "";
    }
    return text;
  }

  Future AtualizaCampoLoginArquivo(TextEditingController nome) async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/config.txt');
      text = await file.readAsString();
      nome.text = text.split("||")[0];
    } catch (e) {}
  }

  Future AtualizaCampoSenhaArquivo(TextEditingController senha) async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/config.txt');
      text = await file.readAsString();
      senha.text = text.split("||")[1];

      if (controladorNome.text != null &&
          controladorNome.text != "" &&
          controladorSenha.text != null &&
          controladorSenha.text != "") {
        if (processamento == false) {
          VerificaUsuario(context);
        }
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    try {
      //seta para verde a cor do app independente do arquivo de configuração (remover quando tiver implementação de troca de cor do app)
      Utilidades.tema = Tema.verde;

      AtualizaCampoNotificacao();
      AtualizaArquivoConfiguracaoTema();
      //video
      // _controller = VideoPlayerController.asset('assets/beep.mp4')
      //   ..initialize().then((_) {
      //     setState(() {});
      //   });
      botaoEprogressBar = Container(
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
                "Entrar",
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
                        VerificaUsuario(context);
                      }
                    }),
        ),
      );
      AtualizaCampoLoginArquivo(controladorNome);
      AtualizaCampoSenhaArquivo(controladorSenha);

      // _getCurrentLocation();
      // var a = _stringPosition;
    } catch (Exception) {}
  }

  void DismissDirectionCallback(DismissDirection direction) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () {
          if (!existeFormAberto) {
            exit(0);
          }
          
          return Future<bool>(() => false);
        },
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.only(top: 60, left: 40, right: 40),
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset("assets/logo.png"),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50),
                  ],
                  controller: controladorNome,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  style: TextStyle(fontSize: 20),
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
                    //focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    labelText: "Senha",
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(child: botaoEprogressBar),
                TextFormField(
                  textAlign: TextAlign.center,
                  enabled: false,
                  controller: controladorAguarde,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: Colors.orange[300],
                      fontWeight: FontWeight.w200,
                      fontSize: 18,
                    ),
                  ),
                  style: TextStyle(fontSize: 18),
                ),
                //Container(child: progressBar),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  child: TextButton(
                    child: Text(
                      "Cadastre-se",
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      if (processamento == false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupPage(),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  child: TextButton(
                    child: Text(
                      "Esqueci meu usuário ou senha",
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      if (processamento == false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EsqueciMinhaSenha(),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 40,
                  child: TextButton(
                    child: Text(
                        "Remover informações de login salvas neste aparelho",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.black.withOpacity(0.5))),
                    onPressed: () async {
                      if (processamento == false) {
                        try {
                          Widget cancelButton = TextButton(
                            child: Text("Não"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                          Widget continueButton = TextButton(
                            child: Text("Sim"),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              try {
                                final Directory directory =
                                    await getApplicationDocumentsDirectory();
                                final File file =
                                    File('${directory.path}/config.txt');
                                await file.writeAsString("||");
                                controladorNome.text = "";
                                controladorSenha.text = "";
                              } catch (Exception) {}
                            },
                          );
                          AlertDialog alert = AlertDialog(
                            title: Text(""),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: 80,
                                  height: 80,
                                  child: Image.asset("assets/pergunta.png"),
                                ),
                                SizedBox(height: 20),
                                Text(
                                    "Tem certeza que deseja remover as informações de login deste dipositivo?"),//,style: GoogleFonts.mcLaren()),
                              ],
                            ),
                            actions: [
                              cancelButton,
                              continueButton,
                            ],
                          );

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        } catch (Exception) {}
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
