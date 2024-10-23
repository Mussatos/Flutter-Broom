import 'dart:convert';
import 'package:flutter/material.dart';
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

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      // Usando o token passado como argumento
      String token = widget.token ?? '';

      print("token"+token);
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
        final response = await http.post(
          Uri.parse('http://localhost:3000/reset'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'token': token,
            'password': _passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Senha alterada com sucesso!'),
          ));
        } else {
          print("Erro: ${response.body}"); // Log de erro
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Falha ao alterar a senha. Tente novamente.'),
          ));
        }
      } catch (e) {
        print("Erro na requisição: $e"); // Log de erro
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro na conexão. Tente novamente.'),
        ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redefinir Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Nova Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a nova senha';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirmar Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirme a nova senha';
                  }
                  if (value != _passwordController.text) {
                    return 'As senhas não correspondem';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _resetPassword,
                      child: Text('Redefinir Senha'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
