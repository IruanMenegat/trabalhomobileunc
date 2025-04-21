import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/service.dart';

class ServiceScreen extends StatefulWidget {
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorUnitarioController = TextEditingController();
  List<Service> _services = [];

  void _loadServices() async {
    final services = await DBHelper.getServices();
    setState(() => _services = services);
  }

  void _addService() async {
    if (_formKey.currentState!.validate()) {
      final service = Service(
        clientId: 0, 
        descricao: _descricaoController.text,
        data: '', 
        horas: 0,
        valorUnitario: double.parse(_valorUnitarioController.text),
      );
      await DBHelper.insertService(service);
      _descricaoController.clear();
      _valorUnitarioController.clear();
      _loadServices();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Serviços')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _descricaoController,
                    decoration: InputDecoration(labelText: 'Descrição do Serviço'),
                    validator: (value) => value!.isEmpty ? 'Informe a descrição' : null,
                  ),
                  TextFormField(
                    controller: _valorUnitarioController,
                    decoration: InputDecoration(labelText: 'Valor Unitário'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) => value!.isEmpty ? 'Informe o valor' : null,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: _addService, child: Text('Cadastrar Serviço')),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _services.length,
                itemBuilder: (context, index) {
                  final service = _services[index];
                  return ListTile(
                    title: Text(service.descricao),
                    subtitle: Text('Valor: R\$ ${service.valorUnitario.toStringAsFixed(2)}'),
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