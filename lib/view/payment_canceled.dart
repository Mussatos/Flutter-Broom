import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/ui-components/icon_button.dart';
import 'package:broom_main_vscode/ui-components/modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PaymentCanceledView extends StatefulWidget {
  const PaymentCanceledView({super.key});

  @override
  State<PaymentCanceledView> createState() => _PaymentCanceledViewState();
}

class _PaymentCanceledViewState extends State<PaymentCanceledView> {
  Future<String?>? checkoutSession;

  Future<void> goToCheckout(context, String cs) async {
    final link = await requestCheckout(cs);
    if (link.isNotEmpty) {
      await launchUrlString(link);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Modal(
              title: 'Erro ao achar pagamento',
              message: 'Você será redirecionado para a listagem de diarista',
              click: () => GoRouter.of(context).push('/List'),
              showOneButton: true,
              mainButtonTitle: 'Ok',
            );
          });
    }
  }

  Future<void> expireCheckoutSession(context, String cs) async {
    final isExpired = await expireCheckout(cs);
    if (isExpired) {
      GoRouter.of(context).push('/List');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Modal(
              title: 'Erro ao cancelar agendamento',
              message: 'Você será redirecionado para a listagem de diarista',
              click: () => GoRouter.of(context).push('/List'),
              showOneButton: true,
              mainButtonTitle: 'Ok',
            );
          });
    }
  }

  @override
  void initState() {
    checkoutSession = autentication.getCheckout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: checkoutSession,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar página'));
              } else if (!snapshot.hasData) {
                return const Center(
                    child: Text('Nenhum link de pagamento encotrado'));
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pagamento pendente',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                            softWrap: true,
                            textWidthBasis: TextWidthBasis.parent,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                          ),
                          Icon(
                            Icons.money_off_csred,
                            color: Color(0xFF2ECC8F),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Detectamos que seu pagamento ainda não foi concluído. Para evitar o cancelamento automático do agendamento, finalize o pagamento dentro de 24 horas.',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        softWrap: true,
                        textWidthBasis: TextWidthBasis.parent,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonIcon(
                            btnText: 'Tentar novamente',
                            btnIcon: Icons.payment,
                            function: () =>
                                goToCheckout(context, snapshot.data)),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonIcon(
                            btnText: 'Cancelar agendamento',
                            btnIcon: Icons.cancel,
                            function: () =>
                                expireCheckoutSession(context, snapshot.data)),
                      ],
                    )
                  ],
                );
              }
            }));
  }
}
