import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/view/meetingView.dart';
import 'package:flutter/material.dart';

class Usermeeting extends StatefulWidget {
  const Usermeeting({Key? key}) : super(key: key);

  @override
  State<Usermeeting> createState() => _UsermeetingState();
}

class _UsermeetingState extends State<Usermeeting> {
  Future<List<ListDailys>>? dailyList;

  @override
  void initState() {
    dailyList = fetchMeetings();
    super.initState();
  }

  String getFullNameDiarist(ListDailys listInfos) {
    return '${listInfos.diaristFirstName} ${listInfos.diaristLastName}';
  }

  String getFullNameContractor(ListDailys listInfos) {
    return '${listInfos.contractorFirstName} ${listInfos.contractorLastName}';
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Meus Agendamentos',
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
          body: FutureBuilder<List<ListDailys>>(
            future: dailyList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar usuários'));
              } else {
                List<ListDailys> dailys = snapshot.data!;
                print('listMeeting $dailys');
                return ListView.builder(
                  itemCount: dailys.length,
                  itemBuilder: (context, index) {
                    ListDailys daily = dailys[index];
                    return ListTile(
                      titleTextStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                      subtitleTextStyle: const TextStyle(
                          color: Color(0xFF2ECC8F),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          decorationColor: Color(0xFF2ECC8F),
                          decoration: TextDecoration.overline),
                      title: Text(getFullNameDiarist(daily)),
                      subtitle: Text(getFullNameContractor(daily)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Meetingview()));
                      },
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}
