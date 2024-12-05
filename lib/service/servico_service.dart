import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/model/domain/estabelecimento.dart';
import 'package:pin/model/domain/servicos.dart';

class ServicoService {

  String userId;

  ServicoService() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarServicoColaboradorEstaelecimento(String estabelecimentoId, String userId, Servicos servico) async {
    return await _firestore.collection("estabelecimentos")
    .doc(estabelecimentoId)
    .collection("colaboradores")
    .doc(userId).collection("servicos")
    .doc(servico.uuid)
    .set(servico.toMap());
 }

 Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamServicosColaboradoresEstabelecimento(bool isDecrescente, String estabelecimentoId, String userId){
    return _firestore.collection("estabelecimentos").doc(estabelecimentoId).collection("colaboradores").doc(userId).collection("servicos").snapshots();
  }

  Future<void> removeServico({required String idColaborador, required String estabelecimentoId, required String servicoId}){
    return _firestore.collection("estabelecimentos").doc(estabelecimentoId).collection("colaboradores").doc(idColaborador).collection("servicos").doc(servicoId).delete();
  }
}