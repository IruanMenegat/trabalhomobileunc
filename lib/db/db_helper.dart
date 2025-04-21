import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/client.dart';
import '../models/service.dart';

class DBHelper {
  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'clientes_servicos.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE clients(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            telefone TEXT,
            endereco TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE services(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            clientId INTEGER,
            descricao TEXT,
            data TEXT,
            horas INTEGER,
            valorUnitario REAL,
            valorTotal REAL,
            FOREIGN KEY (clientId) REFERENCES clients(id)
          )
        ''');
      },
      version: 1,
    );
  }

  static Future<int> insertClient(Client client) async {
    final db = await _getDB();
    return await db.insert('clients', client.toMap());
  }

  static Future<List<Client>> getClients() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('clients');
    return List.generate(maps.length, (i) => Client(
      id: maps[i]['id'],
      nome: maps[i]['nome'],
      telefone: maps[i]['telefone'],
      endereco: maps[i]['endereco'],
    ));
  }

  static Future<int> insertService(Service service) async {
    final db = await _getDB();
    return await db.insert('services', service.toMap());
  }

  static Future<List<Service>> getServices() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('services');
    return List.generate(maps.length, (i) => Service(
      id: maps[i]['id'],
      clientId: maps[i]['clientId'],
      descricao: maps[i]['descricao'],
      data: maps[i]['data'],
      horas: maps[i]['horas'],
      valorUnitario: maps[i]['valorUnitario'],
    ));
  }
}