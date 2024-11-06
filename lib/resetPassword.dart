import 'dart:convert';
import 'package:broom_main_vscode/api/user.api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {
  final String? token;

  ResetPasswordScreen({Key? key, required this.token}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      String token = widget.token ?? '';

      if (token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Token inválido ou ausente.'),
        ));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final isReset = await resetPassword(token, _passwordController.text);
        if (isReset) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Senha alterada com sucesso!'),
          ));
        } else {
          throw Exception();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Falha ao alterar a senha. Tente novamente..'),
        ));
      } finally {
        setState(() {
          _isLoading = false;
          //TODO -> Depois vocês veêm se ficou muito escroto com isso ou se e melhor levar o usuário direto pra tela
          Future.delayed(Duration(seconds: 1), () {
            GoRouter.of(context).push('/login');
          });
          ;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2ECC8F),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Redefina sua senha",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPasswordField(
                      label: 'Nova Senha',
                      controller: _passwordController,
                      errorText: passwordError,
                      onChanged: (value) {
                        setState(() {
                          passwordError =
                              value.isEmpty ? 'Insira uma senha' : null;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    _buildPasswordField(
                      label: 'Confirmar Senha',
                      controller: _confirmPasswordController,
                      errorText: confirmPasswordError,
                      onChanged: (value) {
                        setState(() {
                          confirmPasswordError =
                              value != _passwordController.text
                                  ? 'As senhas não correspondem'
                                  : null;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white), // Cor do carregador
                          )
                        : SizedBox(
                            width: 350,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _resetPassword,
                              child: Text('Redefinir Senha'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    String? errorText,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: 350,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            errorText: errorText,
            labelStyle: TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          style: TextStyle(color: Colors.white),
          obscureText: true,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
