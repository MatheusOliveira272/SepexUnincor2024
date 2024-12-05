import 'package:flutter/material.dart';
import 'package:pin/model/domain/servicos.dart';
import 'package:pin/service/autenticacao_service.dart';
import 'package:pin/service/servico_service.dart';
import 'package:pin/view/visao_salao/cadastro_servico.dart';

class ListaServico extends StatefulWidget {
  String estabelecimentoId;
  String userId;

  ListaServico({super.key, required this.userId, required this.estabelecimentoId});

  @override
  State<ListaServico> createState() => _CadastroServicoState();
}

class _CadastroServicoState extends State<ListaServico> {
    bool isDecrescente = true;
  List<Servicos> servicos = [];
  bool loading = true;
  ServicoService servicoService = ServicoService();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: const Text('Servicos Cadastrados'),
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Deslogar"),
                    onTap: (){
                      AutenticacaoService().deslogar();
                    },
                  )
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    print(widget.userId);
                   Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CadastroServico(estabelecimentoId: widget.estabelecimentoId, userId: widget.userId,),
                        ));
                  }, 
                  icon: Icon(Icons.cut))
              ],
            ),
            StreamBuilder(
                  stream: servicoService.conectarStreamServicosColaboradoresEstabelecimento(isDecrescente, widget.estabelecimentoId, widget.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.docs.isNotEmpty) {
                        List<Servicos> listaServicos = [];
            
                        for (var doc in snapshot.data!.docs) {
                          listaServicos
                              .add(Servicos.fromMap(doc.data()));
                        }
            
                        print(listaServicos.length);
            
                        return ListView(
                          shrinkWrap: true,
                          children:
                              List.generate(listaServicos.length, (index) {
                            Servicos servico =
                                listaServicos[index];
                            return ListTile(
                              title: Text(servico.nome),
                              subtitle: Text(servico.valor.toString()),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CadastroServico(
                                            estabelecimentoId: widget.estabelecimentoId,
                                            userId: widget.userId,
                                          ),
                                        ));
                                  }, icon: Icon(Icons.edit)),
                                  IconButton(
                                    onPressed: (){
                                      SnackBar snackBar = SnackBar(
                                        content: Text("Deseja remover ${servico.nome}?"),
                                        action: SnackBarAction(label: "Remover", onPressed: (){
                                          servicoService.removeServico(idColaborador: widget.userId, estabelecimentoId: widget.estabelecimentoId, servicoId: servico.uuid);
                                        },));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }, 
                                    icon: const Icon(Icons.delete))
                                ],
                              ),
                              onTap: () {
                                
                              },
                            );
                          }),
                        );
                      } else {
                        return const Center(
                          child: Text("Ainda nenhum Servico 😢"),
                        );
                      }
                    }
                  }),
          ],
        ),
            )),
      ),
    );
  }
}
