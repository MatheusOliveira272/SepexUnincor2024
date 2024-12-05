import 'package:firebase_auth/firebase_auth.dart';

class Usuario {
  String uid;
  String nome;
  String? imagem;

  Usuario({required this.uid, required this.nome, this.imagem});

  criaMap() {

      return {"uid":uid ,"nome": nome, "imagem": imagem};
  }

  factory Usuario.fromMap(Map<String, dynamic> map){
    return Usuario(uid: map['uid'], nome: map['nome'], imagem: map['imagem']);
  }


}
