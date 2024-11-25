import 'package:broom_main_vscode/user.dart';
import 'package:flutter/material.dart';
import 'package:broom_main_vscode/api/user.api.dart';
import 'package:intl/intl.dart';

class Meetingview extends StatefulWidget {
  int agendamentoId;

  Meetingview({super.key, required this.agendamentoId});

  @override
  State<Meetingview> createState() => _MeetingviewState();
}

class _MeetingviewState extends State<Meetingview> {
  Future<PaymentDetails?>? paymentDetailsFuture;

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

  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    paymentDetailsFuture = fetchUnicContract(widget.agendamentoId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Informações do agendamento',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF2ECC8F),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.black,
            ),
          ),
        ),
        body: FutureBuilder<PaymentDetails?>(
          future: paymentDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar os dados'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Nenhum dado encontrado'));
            } else {
              final paymentDetails = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    //TODO: FALTA PUXAR OS COMODOS E OS SERVIÇOS
                    Text(
                      'Detalhes do Agendamento',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Contratante:',
                        '${paymentDetails.contractorFirstName} ${paymentDetails.contractorLastName}'),
                    _buildDetailRow('Diarista:',
                        '${paymentDetails.diaristFirstName} ${paymentDetails.diaristLastName}'),
                    _buildDetailRow(
                        'Tipo de Limpeza:', paymentDetails.cleaningType ?? ''),
                    _buildDetailRow(
                        'Status do Contrato:',
                        getFormattedStatus(paymentDetails.contractStatus) ??
                            ''),
                    _buildDetailRow('Valor:',
                        'R\$ ${paymentDetails.contractPrice?.toStringAsFixed(2)}'),
                    _buildDetailRow('Status do Pagamento:',
                        paymentDetails.paymentStatus ?? ''),
                    _buildDetailRow('Mensagem:', paymentDetails.message ?? ''),
                    _buildDetailRow(
                      'Data:',
                      paymentDetails.agendamentoDate != null
                          ? dateFormat.format(paymentDetails.agendamentoDate!)
                          : 'Data não disponível',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _handleFinalize(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Finalizar",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _handleRefund(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Reembolso",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _handleFinalize() async {
    await finishContract(widget.agendamentoId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Agendamento Finalizado"),
        content: const Text("O agendamento foi finalizado com sucesso."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  void _handleRefund() async {
    await requestRefund(widget.agendamentoId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Solicitação de Reembolso"),
        content: const Text("A solicitação de reembolso foi enviada."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }
}
