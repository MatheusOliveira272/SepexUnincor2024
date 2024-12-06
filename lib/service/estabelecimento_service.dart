import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/model/domain/estabelecimento.dart';

class EstabelecimentoService {
  String userId;

  EstabelecimentoService() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarEstabelecimento(Estabelecimento estabelecimento) async {
    return await _firestore
        .collection("estabelecimentos")
        .doc(estabelecimento.uuid)
        .set(estabelecimento.toMap()); //Dessa maneira somente quem cadastrou o estabelecimento vai poder manipular o conteudo de uma forma geral, para resolver isso devo cadastrar o estabelcimento em uma collection fora do id do usuario e no modal de estabelecimento passar um id ou objeto de usuario para posteriormente buscar e permitir a edição do mesmo por esse id/objeto
  }

  /*Future<void> adicionarObjetoAoObjeto (String idObjeto, Objeto objeto){
    return await _firestore.collection(userId).doc(idObjeto).collection("nome_objeto").doc(objeto.id).set(objeto.toMap); //Estou criando uma coleção dentro do meu objeto principal, digamos que meu estabelecimento tivesse uma certa quantidade de funcionarios, o objeto seria -> Funcionario, e o nome da coleção seria -> funcionarios
  }*/

  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamEstabelecimentosEspecifico(bool isDecrescente){
    return _firestore.collection("estabelecimentos").where("user", isEqualTo: userId).snapshots();//informações vindo ordenandas por nome

  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamEstabelecimentos(bool isDecrescente){
    return _firestore.collection("estabelecimentos").snapshots();//informações vindo ordenandas por nome

  }

  Future<void> removerEstabelecimento({required String idExercicio}){
    return _firestore.collection(userId).doc(idExercicio).delete();
  }
}