import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  List<dynamic>? ListDailyType;
  bool loading = false;
  late List<dynamic> diaristDatesAlreadyAgended = [];
  late List<dynamic> contractorDatesAlreadyAgended = [];
  late List<dynamic> serviceByDiaristDate = [];

  bool hasAgended = false;

  Future<void> fetchContract() async {
    idDoContract = await autentication.getUserId();
  }

  Future<void> _loadDisabledDates() async {
    setState(() {
      loading = true;
    });
    List<dynamic> fetchedContractorDates = await fetchAgendamentoByContractor();
    List<dynamic> fetchedDates =
        await fetchAgendamentoByDiarist(widget.idDoUser);
    List<dynamic> fetchedServicesByDate =
        await fetchAgendamentoServiceByDiarist(widget.idDoUser);
    setState(() {
      contractorDatesAlreadyAgended = fetchedContractorDates;
      diaristDatesAlreadyAgended = fetchedDates;
      serviceByDiaristDate = fetchedServicesByDate;
      loading = false;
    });
  }

  List<DropdownMenuItem<String>>? getDropDownItens() {
    List<dynamic> service = serviceByDiaristDate.map((dateService) {
      if (dateService['data'].toString().replaceAll('T', ' ') ==
          _selectedDay.toString()) {
        return dateService['tipoDiaria'];
      }
    }).toList();

    service.removeWhere((service) => service == null);

    if (service.isNotEmpty) {
      final list = ListDailyType!.map((option) {
        if (option['value'] != service[0] &&
            option['value'] != 'diaria_completa') {
          return DropdownMenuItem<String>(
            value: option['value'],
            child: Text(option['text']),
          );
        }
        return const DropdownMenuItem<String>(
          value: '',
          child: Text(''),
        );
      }).toList();

      list.removeWhere((list) => list.value!.isEmpty);
      return list;
    } else {
      return ListDailyType!
          .map((option) => DropdownMenuItem<String>(
                value: option['value'],
                child: Text(option['text']),
              ))
          .toList();
    }
  }

  String getTypeServiceByDay() {
    List<dynamic> service = serviceByDiaristDate.map((dateService) {
      if (dateService['data'].toString().replaceAll('T', ' ') ==
          _selectedDay.toString()) {
        return dateService['tipoDiaria'];
      }
    }).toList();

    service.removeWhere((service) => service == null);
    return service.isEmpty ? '' : service[0];
  }

  bool getEnabledDay(DateTime day) {
    return diaristDatesAlreadyAgended.contains(
            DateTime.utc(day.year, day.month, day.day).toIso8601String()) ||
        contractorDatesAlreadyAgended.contains(
            DateTime.utc(day.year, day.month, day.day).toIso8601String());
  }

  bool isDisabledItem(String item) {
    String typeDay = getTypeServiceByDay();
    bool val = false;

    if (typeDay.isNotEmpty) {
      val = item == typeDay || item == 'diaria_completa';
    }
    return val;
  }

  @override
  void initState() {
    super.initState();
    listTypeDailyRate = fetchDailyRateType();
    _loadDisabledDates();
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

      hasAgended = await postAgendamento(
          dataAgendamento: date, diaristaId: idDoUser, tipoDiaria: type);

      if (hasAgended) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Agendamento salvo com sucesso para ${DateFormat('dd/MM/yyyy').format(date)}'),
          ),
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      var dailyTypeSelect = getDailyTypeSelected(type);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Diarista já possui um servico agendado do tipo ${dailyTypeSelect[0]} para este dia'),
        ),
      );
    }
  }

  List<dynamic> getDailyTypeSelected(type) {
    var dailyTypeSelect = ListDailyType!.map((dailyType) {
      if (dailyType['value'] == type) return dailyType['text'];
    }).toList();

    dailyTypeSelect.remove(null);
    dailyTypeSelect.remove(null);
    return dailyTypeSelect;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2ECC8F),
      appBar: AppBar(
        title: Text(
          'Agendamento',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
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
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Erro ao carregar o agendamento'));
            } else {
              ListDailyType = snapshot.data;
              return Column(
                children: [
                  loading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF2ECC8F),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Carregando datas...',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2ECC8F)))
                            ],
                          ),
                        )
                      : TableCalendar(
                          firstDay: DateTime.now(),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          enabledDayPredicate: (day) => !getEnabledDay(day),
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
                          calendarStyle: const CalendarStyle(
                              defaultTextStyle: TextStyle(color: Colors.black),
                              selectedTextStyle: TextStyle(color: Colors.white),
                              todayTextStyle: TextStyle(color: Colors.white),
                              disabledTextStyle: TextStyle(
                                  color: Color.fromARGB(255, 66, 66, 66)),
                              selectedDecoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              weekendTextStyle: TextStyle(color: Colors.black),
                              todayDecoration: BoxDecoration(
                                  color: Colors.blue, shape: BoxShape.circle),
                              outsideTextStyle: TextStyle(color: Colors.black)
                          ),
                              
                        ),
                  const SizedBox(height: 16),
                  if (_selectedDay != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Diária: ${_selectedDay!.toLocal()}"
                                  .split(' ')[0],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          DropdownButton<String>(
                            value: _selectedOption,
                            focusColor:const Color(0xFF2ECC8F) ,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            dropdownColor: const Color(0xFF2ECC8F),
                            
                            onChanged: (value) {
                              final service = getTypeServiceByDay();
                              if (service.isNotEmpty) {
                                setState(() {
                                  _selectedOption = ListDailyType!
                                      .where((type) =>
                                          type['value'] != service &&
                                          type['value'] != 'diaria_completa')
                                      .toList()[0]['value'];
                                });
                                return;
                              }

                              setState(() {
                                _selectedOption = value!;
                              });
                            },
                            items: ListDailyType!
                                .map((option) => DropdownMenuItem<String>(
                                      value: option['value'],
                                      child: Text(
                                        option['text'],
                                        style: TextStyle(
                                            color:
                                                isDisabledItem(option['value'])
                                                    ? Colors.grey
                                                    : null),
                                      ),
                                    ))
                                .toList(),
                            underline: const SizedBox(),
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
                            idDoUser: widget.idDoUser,
                          );
                          hasAgended ? Navigator.pop(context) : null;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor, selecione uma data.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                      ),
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
