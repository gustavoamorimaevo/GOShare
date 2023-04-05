
import 'dart:async';
import 'package:goshare/Utilidades/Utilidades.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.page.dart';

class Load extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    Utilidades.tema = Tema.laranjado;
    const timeout = const Duration(seconds: 2);
    const ms = const Duration(milliseconds: 1);
        
    void handleTimeout() { 
        Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
        
    }

    startTimeout([int? milliseconds]) {
      var duration = milliseconds == null ? timeout : ms * milliseconds;
      return new Timer(duration, handleTimeout);
    }
    
    startTimeout(3000);
    
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60, left: 40, right: 40),
        color: Colors.green[300],
        child: 
            Center(child:
            Align (alignment: Alignment.center,child: 
            TextButton(
                child: SizedBox(
                  width: 128,
                  height: 128,
                  child: Image.asset("assets/load.png"),
                ),
                onPressed: (){
                },
              )
            ),
          ),
      ),
    );
  }
}