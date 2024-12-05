import 'package:flutter/material.dart';
import 'package:pin/model/widgets/snackbar_exceptions.dart';
import 'package:pin/service/autenticacao_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final confirmarSenha = TextEditingController();
  final nome = TextEditingController();

  AutenticacaoService _auth = AutenticacaoService();

  bool isLogin = true;

  late String titulo;
  late String actionButton;
  late String toggleButton;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = 'Bem vindo';
        actionButton = 'Login';
        toggleButton = 'Ainda não tem uma conta? Cadastre-se agora.';
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao login.';
      }
    });
  }

  login() async {
    _auth
        .logarUsuario(nome: nome.text, senha: senha.text, email: email.text)
        .then(
      (String? erro) {
        if (erro != null) {
          mostrarSnackbar(context: context, texto: erro);
        } else {}
      },
    );
  }

  cadastrar() async {
    _auth
        .cadastrarUsuario(nome: nome.text, senha: senha.text, email: email.text)
        .then(
      (String? erro) {
        if (erro != null) {
          mostrarSnackbar(context: context, texto: erro);
        } else {
          mostrarSnackbar(
              context: context,
              texto: 'Cadastro Efetuado com Sucesso',
              isErro: false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            /*Positioned.fill(
                child: Transform.scale(
              scale: 3, // Reduz para 50% do tamanho original
              child: Image.asset('assets/images/background.png'),
            )),*/
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: Form(
                  key: formKey,
                  child: isLogin
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              titulo,
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
                                  } else if (!value.contains('@')) {
                                    return 'Email inválido!';
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
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        login();
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: (loading)
                                          ? [
                                              Padding(
                                                padding: EdgeInsets.all(16),
                                                child: SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child:
                                                      CircularProgressIndicator(
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
                                                  actionButton,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              )
                                            ],
                                    ))),
                            TextButton(
                                onPressed: () => setFormAction(!isLogin),
                                child: Text(toggleButton)),
                            TextButton(
                                onPressed: () => setFormAction(!isLogin),
                                child: Text("Colaborador, entre por aqui!")),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              titulo,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: (loading)
                                          ? [
                                              Padding(
                                                padding: EdgeInsets.all(16),
                                                child: SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child:
                                                      CircularProgressIndicator(
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
                                                  actionButton,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              )
                                            ],
                                    ))),
                            TextButton(
                                onPressed: () => setFormAction(!isLogin),
                                child: Text(toggleButton)),
                          ],
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
