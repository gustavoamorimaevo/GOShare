import 'dart:io';
import 'package:goshare/Utilidades/Utilidades.dart';
import 'package:goshare/models/usuario.dart';
import 'package:goshare/pages/pedidos.dart';
import 'package:goshare/pages/selecaoCidade.dart';
import 'package:goshare/pages/signup.page.edit.dart';
import 'package:goshare/pages/sobre.dart';
import 'package:goshare/pages/termosuso.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'avaliar.dart';
import 'editarSenha.dart';

class DrawerWidget extends StatefulWidget {

  @override
  _DrawerWidgetState createState() => new _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  int itemSelecionada = 0;
  
  void IrParaInicio() {
    try {
      
    } catch (Exception) {}
  }

  void IrParaTermosUso() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TermosUso(),
        ),
      );
    } catch (Exception) {}
  }

  void IrParaSobre() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>Sobre(),
        ),
      );
    } catch (Exception) {}
  }

  void IrParaPedidos() {
    try {
      Utilidades.consultaPedidos = false;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Pedidos(),
        ),
      );
    } catch (Exception) {}
  }

  void IrParaEdicao() {
    try {
      Utilidades.carregamantoInicialEdicaoUsuario = true;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupPageEdit(),
        ),
      );
    } catch (Exception) {}
  }

  void IrParaEdicaoSenha() {
    try {
      Utilidades.carregamantoInicialEdicaoUsuario = true;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EdicaoSenha(),
        ),
      );
    } catch (Exception) {}
  }

  void IrParaLocalizacao() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelecaoCidade(),
        ),
      );
      //Navigator.pop(context);
    } catch (Exception) {}
  }
  
  void IrParaAvaliacao() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Avaliacao(),
        ),
      );
    } catch (Exception) {}
  }

  Widget _avatar() {
    try {
      return Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(""),
            Text(""),
            Container(width: 45, height:45,child: Image.asset('assets/perfil_logo.png')),
            
            Row(children: <Widget>[
              Text("                                          voltar"),
              Container(child: Icon(Icons.arrow_right, color: Colors.black))
            ]),
            Container(
              height: 12.0,
            ),
            Text(
              "Olá "+(Utilidades.usuarioLogado.nome == null
                  ? (Utilidades.usuarioLogado.login ?? '')
                  : (Utilidades.usuarioLogado.nome) ?? '')+"!"
                  ,
              style: 
              GoogleFonts.mcLaren(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black),
            ),
            Text((Utilidades.usuarioLogado.email?.length ?? 0) > 33 ? 
              ((Utilidades.usuarioLogado.email?.toString().substring(0,33) ?? '') +"...") : 
              (Utilidades.usuarioLogado.email ?? ""), style: TextStyle(fontSize: 11)),
          ],
        ),
      );
    } catch (Exception) {
      return Container();
    }
  }

//Cria uma listview com os itens do menu
  Widget _listMenu() {
    try {
      return ListView(
        children: <Widget>[
          _avatar(), 
          _tiles("INÍCIO", false,Icons.home, 0, 
          () {
            IrParaInicio();
          }
          ),
          _tiles("PEDIDOS", Utilidades.novaMensagem, Icons.shop, 1, () {
            IrParaPedidos();
          }),
          _tiles("EDITAR PERFIL",(Utilidades.usuarioLogado.cidade == null || Utilidades.usuarioLogado.cidade == "") ? true: false, Icons.people, 2, () {
            IrParaEdicao();
          }),
          _tiles("ALTERAR SENHA", false,Icons.build, 2, () {
            IrParaEdicaoSenha();
          }),
          //Row(children: <Widget>[
            _tiles("TERMOS DE USO", false,Icons.bookmark, 4, () {
              IrParaTermosUso();
            }),
            //Container(child: Text("     Voltar>>"))
          //]),
          // _tiles("LOCALIZAÇÃO", false,Icons.map, 7, () {
          //   IrParaLocalizacao();
          // }),
          _tiles("AVALIAÇÃO", false,Icons.star, 8, () {
            IrParaAvaliacao();
          }),
          _tiles("MAIS", false,Icons.add, 5, () {
            IrParaSobre();
          }),
          Divider(),
          _tiles("SAIR", false,Icons.arrow_back, 3, () {
            Utilidades.pageScreenAberta = false;
            if(Utilidades.selecaoCidadeAutomatica){
              Navigator.pop(context);
            }
            else{
              Navigator.pop(context);
              Navigator.pop(context);
            }
            //exit(0);
          }),
        ],
      );
    } catch (Exception) {
      return Container();
    }
  }

Function? a(){

}
//cria cada item do menu
  Widget _tiles(String text, bool notification, IconData icon, int item, Function onTap) {
    
    
    try {
      return ListTile(
        leading: Icon(icon),
        onTap: onTap.call(),
        selected: item == itemSelecionada,
        title: Container(child: Row(children: <Widget> [
          Text(text
            ,style: 
            GoogleFonts.mcLaren(fontSize: 12,fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 5,),
          Container(width: 10, height: 10, child: notification ? Image.asset('assets/ponto_escuro.png') : Text(""))
        ])
        ),
      );
    } catch (Exception) {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Material(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Utilidades.RetornaCorTemaMenu(),
            child: 
                _listMenu()
              ),
      );
    } catch (Exception) {
      return Container();
    }
  }
}
