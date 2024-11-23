import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendarypage extends StatefulWidget {
  int idDoUser;

  Calendarypage({super.key, required this.idDoUser});

  @override
  _CalendarypageState createState() => _CalendarypageState();
}

class _CalendarypageState extends State<Calendarypage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedOption = 'diaria_completa';
  int? idDoContract;
  Future<List<dynamic>>? listTypeDailyRate;

  Future<void> fetchContract() async {
    idDoContract = await autentication.getUserId();
  }

  @override
  void initState() {
    super.initState();
    listTypeDailyRate = fetchDailyRateType();
  }

  Future<void> _saveEventToBackend({
    required DateTime date,
    required String type,
    required int idDoUser,
  }) async {
    try {
      await fetchContract();

      if (idDoContract == null) {
        throw Exception("ID do contratante não encontrado.");
      }
      await Future.delayed(const Duration(seconds: 1));
      print('Salvando no backend:');
      print('Data: $date');
      print('Tipo: $type');
      print('Id Diarista: $idDoUser');
      print('Id Contratante: $idDoContract');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Evento salvo com sucesso para $date'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar evento: $e'),
        ),
      );
    }
    postAgendamento(
        dataAgendamento: date, diaristaId: idDoUser, tipoDiaria: type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agendamento',
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
      body: FutureBuilder(
          future: listTypeDailyRate,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Erro ao carregar o agendamento'));
            } else {
              List<dynamic>? ListDailyType = snapshot.data;
              return Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      }
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_selectedDay != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Data Selecionada: ${_selectedDay!.toLocal()}"
                                .split(' ')[0],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          DropdownButton<String>(
                            value: _selectedOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value!;
                              });
                            },
                            items: ListDailyType!
                                .map((option) => DropdownMenuItem<String>(
                                      value: option['value'],
                                      child: Text(option['text']),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_selectedDay != null) {
                          await _saveEventToBackend(
                              date: _selectedDay!,
                              type: _selectedOption!,
                              idDoUser: widget.idDoUser);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Por favor, selecione uma data.'),
                            ),
                          );
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2ECC8F),
                      ),
                      child: Text(
                        'Salvar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              );
            }
          }),
    );
  }
}