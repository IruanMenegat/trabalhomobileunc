import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/client.dart';
import '../models/service.dart';

class RegisterServiceScreen extends StatefulWidget {
  @override
  _RegisterServiceScreenState createState() => _RegisterServiceScreenState();
}

class _RegisterServiceScreenState extends State<RegisterServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  Client? _selectedClient;
  Service? _selectedService;
  final _dataController = TextEditingController();
  final _horasController = TextEditingController();
  double _valorUnitario = 0.0;
  double _valorTotal = 0.0;

  List<Client> _clients = [];
  List<Service> _services = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final clients = await DBHelper.getClients();
    final services = await DBHelper.getServices();
    setState(() {
      _clients = clients;
      _services = services;
    });
  }

  void _calcularValorTotal() {
    final horas = int.tryParse(_horasController.text) ?? 0;
    setState(() {
      _valorTotal = horas * _valorUnitario;
    });
  }

  void _salvarServicoRealizado() async {
    if (_formKey.currentState!.validate() && _selectedClient != null && _selectedService != null) {
      final service = Service(
        clientId: _selectedClient!.id!,
        descricao: _selectedService!.descricao,
        data: _dataController.text,
        horas: int.parse(_horasController.text),
        valorUnitario: _valorUnitario,
      );

      await DBHelper.insertService(service);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Serviço registrado')));
      _formKey.currentState!.reset();
      setState(() {
        _selectedClient = null;
        _selectedService = null;
        _valorUnitario = 0.0;
        _valorTotal = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Serviço Realizado')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Client>(
                value: _selectedClient,
                items: _clients.map((client) {
                  return DropdownMenuItem(value: client, child: Text(client.nome));
                }).toList(),
                onChanged: (client) => setState(() => _selectedClient = client),
                decoration: InputDecoration(labelText: 'Cliente'),
                validator: (value) => value == null ? 'Selecione um cliente' : null,
              ),
              DropdownButtonFormField<Service>(
                value: _selectedService,
                items: _services.map((service) {
                  return DropdownMenuItem(value: service, child: Text(service.descricao));
                }).toList(),
                onChanged: (service) {
                  setState(() {
                    _selectedService = service;
                    _valorUnitario = service?.valorUnitario ?? 0.0;
                    _calcularValorTotal();
                  });
                },
                decoration: InputDecoration(labelText: 'Serviço'),
                validator: (value) => value == null ? 'Selecione um serviço' : null,
              ),
              TextFormField(
                controller: _dataController,
                decoration: InputDecoration(labelText: 'Data (dd/mm/aaaa)'),
                validator: (value) => value!.isEmpty ? 'Informe a data' : null,
              ),
              TextFormField(
                controller: _horasController,
                decoration: InputDecoration(labelText: 'Horas Trabalhadas'),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calcularValorTotal(),
                validator: (value) => value!.isEmpty ? 'Informe as horas' : null,
              ),
              SizedBox(height: 10),
              Text('Valor Unitário: R\$ ${_valorUnitario.toStringAsFixed(2)}'),
              Text('Valor Total: R\$ ${_valorTotal.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _salvarServicoRealizado, child: Text('Registrar')),
            ],
          ),
        ),
      ),
    );
  }
}
