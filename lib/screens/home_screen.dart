import 'package:flutter/material.dart';
import 'package:trabalho_m1/screens/client_screen.dart';
import 'package:trabalho_m1/screens/service_screen.dart';
import 'register_service_screen.dart';
import 'service_history_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Serviços/Clientes')),
      body: Center(
        child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ElevatedButton(
      child: Text('Clientes'),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClientScreen()),
      ),
    ),
    ElevatedButton(
      child: Text('Serviços'),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServiceScreen()),
      ),
    ),
    ElevatedButton(
      child: Text('Registrar Serviço'),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterServiceScreen()),
      ),
    ),
    ElevatedButton(
      child: Text('Histórico'),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServiceHistoryScreen()),
      ),
    ),
  ],
)
      ),
    );
  }
}