import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/ui-components/icon_button.dart';
import 'package:broom_main_vscode/ui-components/modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  Future<int?>? profileId;

  @override
  void initState() {
    profileId = autentication.getProfileId();
    super.initState();
  }

  void goToBankInfo(context) {
    GoRouter.of(context).push('/bank/information');
  }

  void goToFavorites(context) {
    GoRouter.of(context).push('/favorite-page');
  }

  void goToMeetingPage(context){
    GoRouter.of(context).push('/meeting-page');
  }

  void confirmLogout(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Modal(
            title: 'Deseja sair da sua sessão atual?',
            message:
                'Você será redirecionado para a tela principal, tem certeza disso?',
            click: () => GoRouter.of(context).push('/logout'),
            showOneButton: false,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: const Color(0xFF2ECC8F),
          appBar: AppBar(
            title: const Text(
              'Configurações',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {
                GoRouter.of(context).push('/List');
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
          body: FutureBuilder(
            future: profileId,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ButtonIcon(
                            btnText: 'Meus Favoritos',
                            btnIcon: Icons.favorite,
                            function: () => goToFavorites(context)),
                        SizedBox(
                          height: 10,
                        ),
                        ButtonIcon(
                          btnText: "Meus agendamentos", 
                          btnIcon: Icons.calendar_month, 
                          function: () => goToMeetingPage(context)
                        ),
                        SizedBox(
                          height: 10
                        ),
                        if (snapshot.data == 2)...[
                          ButtonIcon(
                            btnIcon: Icons.monetization_on_outlined,
                            btnText: 'Informações bancárias',
                            function: () => goToBankInfo(context),
                          ),
                        SizedBox(
                          height: 10,
                        ),  
                        ],
                        ButtonIcon(
                            btnText: 'Sair',
                            btnIcon: Icons.logout,
                            function: () => confirmLogout(context)
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
