class Item {
  int? id;
  String nome;
  int quantidade;
  bool status; // true para 'comprado' e false para 'não comprado'

  Item({this.id, required this.nome, required this.quantidade, this.status = false});

  // Conversão para salvar no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'quantidade': quantidade,
      'status': status ? 1 : 0,
    };
  }

  // Criação de um item a partir de um Map (ao recuperar do banco)
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      nome: map['nome'],
      quantidade: map['quantidade'],
      status: map['status'] == 1,
    );
  }
}
