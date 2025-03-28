import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_meet/domain/entities/event.dart';
import 'package:my_meet/presentation/blocks/auth_bloc.dart';
import 'package:my_meet/presentation/blocks/event_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String userId;
  List<Event>? events;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    context.read<EventBloc>().add(LoadEvents(userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Meet'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EventLoaded) {
            events = state.events;
          }

          if (events == null) {
            return Center(child: CircularProgressIndicator());
          }

          if (events!.isEmpty) {
            return Center(child: Text('Нет мероприятий'));
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  eventLoader: (day) {
                    return events!.where((event) => event.date == day.toString().split(' ')[0]).toList();
                  },
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isNotEmpty) {
                        bool hasFuture = _hasFutureEvents(day);
                        return Container(
                          margin: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasFuture ? Colors.brown : Colors.green,
                          ),
                          width: 8.0,
                          height: 8.0,
                        );
                      }
                      return null;
                    },
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    final eventsOnDay = events!.where((event) => event.date == selectedDay.toString().split(' ')[0]).toList();
                    if (eventsOnDay.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Мероприятия на ${selectedDay.toString().split(' ')[0]}'),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: ListView(
                              shrinkWrap: true,
                              children: eventsOnDay.map((event) => ListTile(
                                title: Text(event.title),
                                subtitle: Text(event.description),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(context, '/edit_event', arguments: event.id);
                                      },
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(context, '/event_details', arguments: event.id);
                                      },
                                      child: Text('Подробности'),
                                    ),
                                  ],
                                ),
                              )).toList(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Закрыть'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create_event'),
        child: Icon(Icons.add),
      ),
    );
  }

  bool _hasFutureEvents(DateTime day) {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return events!.any((event) {
      final eventDay = DateTime.parse(event.date);
      return eventDay.isAfter(today) || isSameDay(eventDay, today);
    });
  }
}