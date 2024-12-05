class Servicos {
  String uuid;
  String nome;
  double valor;
  String? imagem;
  bool? ativo;

  Servicos({required this.uuid, required this.nome, required this.valor, this.imagem, required this.ativo});

  Map<String, dynamic> toMap(){
     return {"nome": nome, "uuid": uuid,  "valor": valor, "imagem": imagem, "ativo": ativo};
  }

  factory Servicos.fromMap(Map<String, dynamic> map) {
    return Servicos(nome: map['nome'], uuid: map['uuid'], valor: double.tryParse(map['valor'].toString()) ?? 0.0 , imagem: map['imagem'], ativo: true);
  }
}