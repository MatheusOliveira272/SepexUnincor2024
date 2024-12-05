
import 'package:pin/model/domain/servicos.dart';

class Atendimento {

  String uuid;
  String colaboradorId;
  String clienteId;
  String nomeColaborador;
  String data;
  String horario;
  List<Servicos> servicos; 
  
  Atendimento({required this.uuid, required this.nomeColaborador, required this.colaboradorId, required this.data, required this.horario, required this.servicos, required this.clienteId});

  Map<String, dynamic> toMap(){
    return {"id": uuid,  "colaboradorId": colaboradorId, "data": data, "horario": horario, "servicos": servicos.map((servico) => servico.toMap()).toList(), "cliente": clienteId};
  }

  factory Atendimento.fromMap(Map<String, dynamic> map) {
    return Atendimento(uuid: map['uuid'], nomeColaborador: map['nomeColaborador'], clienteId: map['clienteId'], colaboradorId: map['colaboradorId'], data: map['data'], horario: map['horario'], servicos: (map['servicos'] as List)
        .map((item) => Servicos.fromMap(item as Map<String, dynamic>))
        .toList(),);
  }
}