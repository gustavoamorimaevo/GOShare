import 'package:goshare/Utilidades/Utilidades.dart';
import 'package:flutter/material.dart';

class TermosUso extends StatelessWidget {
  var controladorTermos = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controladorTermos.text = Utilidades.termosUso;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utilidades.RetornaCorTema(),
        title: Center(
          child: Text('Termos de Uso        ',
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
            Center(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(Utilidades.termosUso,
                    maxLines: 300,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    )),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
