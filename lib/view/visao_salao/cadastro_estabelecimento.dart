import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin/comum/componentes/minhas_cores.dart';
import 'package:pin/model/domain/endereco.dart';
import 'package:pin/model/domain/estabelecimento.dart';
import 'package:pin/service/estabelecimento_service.dart';
import 'package:uuid/uuid.dart';

class CadastroEstabelecimento extends StatefulWidget {
  Estabelecimento? estabelecimento;

  CadastroEstabelecimento({super.key, this.estabelecimento});

  @override
  State<CadastroEstabelecimento> createState() =>
      _CadastroEstabelecimentoState();
}

class _CadastroEstabelecimentoState extends State<CadastroEstabelecimento> {
  final _nomeController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cepController = TextEditingController();
  final _userId = FirebaseAuth.instance.currentUser!.uid;

  bool isCarregando = false;

  final EstabelecimentoService _estabelecimentoService =
      EstabelecimentoService();

  @override
  void initState() {
    if (widget.estabelecimento != null) {
      _nomeController.text = widget.estabelecimento!.nome;
      _logradouroController.text = widget.estabelecimento!.endereco.logradouro;
      _bairroController.text = widget.estabelecimento!.endereco.bairro;
      _numeroController.text =
          widget.estabelecimento!.endereco.numero.toString();
      _cidadeController.text = widget.estabelecimento!.endereco.cidade;
      _estadoController.text = widget.estabelecimento!.endereco.estado;
      _cepController.text = widget.estabelecimento!.endereco.cep;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.estabelecimento != null)
              ? "Editar ${widget.estabelecimento!.nome}"
              : "Cadastro Estabelecimento",
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        height: MediaQuery.of(context).size.height * 0.9,
        child: Form(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Adicionar Estabelecimento",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                  ],
                ),
                const Divider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _nomeController,
                      decoration: getAuthenticationInputDecoration(
                        "Qual o nome do estabelecimento?",
                        icon: const Icon(Icons.abc),
                      ),
                    ),
                    TextFormField(
                      controller: _logradouroController,
                      decoration: getAuthenticationInputDecoration(
                        "Qual o logradouro do estabelecimento?",
                        icon: const Icon(Icons.home),
                      ),
                    ),
                    TextFormField(
                      controller: _numeroController,
                      decoration: getAuthenticationInputDecoration(
                        "Qual o numero do estabelecimento?",
                      ),
                    ),
                    TextFormField(
                      controller: _bairroController,
                      decoration: getAuthenticationInputDecoration(
                        "Qual o bairro do estabelecimento?",
                      ),
                    ),
                    TextFormField(
                      controller: _cidadeController,
                      decoration: getAuthenticationInputDecoration(
                        "Qual a cidade do estabelecimento?",
                      ),
                    ),
                    TextFormField(
                      controller: _estadoController,
                      decoration: getAuthenticationInputDecoration(
                        "Qual o estado do estabelecimento?",
                      ),
                    ),
                    TextFormField(
                      controller: _cepController,
                      decoration: getAuthenticationInputDecoration(
                        "Qual o cep do estabelecimento?",
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      enviarClicado();
                    },
                    child: (isCarregando)
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text((widget.estabelecimento != null) ? "Editar Estabelecimento": "Criar Estabelecimento"))
              ],
            )
          ],
        )),
      ),
    );
  }

  enviarClicado() {
    setState(() {
      isCarregando = true;
    });
    String nome = _nomeController.text;
    String logradouro = _logradouroController.text;
    String bairro = _nomeController.text;
    String numero = _numeroController.text;
    String cidade = _cidadeController.text;
    String estado = _estadoController.text;
    String cep = _logradouroController.text;
    Endereco endereco = Endereco(
        uuid: Uuid().v4(),
        logradouro: logradouro,
        numero: int.parse(numero),
        bairro: bairro,
        cidade: cidade,
        estado: estado,
        cep: cep);
    Estabelecimento estabelecimento =
        Estabelecimento(uuid: Uuid().v4(), nome: nome, endereco: endereco, userId: _userId);
  if(widget.estabelecimento != null){
          estabelecimento.uuid = widget.estabelecimento!.uuid;
          estabelecimento.endereco.uuid = widget.estabelecimento!.endereco.uuid;
        }
        

    _estabelecimentoService
        .adicionarEstabelecimento(estabelecimento)
        .then((value) {
      setState(() {
        isCarregando = false;
      });
    });
  }
}
