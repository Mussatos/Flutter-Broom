import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/ui-components/icon_button.dart';
import 'package:broom_main_vscode/ui-components/modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PaymentSuccessView extends StatefulWidget {
  const PaymentSuccessView({super.key});

  @override
  State<PaymentSuccessView> createState() => _PaymentSuccessViewState();
}

class _PaymentSuccessViewState extends State<PaymentSuccessView> {
  Future<String?>? whatsappUrl;

  Future<void> sendContract(String link, context) async {
    if (link.isNotEmpty) {
      await launchUrlString(link);
      GoRouter.of(context).push('/List');
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Modal(
            title: 'Erro ao enviar contrato',
            message: 'Você será redirecionado para a listagem de diarista',
            click: () => GoRouter.of(context).push('/List'),
            showOneButton: true,
            mainButtonTitle: 'Ok',
          );
        });
  }

  @override
  void initState() {
    whatsappUrl = autentication.getWhatsappLink();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: whatsappUrl,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar finalização'));
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text('Nenhum link de contrato encontrado'));
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pagamento Realizado com sucesso!!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 10,),
                    Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF2ECC8F),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonIcon(
                        btnText: 'Enviar contrato',
                        btnIcon: Icons.send_rounded,
                        function: () => sendContract(snapshot.data, context)),
                  ],
                )
              ],
            );
          }
        },
      ),
    );
  }
}
