import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin/model/domain/atendimento.dart';
import 'package:pin/model/domain/estabelecimento.dart';
import 'package:pin/service/autenticacao_service.dart';
import 'package:pin/service/estabelecimento_service.dart';
import 'package:pin/view/visao_cliente/cadastro_atendimento.dart';
import 'package:pin/view/visao_cliente/lista_atendimento.dart';
import 'package:pin/view/visao_salao/cadastro_estabelecimento.dart';
import 'package:pin/view/visao_salao/lista_colaborador.dart';

class TelaInicial extends StatefulWidget {
  final User user;
  TelaInicial({super.key, required this.user});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  bool isDecrescente = true;

  final List<Estabelecimento> estabelecimentos = [];

  final EstabelecimentoService estabelecimentoService =
      EstabelecimentoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("eCut"),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isDecrescente = !isDecrescente;
                });
              }, 
              icon: Icon(Icons.sort_by_alpha))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                  //currentAccountPicture: CircleAvatar(backgroundImage: AssetImage(assetName),),
                  accountName: Text((widget.user.displayName != null)
                      ? widget.user.displayName!
                      : ""),
                  accountEmail: Text(widget.user.email!)),
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
            stream: estabelecimentoService.conectarStreamEstabelecimentos(isDecrescente),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.docs.isNotEmpty) {
                  List<Estabelecimento> listaEstabelecimento = [];

                  for (var doc in snapshot.data!.docs) {
                    listaEstabelecimento
                        .add(Estabelecimento.fromMap(doc.data()));
                  }

                  print(listaEstabelecimento.length);

                  return ListView(
                    children:
                        List.generate(listaEstabelecimento.length, (index) {
                      Estabelecimento estabelecimento =
                          listaEstabelecimento[index];
                      return ListTile(
                        title: Text(estabelecimento.nome),
                        subtitle: Text(estabelecimento.endereco.logradouro),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CadastroAtendimento(
                                     estabelecimentoId: estabelecimento.uuid,
                                    ),
                                  ));
                            }, icon: Icon(Icons.add)),
                            IconButton(onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListaAtendimento(
                                     estabelecimentoId: estabelecimento.uuid,
                                     user: widget.user,
                                    ),
                                  ));
                            }, icon: Icon(Icons.near_me)),
                            IconButton(onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CadastroEstabelecimento(
                                      estabelecimento: estabelecimento,
                                    ),
                                  ));
                            }, icon: Icon(Icons.edit)),
                            IconButton(
                              onPressed: (){
                                SnackBar snackBar = SnackBar(
                                  content: Text("Deseja remover ${estabelecimento.nome}?"),
                                  action: SnackBarAction(label: "Remover", onPressed: (){
                                    estabelecimentoService.removerEstabelecimento(idExercicio: estabelecimento.uuid);
                                  },));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }, 
                              icon: const Icon(Icons.delete)),
                               IconButton(onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListaColaborador(
                                      estabelecimentoId: estabelecimento.uuid,
                                    ),
                                  ));
                            }, icon: Icon(Icons.person)),
                          ],
                        ),
                        onTap: () {
                          
                        },
                      );
                    }),
                  );
                } else {
                  return const Center(
                    child: Text("Ainda nenhum estabelecimento 😢"),
                  );
                }
              }
            }));
  }
}
