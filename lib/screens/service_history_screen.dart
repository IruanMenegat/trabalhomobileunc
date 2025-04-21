import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/service.dart';

class ServiceHistoryScreen extends StatefulWidget {
  @override
  _ServiceHistoryScreenState createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  List<Service> _services = [];
  Map<int, String> _clientNames = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final clients = await DBHelper.getClients();
    final services = await DBHelper.getServices();

    final clientMap = {for (var client in clients) client.id!: client.nome};

    setState(() {
      _services = services;
      _clientNames = clientMap;
    });
  }



    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histórico de Serviços')),
      body: _services.isEmpty
          ? Center(child: Text('Nenhum serviço registrado'))
          : ListView.builder(
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final service = _services[index];
                final clientName = _clientNames[service.clientId] ?? 'Cliente desconhecido';

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(service.descricao),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cliente: $clientName'),
                        Text('Data: ${service.data}'),
                        Text('Horas: ${service.horas}'),
                      ],
                    ),
                    trailing: Text(
                      'R\$ ${service.valorTotal.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
