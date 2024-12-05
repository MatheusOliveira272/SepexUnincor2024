class Endereco {
  String uuid;
  String logradouro;
  int numero;
  String? complemento;
  String bairro;
  String cidade;
  String estado;
  String cep;
  
  
  Endereco({required this.uuid, required this.logradouro, required this.numero, this.complemento, required this.bairro, required this.cidade, required this.estado, required this.cep});

  Map<String, dynamic> toMap(){
    return {"id": uuid, "logradouro": logradouro, "numero": numero, "complemento": complemento, "bairro": bairro, "cidade": cidade, "estado": estado, "cep": cep};
  }

  factory Endereco.fromMap(Map<String, dynamic> map) {
    return Endereco(uuid: map['id'], logradouro: map['logradouro'], numero: map['numero'], complemento: map['complemento'], bairro: map['bairro'], cidade: map['cidade'], estado: map['estado'], cep: map['cep']);
  }
}