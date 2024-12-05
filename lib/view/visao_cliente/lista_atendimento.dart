import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin/model/domain/atendimento.dart';
import 'package:pin/service/atendimento_service.dart';
import 'package:pin/service/autenticacao_service.dart';
import 'package:pin/service/user_service.dart';
import 'package:pin/view/visao_salao/cadastro_estabelecimento.dart';

class ListaAtendimento extends StatefulWidget {
  ListaAtendimento({super.key, required this.estabelecimentoId, required this.user});
  String estabelecimentoId;
  final User user;

  @override
  State<ListaAtendimento> createState() => _ListaAtendimentoState();
}

class _ListaAtendimentoState extends State<ListaAtendimento> {
  AtendimentoService atendimentoService = AtendimentoService();
  UserService userService = UserService();

  bool? isDecrescente = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("eCut"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Deslogar"),
                onTap: () {
                  AutenticacaoService().deslogar();
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Cadastro Estabelecimento"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastroEstabelecimento(),
                      ));
                },
              ),
              
            ],
          ),
        ),
        body: StreamBuilder(
            stream: atendimentoService.conectarStreamAtendimentoColaborador(true, widget.estabelecimentoId, atendimentoService.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.docs.isNotEmpty) {
                  List<Atendimento> listaAtendimentos = [];

                  for (var doc in snapshot.data!.docs) {
                    listaAtendimentos
                        .add(Atendimento.fromMap(doc.data()));
                  }

                  print(listaAtendimentos.length);

                  return ListView(
                    children:
                        List.generate(listaAtendimentos.length, (index) {
                      Atendimento atendimento =
                          listaAtendimentos[index];
                      return ListTile(
                        title: Text(atendimento.horario),
                        subtitle: Text(
                          
                          atendimento.nomeColaborador),
                       
                        onTap: () {
                          
                        },
                      );
                    }),
                  );
                } else {
                  return const Center(
                    child: Text("Ainda nenhum atendimento 😢"),
                  );
                }
              }
            }));
  } }  