class Client {
  final int? id;
  final String nome;
  final String telefone;
  final String endereco;

  Client({this.id, required this.nome, required this.telefone, required this.endereco});

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'telefone': telefone,
        'endereco': endereco,
      };
}