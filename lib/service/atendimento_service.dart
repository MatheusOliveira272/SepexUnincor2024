import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/model/domain/atendimento.dart';
import 'package:pin/model/domain/servicos.dart';

class AtendimentoService {
  String userId;

  AtendimentoService() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarAtendimentoEstabelecimentoColaboradorUsuario(String estabelecimentoId, Atendimento atendimento) async {
    return await _firestore.collection("estabelecimentos")
    .doc(estabelecimentoId)
    .collection("clientes")
    .doc(userId)
    .collection("atendimentos")
    .doc(atendimento.uuid)
    .set(atendimento.toMap());
 }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamAtendimentoUsuario(bool isDecrescente, String estabelecimentoId, String colaboradorId){
    return _firestore.collection("estabelecimentos")
    .doc(estabelecimentoId)
    .collection("atendimentos")
    .where("colaboradorId", isEqualTo: colaboradorId)
    .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamAtendimentoColaborador(bool isDecrescente, String estabelecimentoId, String userId){
    return _firestore.collection("estabelecimentos")
    .doc(estabelecimentoId)
    .collection("atendimentos")
    .where("clienteId", isEqualTo: userId)
    .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamAtendimentosColaboradorDia(bool isDecrescente, String estabelecimentoId, String colaboradorId, String data){
    return _firestore.collection("estabelecimentos")
    .doc(estabelecimentoId)
    .collection("atendimentos")
    .where("colcaboradorId", isEqualTo: colaboradorId)
    .where("data", isEqualTo: data)
    .snapshots();
  }
  
}