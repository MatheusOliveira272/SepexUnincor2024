import 'package:flutter/material.dart';
import 'package:pin/model/domain/atendimento.dart';
import 'package:pin/model/domain/estabelecimento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/model/domain/servicos.dart';
import 'package:pin/service/servico_service.dart';
import 'package:pin/service/user_service.dart';
import 'package:uuid/uuid.dart';

class CadastroAtendimento extends StatefulWidget {
  final String estabelecimentoId;

  CadastroAtendimento({super.key, required this.estabelecimentoId});

  @override
  State<CadastroAtendimento> createState() => _CadastroAtendimentoState();
}

class _CadastroAtendimentoState extends State<CadastroAtendimento> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  final ServicoService _servicoService = ServicoService();

  List<String> horariosOcupados = [];
  List<String> horariosDisponiveis = [];
  List<Servicos> servicosSelecionados = [];
  String? horarioSelecionado;
  String? dataSelecionada;
  String? colaboradorSelecionado;
  String? idColaborador;
  String? nomeColaborador;

  final formKey = GlobalKey<FormState>();
  final dataController = TextEditingController();

  @override
  void dispose() {
    dataController.dispose();
    super.dispose();
  }

  List<String> gerarHorarios() {
    List<String> horarios = [];
    DateTime inicio = DateTime(0, 1, 1, 9, 0); // 9:00
    DateTime fim = DateTime(0, 1, 1, 18, 0); // 18:00

    while (inicio.isBefore(fim)) {
      String horarioFormatado =
          "${inicio.hour.toString().padLeft(2, '0')}:${inicio.minute.toString().padLeft(2, '0')}";
      horarios.add(horarioFormatado);
      inicio = inicio.add(Duration(minutes: 45));
    }

    return horarios;
  }

  List<String> filtrarHorariosDisponiveis(
      List<String> horarios, List<String> horariosOcupados) {
    return horarios
        .where((horario) => !horariosOcupados.contains(horario))
        .toList();
  }

  Future<void> verificarHorariosDisponiveis(
      String colaboradorId, DateTime dataSelecionada) async {
    List<String> horarios = gerarHorarios();

    horariosOcupados = await buscarHorariosOcupados(
        colaboradorId, dataSelecionada, widget.estabelecimentoId);

    setState(() {
      horariosDisponiveis =
          filtrarHorariosDisponiveis(horarios, horariosOcupados);
    });
  }

  Future<List<String>> buscarHorariosOcupados(
      String colaboradorId, DateTime data, String estabelecimentoId) async {
    String dataFormatada =
        "${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}";

    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection("estabelecimentos")
        .doc(estabelecimentoId)
        .collection("atendimentos")
        .where("colaboradorId", isEqualTo: colaboradorId)
        .where("data", isEqualTo: dataFormatada)
        .get();

    return snapshot.docs.map((doc) => doc.data()["horario"] as String).toList();
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_picked != null) {
      dataSelecionada =
          "${_picked.year}-${_picked.month.toString().padLeft(2, '0')}-${_picked.day.toString().padLeft(2, '0')}";
      dataController.text = dataSelecionada!;
      if (idColaborador != null) {
        await verificarHorariosDisponiveis(idColaborador!, _picked);
      }
    }
  }

  Future<void> criarAtendimento() async {
    if (servicosSelecionados.isEmpty ||
        horarioSelecionado == null ||
        dataSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    final atendimento = {
      'uuid' : Uuid().v4(),
      'data': dataSelecionada,
      'horario': horarioSelecionado,
      'colaboradorId': idColaborador,
      'clienteId': _servicoService.userId,
      'estabelecimentoId': widget.estabelecimentoId,
      'nomeColaborador': nomeColaborador,
      'servicos': servicosSelecionados.map((s) => s.toMap()).toList(),
    };

    try {
      await _firestore
          .collection("estabelecimentos")
          .doc(widget.estabelecimentoId)
          .collection("atendimentos")
          .add(atendimento);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Atendimento criado com sucesso!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao criar atendimento: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Atendimento"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              items: horariosDisponiveis.map((String horario) {
                return DropdownMenuItem<String>(
                  value: horario,
                  child: Text(horario),
                );
              }).toList(),
              onChanged: (String? novoHorario) {
                setState(() {
                  horarioSelecionado = novoHorario!;
                });
              },
              value: horarioSelecionado,
              hint: Text("Selecione um horário"),
            ),
            StreamBuilder(
                stream: _userService.conectarStreamColaboradoresEstabelecimento(
                    true, widget.estabelecimentoId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('Nenhum colaborador encontrado');
                  }

                  List<DropdownMenuItem<String>> itensDropdown =
                      snapshot.data!.docs.map((doc) {
                    nomeColaborador = doc.data()['nome'];
                    String idColaboradorr = doc.id;

                    return DropdownMenuItem<String>(
                      value: idColaboradorr,
                      child: Text(nomeColaborador!),
                    );
                  }).toList();

                  return DropdownButton<String>(
                    value: colaboradorSelecionado,
                    items: itensDropdown,
                    onChanged: (String? novoValor) {
                      setState(() {
                        colaboradorSelecionado = novoValor;
                        idColaborador = novoValor;
                        if (dataSelecionada != null) {
                          verificarHorariosDisponiveis(
                              idColaborador!, DateTime.parse(dataSelecionada!));
                        }
                      });
                    },
                    hint: Text("Selecione um colaborador"),
                  );
                }),
            if (idColaborador != null)
              StreamBuilder(
                stream: _servicoService
                    .conectarStreamServicosColaboradoresEstabelecimento(
                  true,
                  widget.estabelecimentoId,
                  idColaborador!,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('Nenhum serviço encontrado');
                  }

                  List<Map<String, dynamic>> servicos =
                      snapshot.data!.docs.map((doc) {
                    return {
                      'uuid': doc.id,
                      'nome': doc.data()['nome'],
                      'selecionado': false,
                    };
                  }).toList();

                  return ListView(
                    shrinkWrap: true,
                    children: servicos.map((servico) {
                      return CheckboxListTile(
                        title: Text(servico['nome']),
                        value: servico['selecionado'],
                        onChanged: (bool? value) {
                          setState(() {
                            // Atualize o estado do item selecionado
                            servico['selecionado'] = value!;

                            // Adicione ou remova o serviço selecionado
                            if (value) {
                              print(servico.entries);
                              servicosSelecionados.add(Servicos.fromMap({
                                'uuid': servico[
                                    'uuid'], // Certifique-se de passar o id correto
                                'nome': servico['nome'],
                                'valor': servico['valor'] ?? 0.0,
                                'imagem': servico['imagem'] ?? '',
                                'ativo': servico['ativo'] ?? value,
                              
                              }));
                              print(value);
                              print(servicosSelecionados);
                            } else {
                              servicosSelecionados
                                  .removeWhere((s) => s.uuid == servico['uuid']);
                            }

                            // Atualize a lista completa para disparar a reconstrução
                            servicos = List.from(servicos);
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            TextFormField(
              controller: dataController,
              decoration: InputDecoration(
                label: Text("Data"),
                prefixIcon: Icon(Icons.calendar_today),
                filled: true,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              readOnly: true,
              onTap: _selectDate,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: criarAtendimento,
              child: Text("Confirmar Atendimento"),
            ),
          ],
        ),
      ),
    );
  }
}
