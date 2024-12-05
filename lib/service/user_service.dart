import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/model/domain/estabelecimento.dart';
import 'package:pin/model/domain/usuario.dart';

class UserService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarColaboradorEstabelecimento(Usuario user, String estabelecimentoId) async{
     await _firestore.collection("estabelecimentos").doc(estabelecimentoId).collection("colaboradores").doc(user.uid).set(user.criaMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamColaboradoresEstabelecimento(bool isDecrescente, String estabelecimentoId){
    return _firestore.collection("estabelecimentos").doc(estabelecimentoId).collection("colaboradores").snapshots();
  }

  Future<void> removeColaborador({required String idColaborador, required String estabelecimentoId}){
    return _firestore.collection("estabelecimentos").doc(estabelecimentoId).collection("colaboradores").doc(idColaborador).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamColaboradoresEstabelecimentoPorId(bool isDecrescente, String estabelecimentoId, String colaboradorId){
    return _firestore.collection("estabelecimentos").doc(estabelecimentoId).collection("colaboradores").where("id",isEqualTo: colaboradorId).snapshots();
  }
}