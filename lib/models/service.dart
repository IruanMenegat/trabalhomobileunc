class Service {
  final int? id;
  final int clientId;
  final String descricao;
  final String data;
  final int horas;
  final double valorUnitario;
  double get valorTotal => horas * valorUnitario;

  Service({this.id, required this.clientId, required this.descricao, required this.data, required this.horas, required this.valorUnitario});

  Map<String, dynamic> toMap() => {
        'id': id,
        'clientId': clientId,
        'descricao': descricao,
        'data': data,
        'horas': horas,
        'valorUnitario': valorUnitario,
        'valorTotal': valorTotal,
      };
}