import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin/model/domain/servicos.dart';
import 'package:pin/model/widgets/snackbar_exceptions.dart';
import 'package:pin/service/servico_service.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class CadastroServico extends StatefulWidget {
  CadastroServico({Key? key, this.servico, required this.estabelecimentoId, required this.userId}): super(key: key);

  Servicos? servico;
  String estabelecimentoId;
  String userId;

  @override
  State<CadastroServico> createState() => _CadastroServicoState();
}

class _CadastroServicoState extends State<CadastroServico> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();

  final _valorController = TextEditingController();

  bool isServicoNew = false;

  Servicos? servico;

  verificaServicoNovo(Servicos? servico) {
    if (servico == null) {
      setState(() {
      isServicoNew = true;
      

      });
    }else{
      setState(() {
         _nomeController.text = widget.servico!.nome.toString();
      _valorController.text = widget.servico!.valor.toString();
      });
    }
  }

  cadastrar() async {
  try {
    print(widget.userId);
    // Aguarda o cadastro do usuário e captura o UserCredential
    ServicoService servicoService = ServicoService();
    // Exibe mensagem de sucesso
    mostrarSnackbar(context: context, texto: 'Cadastro Efetuado com Sucesso', isErro: false);
        // Adiciona o colaborador ao Firestore
    servico = Servicos(uuid: Uuid().v4(), nome: _nomeController.text, valor: num.tryParse(_valorController.text)!.toDouble(), ativo: true);

    await servicoService.adicionarServicoColaboradorEstaelecimento(widget.estabelecimentoId, widget.userId, servico!);

    print("Servico adicionado com sucesso!");

  } catch (e) {
    // Exibe o erro no Snackbar
    mostrarSnackbar(context: context, texto: 'Erro ao cadastrar: $e', isErro: true);
  }
}

  

  @override
  void initState() {
    verificaServicoNovo(widget.servico);
  }

  


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Cadastro de Serviços'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: "Nome", labelStyle: TextStyle(color: Colors.black)),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Insira um nome!")));
                        }
                      },
                    ),
                    TextFormField(
                      controller: _valorController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: "Valor", labelStyle: TextStyle(color: Colors.black)),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Insira um valor!")));
                        }
                      },
                    ),
                    Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      label: const Text("Salvar"),
                      onPressed: 
                      isServicoNew ? () async{
                        cadastrar();
                      } 
                      : () async{
                        widget.servico!.nome = _nomeController.text;
                        widget.servico!.valor = double.parse(_valorController.text);
                        await ServicoService().adicionarServicoColaboradorEstaelecimento(widget.estabelecimentoId, ServicoService().userId, servico!);
                        Navigator.of(context).pop();
                        setState(() {
                          
                        });
                      } )
                  ],
                ),
              )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
