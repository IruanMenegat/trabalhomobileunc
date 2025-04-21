import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/client.dart';

class ClientScreen extends StatefulWidget {
  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  List<Client> _clients = [];

  void _loadClients() async {
    final clients = await DBHelper.getClients();
    setState(() => _clients = clients);
  }

  void _addClient() async {
    if (_formKey.currentState!.validate()) {
      final client = Client(
        nome: _nomeController.text,
        telefone: _telefoneController.text,
        endereco: _enderecoController.text,
      );
      await DBHelper.insertClient(client);
      _nomeController.clear();
      _telefoneController.clear();
      _enderecoController.clear();
      _loadClients();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clientes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(labelText: 'Nome'),
                    validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
                  ),
                  TextFormField(
                    controller: _telefoneController,
                    decoration: InputDecoration(labelText: 'Telefone'),
                    validator: (value) => value!.isEmpty ? 'Informe o telefone' : null,
                  ),
                  TextFormField(
                    controller: _enderecoController,
                    decoration: InputDecoration(labelText: 'Endereço'),
                    validator: (value) => value!.isEmpty ? 'Informe o endereço' : null,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: _addClient, child: Text('Cadastrar Cliente')),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _clients.length,
                itemBuilder: (context, index) {
                  final client = _clients[index];
                  return ListTile(
                    title: Text(client.nome),
                    subtitle: Text('${client.telefone} - ${client.endereco}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}