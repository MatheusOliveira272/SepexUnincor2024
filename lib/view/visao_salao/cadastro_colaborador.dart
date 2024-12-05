import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pin/model/domain/usuario.dart';
import 'package:pin/model/widgets/snackbar_exceptions.dart';
import 'package:pin/service/autenticacao_service.dart';
import 'package:pin/service/user_service.dart';

class CadastroColaborador extends StatefulWidget {
  final String estabelecimentoId;
   CadastroColaborador({super.key, required this.estabelecimentoId});

  @override
  State<CadastroColaborador> createState() => _CadastroColaboradorState();
}

class _CadastroColaboradorState extends State<CadastroColaborador> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final confirmarSenha = TextEditingController();
  final nome = TextEditingController();
  AutenticacaoService _auth = AutenticacaoService();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserService _userService = UserService();

  bool loading = false;

 cadastrar() async {
  try {
    // Aguarda o cadastro do usuário e captura o UserCredential
    UserCredential userCredential = await
        _firebaseAuth.createUserWithEmailAndPassword(
          email: email.text, 
          password: senha.text
          );

          await userCredential.user!.updateDisplayName(nome.text);

    // Exibe mensagem de sucesso
    mostrarSnackbar(context: context, texto: 'Cadastro Efetuado com Sucesso', isErro: false);

    // Cria o objeto Usuario
    Usuario usuario = Usuario(
      uid: userCredential.user!.uid,
      nome: userCredential.user!.displayName ?? nome.text, // Usa o nome fornecido se o displayName for nulo
    );

    // Adiciona o colaborador ao Firestore
    await _userService.adicionarColaboradorEstabelecimento(usuario, widget.estabelecimentoId);

    print("Colaborador adicionado com sucesso!");

  } catch (e) {
    // Exibe o erro no Snackbar
    mostrarSnackbar(context: context, texto: 'Erro ao cadastrar: $e', isErro: true);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100),
          child: Form(
              key: formKey,
              child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Cadastro Cliente",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe o email corretamente';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: TextFormField(
                      controller: senha,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Senha',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe sua senha';
                        } else if (value.length < 6) {
                          return 'Sua senha deve ter no mínimo 6 caracteres';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: TextFormField(
                      controller: confirmarSenha,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirmar Senha',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Confirme sua senha!';
                        } else if (value != senha.text) {
                          return 'Senhas não coincidem';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: TextFormField(
                      controller: nome,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe seu nome';
                        } 
                        return null;
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(24),
                      child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cadastrar();
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: (loading)
                                ? [
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ]
                                : [
                                    Icon(Icons.check),
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        "Cadastrar",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    )
                                  ],
                          ))),
                ],
              )             ),
        ),
      ),
    );
  }
}