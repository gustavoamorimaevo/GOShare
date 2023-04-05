import 'dart:io';
import 'package:goshare/Utilidades/Utilidades.dart';
import 'package:goshare/pages/video.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:link/link.dart';
//import 'package:url_launcher/url_launcher.dart';

class Sobre extends StatefulWidget {
  @override
  SobreState createState() => SobreState();
}

class SobreState extends State<Sobre> {
  var controladorSobre = TextEditingController();
  bool isOpen = true;
  bool _checkedNotificar = Utilidades.notificarUsuarioNovaMensagem;  
    
  String textoPagesIntagram = "compreaqui_profile";
  String textoPagesEstatisticas = "GoShare\n #CompreAquiDevs";
  String textoPagesContato = "compreaquiaplicativo\n@gmail.com";
  
  String textoLabelPagesIntagram = "Siga a nossa página no Instagram";
  String textoLabelPagesEstatisticas =
      "Veja o feedback dos usuário em nossa página da google play store";
  String textoLabelPagesContato =
      "Envie uma imagem ou reporte um bug em nosso e-mail de contato";

  static const double AnimationWidth = 400.0;
  static const double AnimationHeight = 350.0;

  // _launchURL() async {
  //   const url = 'https://www.instagram.com/supermercadoscompreaquioficial/';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> AlterarEstado(bool estado) async {
    Utilidades.notificarUsuarioNovaMensagem = estado;
    _checkedNotificar = estado;
    try{
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/configNotificacao.txt');
      text = await file.readAsString();
    } catch (e) {
      text = "";
    }

    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/configNotificacao.txt');
    try{
        await file.writeAsString(estado?"true":"false");
    }
    catch(Exception){

    }
    }
    catch(Exception){

    }
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    controladorSobre.text = Utilidades.sobre;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utilidades.RetornaCorTema(),
        title: Center(
          child:
              Text('Mais          ', style: TextStyle(color: Colors.black)),
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
        padding: EdgeInsets.only(top: 40, left: 20, right: 20),
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
            Center(child:Container(child: Text("SOBRE",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)))),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(Utilidades.sobre,
                    maxLines: 30,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
              ),
            ),
            // SizedBox(height: 20),
            // Container(
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: Container(
            //       child: FlatButton(
            //           child: Container(
            //               child: Text(
            //                   "Quer saber mais? Clique aqui para ver o tutorial do aplicativo",
            //                   style: TextStyle(
            //                       fontWeight: FontWeight.bold,
            //                       color: Colors.green))),
            //           onPressed: () {
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) => VideoApp(),
            //                 ));
            //           }),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 40,
            ),
            Center(child:Container(child: Text("INFORMAÇÕES DE CONTATO",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)))),
            SizedBox(
              height: 40,
            ),Container(
                child: Row(children: <Widget>[
              Expanded(child: Text("")),
              Expanded(
                  child: Text(textoPagesIntagram,
                      style:
                          TextStyle(fontSize: 10, color: Colors.purple[700]))),
              SizedBox(height: 10),
              Expanded(
                  child: Text(textoPagesEstatisticas,
                      style:
                          TextStyle(fontSize: 10, color: Colors.purple[700]))),
              SizedBox(height: 10),
              Expanded(
                  child: Text(textoPagesContato,
                      style:
                          TextStyle(fontSize: 10, color: Colors.purple[700]))),
              Expanded(child: Text("")),
            ])),
            SizedBox(height: 5),
            Container(
                height: 50,
                child: Row(children: <Widget>[
                  Expanded(child: Text("")),
                  Expanded(
                      child: Text(textoLabelPagesIntagram,
                          style: TextStyle(
                              fontSize: 8, color: Colors.purple[700]))),
                  SizedBox(height: 10),
                  Expanded(
                      child: Text(textoLabelPagesEstatisticas,
                          style: TextStyle(
                              fontSize: 8, color: Colors.purple[700]))),
                  SizedBox(height: 10),
                  Expanded(
                      child: Text(textoLabelPagesContato,
                          style: TextStyle(
                              fontSize: 8, color: Colors.purple[700]))),
                  Expanded(child: Text("")),
                ])),
            Container(
              width: AnimationWidth,
              height: AnimationHeight,
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!isOpen) {
                        
                        textoPagesIntagram = "@compreaqui_profile\n_profile";
                        textoPagesEstatisticas = " #GoShare\n CompreAquiDevs";

                        textoPagesContato = "compreaquiaplicativo\n@gmail.com";
                        textoLabelPagesIntagram =
                            "Siga a nossa página no Instagram";
                        textoLabelPagesEstatisticas =
                            "Veja o feedback dos usuário em nossa página da google play store";
                        textoLabelPagesContato =
                            "Envie uma imagem ou reporte um bug em nosso e-mail de contato";
                      } else {
                        textoPagesIntagram = "";
                        textoPagesEstatisticas = "";
                        textoPagesContato = "";
                        textoLabelPagesIntagram = "";
                        textoLabelPagesEstatisticas = "";
                        textoLabelPagesContato = "";
                      }
                      isOpen = !isOpen;
                    });
                  },
                  child: FlareActor('assets/button-animation.flr',
                      animation: isOpen ? 'activate' : 'deactivate')),
            ),
            //##BURGDELIVERY ALTERAÇÃO
            //codpigo estava comentado (verificar se alteração da cor está funcionando corretamente)
            Container(child: Text("Alterar cor do app:\n")),
            SizedBox(
              height: 10,
            ),
            Container(
                child: Row(children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset('assets/verde.png')),
                      onPressed: () async {
                        try{
                          final Directory directory = await getApplicationDocumentsDirectory();
                          final File file = File('${directory.path}/configTema.txt');
                          await file.writeAsString("verde");
                          Utilidades.tema = Tema.verde;
                          setState((){});
                        }
                        catch(Exception){
                        } 
                      }),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset('assets/laranjado.png')),
                      onPressed: () async {
                        try{
                          final Directory directory = await getApplicationDocumentsDirectory();
                          final File file = File('${directory.path}/configTema.txt');
                          await file.writeAsString("laranjado");
                          Utilidades.tema = Tema.laranjado;
                          setState((){});
                        }
                        catch(Exception){
                        }
                      }),
                ),
              ),
            ])),
            SizedBox(
              height: 40,
            ),
            Center(child:Container(child: Text("CRÉDITOS",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)))),
            SizedBox(
              height: 40,
            ),Container(child: Text(Utilidades.creditos, style: TextStyle(fontSize: 10))),
            SizedBox(
              height: 60,
            ),
            Container(child: Center(child:Text(Utilidades.numeroVersao)),),
            SizedBox(height: 30),
            Container(
                child: Center(
                    child: Column(children: <Widget>[
              Text("\n© Desenvolvido por CompreAquiDevs",
                  style: TextStyle(fontSize: 10)),
              SizedBox(height: 3),
              Container(
                width: 23,
                height: 23,
                child: Image.asset('assets/compreaquidevs.png'),
              ),
            ]))),
            SizedBox(height: 5),
            // RaisedButton(
            //   onPressed: _launchURL,
            //   child: Text('Veja nossa página no instagram'),
            // ),
            //Link(child: Text('Veja nossa página no instagram'), url: 'https://www.instagram.com/supermercadoscompreaquioficial/'),
          ],
        ),
      ),
    );
  }
}
