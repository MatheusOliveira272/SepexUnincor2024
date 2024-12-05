import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/model/domain/endereco.dart';

class Estabelecimento {
  String uuid;
  String nome;
  String? urlImagem;
  Endereco endereco;
  String userId;
  
  
  Estabelecimento({required this.uuid, required this.nome, required this.endereco, this.urlImagem, required this.userId});

  Map<String, dynamic> toMap(){
    return {"id": uuid,  "nome": nome, "endereco": endereco.toMap(), "urlImagem": urlImagem, "user": userId};
  }

  factory Estabelecimento.fromMap(Map<String, dynamic> map) {
    return Estabelecimento(uuid: map['id'], nome: map['nome'], urlImagem: map["urlImagem"], endereco: Endereco.fromMap(map['endereco']), userId: map['user']);
  }
}