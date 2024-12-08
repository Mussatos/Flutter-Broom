import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/view/meetingView.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class Usermeeting extends StatefulWidget {
  const Usermeeting({Key? key}) : super(key: key);

  @override
  State<Usermeeting> createState() => _UsermeetingState();
}

class _UsermeetingState extends State<Usermeeting> {
  Future<List<ListDailys>>? dailyList;
  int? profileId;

  @override
  void initState() {
    dailyList = fetchMeetings();
    super.initState();
    fetchUserById().then((_) {
      setState(() {});
    });
  }

  Future<Yourself?> fetchUserById() async {
    profileId = await autentication.getProfileId();
    return await getUserById();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Em andamento' || 'processando':
        return Colors.orange;
      case 'Concluído' || 'pago':
        return Colors.green;
      case 'Cancelado' || 'reembolso':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getFormattedStatus(String status) {
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

  String getDataMeeting(ListDailys listInfos) {
    if (listInfos.agendamentoDate != null) {
      DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      return dateFormat.format(listInfos.agendamentoDate!);
    } else {
      return 'Data não disponível';
    }
  }

  String getStatusPayment(ListDailys listInfos) {
    return '${listInfos.paymentStatus}';
  }

  Widget getStatus(ListDailys listInfos) {
    final paymentStatus = getStatusPayment(listInfos);
    final contractStatus = getFormattedStatus(listInfos.contractStatus!);
    return Column(children: [
      Row(
        children: [
          const Text('Status do contrato: '),
          Text(
            contractStatus,
            style: TextStyle(
              color: getStatusColor(contractStatus),
            ),
          ),
        ],
      ),
      Row(
        children: [
          const Text('Status do pagamento: '),
          Text(
            paymentStatus,
            style: TextStyle(
              color: getStatusColor(paymentStatus),
            ),
          ),
        ],
      ),
    ]);
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFF2ECC8F),
          appBar: AppBar(
            title: const Text(
              'Meus Agendamentos',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                GoRouter.of(context).push('/account/settings');
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 24,
                color: Colors.black,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<ListDailys>>(
                  future: dailyList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF2ECC8F)));
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text('Erro ao carregar usuários'));
                    } else {
                      List<ListDailys> dailys = snapshot.data!;
                      return ListView.builder(
                        itemCount: dailys.length,
                        itemBuilder: (context, index) {
                          ListDailys daily = dailys[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              titleTextStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                              subtitleTextStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              title: Text(getDataMeeting(daily)),
                              subtitle: getStatus(daily),
                              trailing: const Icon(
                                Icons.event_note,
                                color: Colors.black,
                                size: 30,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Meetingview(
                                            agendamentoId:
                                                daily.agendamentoId!)));
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              if (profileId == 1) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                         GoRouter.of(context).push('/List');
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: [
                           Icon(
                            Icons.add,
                            size: 30, 
                          ),
                          SizedBox(
                              width: 8), 
                          Text(
                            'Agende aqui o seu serviço!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold, 
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 32.0),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ));
  }
}
