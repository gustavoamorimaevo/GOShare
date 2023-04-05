import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:goshare/Utilidades/settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utilidades.dart';

class SettingsBlock {
  var url;
  validaConexaoApi(int id) async {
    HttpClient certificado = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(certificado);
    API.url = await SettingsBlock().getUrl();
    url = await SettingsBlock().getUrl();
    try {
      Uri uri = new Uri(host:API.url + 'api/user/login/username');
      final response = await ioClient.get(uri).timeout(
            Duration(seconds: 7),
          );
      if (response.statusCode != 200) {
        return 0;
      }
      else{
        return 1;
      }
    } on SocketException catch (_) {
      return 0;
    } on TimeoutException catch (_) {
      return 0;
    } on Exception catch (_) {
      return 0;
    } on NoSuchMethodError catch (_) {
      return 0;
    }
  }

// pega apenas o ip do servidor
  getIpServidor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String servidor = prefs.getString('ipServidor').toString();
    return servidor;
  }

// pega a porta de comunicação do servidor
  getPortaComunicacao() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String porta = prefs.getString('portaComunicacao').toString();
    return porta;
  }

// pega a ulr concatenado
  getUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //var urlbruta = prefs.getString('url');
    var urlbruta = "https://"+Utilidades.siteApiSession+"/";;
    return urlbruta;
  }

// setta e pega token
  setToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }

// seta e pega configuração de filtro mesa
  setConfigFiltroMesas(filtroConf) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('FiltroMesaConf', filtroConf);
  }

  getConfigFiltroMesas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var conf = prefs.getBool('FiltroMesaConf');
    return conf;
  }
//

  //testa se telefone esta em rede.
  // testaConexaoInternet() async {
  //   try {
  //     var connectivityResult = await Connectivity().checkConnectivity();
  //     if (connectivityResult == ConnectivityResult.wifi) {
  //       return 1;
  //     } else {
  //       return null;
  //     }
  //   } on SocketException catch (_) {
  //     return null;
  //   } on TimeoutException catch (_) {
  //     return null;
  //   } on Exception catch (_) {
  //     return null;
  //   } on NoSuchMethodError catch (_) {
  //     return null;
  //   }
  // }

// tempo
// para configuração local
  setMinutos(_time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("minu", _time);
  }

  getMinutos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? _time = prefs.getDouble("minu");
    return _time;
  }

  setSegundos(_time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("sec", _time);
  }

  getSegundos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? _time = prefs.getDouble("sec");
    return _time;
  }

// usado para atualizar mapa de mesa
  setAutoRefresh(_time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("Time", _time);
  }

  getAutoRefresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? _time = prefs.getDouble("Time");
    return _time;
  }
}

// salva chave
setDemo(_key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("KeySIS", _key);
}

// pega chave
getDemo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var keydemo = prefs.getString("KeySIS");

  return keydemo;
}

// salva se já foi adicionado a chave
setDemoExiste(_key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt("Existe", _key);
}

// pega se já foi adicionado chave
getDemoExiste() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var keydemo = prefs.getInt("Existe");

  return keydemo;
}

// verifica se tem alguma chave salva.
verificaSeTem() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var retorno = prefs.containsKey("KeySIS");
  return retorno;
}