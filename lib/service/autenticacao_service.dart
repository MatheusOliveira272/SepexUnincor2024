import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AutenticacaoException implements Exception{
  String message;
  AutenticacaoException(this.message);
}

class AutenticacaoService {
      FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> cadastrarUsuario(
      {
        required String nome, 
        required String senha, 
        required String email
      }) async{
       try{ 
        
          }on FirebaseAuthException catch (e){
            if(e.code == "email-already-in-use"){
              return "Email já em uso!";
            }
             else if(e.code == "weak-password"){
              return "Senha fraca!";
            };
          }
      }

  Future<String?> logarUsuario({
        required String nome, 
        required String senha, 
        required String email,
      }) async {
       try{ 
        await _firebaseAuth.signInWithEmailAndPassword(email: email, password: senha);
       } on FirebaseAuthException catch(e) {
        return e.message;
       }
      }

  Future<void> deslogar(){
    return _firebaseAuth.signOut();
  }

}
