import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pin/model/domain/usuario.dart';
import 'package:pin/service/user_service.dart';
import 'package:pin/view/visao_salao/cadastro_colaborador.dart';
import 'package:pin/view/visao_salao/lista_servico.dart';

class ListaColaborador extends StatefulWidget {
  final String estabelecimentoId;
  ListaColaborador({super.key, required this.estabelecimentoId});
  

  @override
  State<ListaColaborador> createState() => _ListaColaboradorState();
}

class _ListaColaboradorState extends State<ListaColaborador> {

  UserService userService = UserService();
  bool isDecrescente = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                   Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CadastroColaborador(estabelecimentoId: widget.estabelecimentoId,),
                        ));
                  }, 
                  icon: Icon(Icons.person_add))
              ],
            ),
            StreamBuilder(
                  stream: userService.conectarStreamColaboradoresEstabelecimento(isDecrescente, widget.estabelecimentoId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.docs.isNotEmpty) {
                        List<Usuario> listaUsuarios = [];
            
                        for (var doc in snapshot.data!.docs) {
                          listaUsuarios
                              .add(Usuario.fromMap(doc.data()));
                        }
            
                        print(listaUsuarios.length);
            
                        return ListView(
                          shrinkWrap: true,
                          children:
                              List.generate(listaUsuarios.length, (index) {
                            Usuario usuario =
                                listaUsuarios[index];
                            return ListTile(
                              title: Text(usuario.nome),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CadastroColaborador(
                                            estabelecimentoId: widget.estabelecimentoId,
                                          ),
                                        ));
                                  }, icon: Icon(Icons.edit)),
                                  IconButton(
                                    onPressed: (){
                                      SnackBar snackBar = SnackBar(
                                        content: Text("Deseja remover ${usuario.nome}?"),
                                        action: SnackBarAction(label: "Remover", onPressed: (){
                                          userService.removeColaborador(idColaborador: usuario.uid, estabelecimentoId: widget.estabelecimentoId);
                                        },));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }, 
                                    icon: const Icon(Icons.delete))
                                ],
                              ),
                              onTap: () {
                                print(usuario.uid);
                                 Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ListaServico(
                                            estabelecimentoId: widget.estabelecimentoId,
                                            userId: usuario.uid,
                                          ),
                                        ));
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
                  }),
          ],
        ),
      ),
    );
  }
}