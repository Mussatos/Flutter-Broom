import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/ui-components/icon_button.dart';
import 'package:broom_main_vscode/ui-components/modal.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Meetingview extends StatefulWidget {
  int agendamentoId;
  Meetingview({super.key, required this.agendamentoId});

  @override
  State<Meetingview> createState() => _MeetingviewState();
}

class _MeetingviewState extends State<Meetingview> {
  PaymentDetails? dailyList;
  ListUsers? user;

  Future<void> _handleFinalize(context) async {
    final isFinished = await finishContract(widget.agendamentoId);

    if (isFinished) {
      showDialog(
          context: context,
          builder: (context) => Modal(
                title: "Agendamento Finalizado",
                message: "O agendamento foi finalizado com sucesso.",
                mainButtonTitle: "Fechar",
                showOneButton: true,
                click: () {
                  Navigator.pop(context);
                  setState(() {});
                },
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => Modal(
                title: "Erro ao finalizar agendamento",
                message:
                    "O agendamento só pode ser finalizado a partir da data prevista para o serviço.",
                mainButtonTitle: "Fechar",
                showOneButton: true,
                click: () {
                  Navigator.pop(context);
                },
              ));
    }
  }

  Future<void> _handleRefund(context) async {
    await requestRefund(widget.agendamentoId);
    showDialog(
        context: context,
        builder: (context) => Modal(
              title: "Solicitação de Reembolso",
              message: "A solicitação de reembolso foi enviada.",
              mainButtonTitle: "Fechar",
              showOneButton: true,
              click: () {
                GoRouter.of(context).push('/meeting-page');
              },
            ));
  }

  bool isPendingPayment(int profileId) {
    return dailyList!.contractorPayment!.status == 'processando' &&
        profileId == 1;
  }

  Future<void> retrieveCheckout() async {
    final String sessionUrl =
        await requestCheckout(dailyList!.contractorPayment!.stripeCs);
    if (sessionUrl.isNotEmpty) {
      await launchUrlString(sessionUrl);
    }
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String getFormattedStatus(String? status) {
    switch (status) {
      case 'in_progress':
        return 'Em andamento';
      case 'completed':
        return 'Concluído';
      case 'cancelled':
        return 'Cancelado';
      default:
        return 'Desconhecido';
    }
  }

  String getFormattedBasket(String? basket) {
    switch (basket) {
      case 'cesto_pequeno':
        return 'Cesto pequeno';
      case 'cesto_medio':
        return 'Cesto Médio';
      case 'cesto_grande':
        return 'Cesto Grande';
      default:
        return 'Desconhecido';
    }
  }

  String getFormattedRooms(String? basket) {
    switch (basket) {
      case 'quarto':
        return 'Quarto';
      case 'sala':
        return 'Sala';
      case 'cozinha':
        return 'Cozinha';
      case 'banheiro':
        return 'Banheiro';
      default:
        return 'Desconhecido';
    }
  }

  String getFormattedServices(String? basket) {
    switch (basket) {
      case 'limpeza':
        return 'Limpeza';
      case 'lavar_louca':
        return 'Lavar Louça';
      case 'lavar_roupa':
        return 'Lavar Roupa';
      case 'passar_roupa':
        return 'Passar Roupa';
      case 'organizar_ambiente':
        return 'Organizar Ambientes';
      default:
        return 'Desconhecido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Informações do contrato',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF2ECC8F),
          leading: IconButton(
            onPressed: () {
              GoRouter.of(context).push('/meeting-page');
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: Future.wait({
                fetchUnicContract(widget.agendamentoId),
                autentication.getProfileId(),
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Erro ao carregar agendamentos'));
                } else if (!snapshot.hasData) {
                  return const Center(
                      child: Text('Nenhum agendamentos encontrado'));
                } else {
                  if (snapshot.data?[0] != null) {
                    dailyList = snapshot.data![0] as PaymentDetails;
                  }
                  final address = dailyList!.addressContractor![0];
                  return isPendingPayment(snapshot.data![1] as int)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Você ainda não pagou este agendamento',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                                softWrap: true,
                                textWidthBasis: TextWidthBasis.parent,
                                overflow: TextOverflow.clip,
                              ),
                              const Text(
                                'Caso não pague em até 24 horas o agendamento será cancelado automaticamente.',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ButtonIcon(
                                  btnText: 'Pagar',
                                  btnIcon: Icons.payment,
                                  width: 150,
                                  function: () => retrieveCheckout())
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (snapshot.data?[1] != null &&
                                          snapshot.data![1] == 1) ...[
                                        const Text(
                                          'Ações',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                dailyList!.finished! ||
                                                        dailyList!.refund!
                                                    ? null
                                                    : _handleFinalize(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: dailyList!
                                                            .finished! ||
                                                        dailyList!.refund!
                                                    ? const Color(0xFFBDC3C7)
                                                    : const Color(0xFF1E8449),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 24,
                                                  vertical: 12,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text(
                                                "Finalizar",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                dailyList!.finished! ||
                                                        dailyList!.refund!
                                                    ? null
                                                    : await _handleRefund(
                                                        context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: dailyList!
                                                            .finished! ||
                                                        dailyList!.refund!
                                                    ? const Color(0xFFBDC3C7)
                                                    : const Color(0xFFE74C3C),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 24,
                                                  vertical: 12,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text(
                                                "Reembolso",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                            thickness: 1, color: Colors.grey),
                                      ],
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Detalhes do Agendamento',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 5),
                                      _buildDetailRow('Contratante:',
                                          '${dailyList?.contractorFirstName} ${dailyList?.contractorLastName}'),
                                      _buildDetailRow('Diarista:',
                                          '${dailyList?.diaristFirstName} ${dailyList?.diaristLastName}'),
                                      _buildDetailRow('Tipo de Limpeza:',
                                          dailyList?.cleaningType ?? ''),
                                      _buildDetailRow(
                                          'Status do Contrato:',
                                          getFormattedStatus(
                                                  dailyList?.contractStatus) ??
                                              ''),
                                      _buildDetailRow('Valor:',
                                          'R\$ ${dailyList?.contractPrice?.toStringAsFixed(2)}'),
                                      _buildDetailRow('Status do Pagamento:',
                                          dailyList?.paymentStatus ?? ''),
                                      _buildDetailRow('Mensagem:',
                                          dailyList?.message ?? ''),
                                      _buildDetailRow(
                                        'Data:',
                                        dailyList?.agendamentoDate != null
                                            ? DateFormat('dd/MM/yyy').format(
                                                dailyList!.agendamentoDate!)
                                            : 'Data não disponível',
                                      ),
                                      if (dailyList?.addressContractor !=
                                              null &&
                                          dailyList!.addressContractor!
                                              .isNotEmpty) ...[
                                        const SizedBox(height: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Endereço:',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Rua: ${address.street}, ${address.number}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Bairro: ${address.neighborhood}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Cidade: ${address.city}, Estado: ${address.state}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Detalhes do Serviço',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 5),
                                        if (dailyList?.services != null &&
                                            dailyList!
                                                .services!.isNotEmpty) ...[
                                          const Text(
                                            'Serviços a serem realizados:',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 5),
                                          ...dailyList!.services!
                                              .map((service) {
                                            return _buildDetailRow(
                                              'Serviço:',
                                              getFormattedServices(
                                                  service.serviceType ??
                                                      'Nome não disponível'),
                                            );
                                          }).toList(),
                                        ],
                                        if (dailyList?.rooms != null &&
                                            dailyList!.rooms!.isNotEmpty) ...[
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Comôdos a serem limpos:',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 5),
                                          ...dailyList!.rooms!.map((room) {
                                            final quantity = room.roomQnt ?? 0;

                                            return _buildDetailRow('Comôdo: ',
                                                '${getFormattedRooms(room.roomType ?? 'Nome não disponível')}, quantidade: ${quantity.toString()}');
                                          }).toList(),
                                        ],
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Mais Detalhes:',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        _buildDetailRow(
                                          'Tipo de limpeza:',
                                          dailyList?.cleaningType ??
                                              'Não especificado',
                                        ),
                                        _buildDetailRow(
                                          'Possui Animais de Estimação:',
                                          dailyList?.havePets == true
                                              ? 'Sim'
                                              : 'Não',
                                        ),
                                        _buildDetailRow(
                                          'Possui Materiais de Limpeza:',
                                          dailyList?.includesCleaningMaterial ==
                                                  true
                                              ? 'Sim'
                                              : 'Não',
                                        ),
                                        if (dailyList?.washingBasketQnt !=
                                                null &&
                                            dailyList!.washingBasketQnt! >
                                                0) ...[
                                          _buildDetailRow(
                                            'Tipo de cesto (Lavar):',
                                            getFormattedBasket(
                                                dailyList?.washingBasketType ??
                                                    'Não especificado'),
                                          ),
                                          _buildDetailRow(
                                            'Quantidade:',
                                            dailyList?.washingBasketQnt
                                                    ?.toString() ??
                                                'Não especificado',
                                          ),
                                        ],
                                        if (dailyList?.ironingBasketQnt !=
                                                null &&
                                            dailyList!.ironingBasketQnt! >
                                                0) ...[
                                          _buildDetailRow(
                                            'Tipo de cesto (Passar):',
                                            getFormattedBasket(
                                                dailyList?.ironingBasketType ??
                                                    'Não especificado'),
                                          ),
                                          _buildDetailRow(
                                            'Quantidade:',
                                            dailyList?.ironingBasketQnt
                                                    .toString() ??
                                                'Não especificado',
                                          ),
                                        ]
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        );
                }
              }),
        ),
      ),
    );
  }
}
