import 'package:flutter/material.dart';

mostrarSnackbar(
  {
    required BuildContext context,
    required String texto,
    bool isErro = true
  }){
    SnackBar snackBar = SnackBar(
      content: Text(texto),
      backgroundColor: (isErro) ? Colors.red : Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(6))),
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
        label: "x",
        textColor: Colors.white, 
        onPressed: (){
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }