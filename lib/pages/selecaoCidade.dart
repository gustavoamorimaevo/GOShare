import 'dart:io';

import 'package:goshare/Utilidades/Utilidades.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'homepagemenu.dart';

class SelecaoCidade extends StatefulWidget {
  @override
  SelecaoCidadeState createState() => SelecaoCidadeState();
}

class SelecaoCidadeState extends State<SelecaoCidade> {
  String nomeCidade = "";
  var _cidades = Utilidades.RetornaListaCidade_();
  String? _itemSelecionado = '';

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
  void initState() {
    super.initState();
    try {
      if(Utilidades.cidadeUsuario != null && Utilidades.cidadeUsuario != ""){
        try{
          _itemSelecionado = Utilidades.cidadeUsuario;
          if(!_cidades.contains(_itemSelecionado)){
            _itemSelecionado = "";
          }
        }catch(Exception){
          _itemSelecionado = "";
        }
      }
    } catch (Exception) 
    {

    }
  }

  Future<void> GravaEmArquivoDeConfiguracao() async {
    try
    {
      String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/config.txt');
      text = await file.readAsString();
    } catch (e) {
      text = "";
    }

    if (text != "") {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/config.txt');
      try{
        if(text.split("||").length == 2){
          await file.writeAsString(text+"||"+(_itemSelecionado ?? ""));
        }
        else{
          await file.writeAsString(text.split("||")[0]+"||"+text.split("||")[1]+"||"+(_itemSelecionado ?? ""));
        }
      }
      catch(Exception){

      }
      
    }
    }
    catch(Exception){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utilidades.RetornaCorTema(),
        title: Center(
          child:
              Text('Localização       ', style: TextStyle(color: Colors.black)),
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
        padding: EdgeInsets.only(top: 110, left: 40, right: 40),
        color: Colors.white,
        child: Center(
          child: Align(
            alignment: Alignment.center,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  width: 128,
                  height: 120,
                  child: Image.asset("assets/location.png"),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Selecione sua localização (só serão exibidos estabelecimentos da cidade selecionada):"),
                SizedBox(
                  height: 10,
                ),
                criaDropDownButton(),
                SizedBox(
                  height: 25,
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
                          textAlign: TextAlign.left,
                        ),
                        onPressed: () {
                          Utilidades.cidadeUsuario = _itemSelecionado;
                          if (_itemSelecionado != "") {
                            if (!Utilidades.pageScreenAberta) {
                              Utilidades.timerScreen = true;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePageMenu()
                                ),
                              );
                            } else {
                              Navigator.pop(context);
                            }
                            //GravaEmArquivoDeConfiguracao();
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
