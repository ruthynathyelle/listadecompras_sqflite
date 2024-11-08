import 'package:flutter/material.dart';
import 'package:listasqflite/view/homePage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ListaComprasPage(),
    );
  }
}
