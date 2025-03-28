import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_meet/domain/entities/event.dart';
import 'package:my_meet/presentation/blocks/event_bloc.dart';
import 'package:my_meet/presentation/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditEventScreen extends StatefulWidget {
  final String eventId;

  const EditEventScreen({required this.eventId, super.key});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late String userId;
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _geolocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    context.read<EventBloc>().add(LoadEventDetails(userId, widget.eventId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Редактировать мероприятие')),
      body: BlocListener<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventDetailsLoaded) {
            _titleController.text = state.event.title;
            _dateController.text = state.event.date;
            _timeController.text = state.event.time;
            _locationController.text = state.event.location;
            _descriptionController.text = state.event.description;
            _imageUrlController.text = state.event.imageUrl ?? '';
            _geolocationController.text = state.event.geolocation ?? '';
          } else if (state is EventSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Мероприятие обновлено')));
            Navigator.pop(context);
          } else if (state is EventError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Название',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _dateController,
                  enabled: false, // Делаем поле даты нередактируемым
                  decoration: InputDecoration(
                    labelText: 'Дата (yyyy-MM-dd)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: 'Время (HH:mm)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Место',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Описание',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: 'URL картинки (необязательно)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _geolocationController,
                  decoration: InputDecoration(
                    labelText: 'Геолокация (необязательно)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<EventBloc, EventState>(
                  builder: (context, state) {
                    if (state is EventLoading) {
                      return const CircularProgressIndicator();
                    }
                    return Column(
                      children: [
                        CustomButton(
                          text: 'Сохранить',
                          onPressed: () {
                            if (_titleController.text.isEmpty ||
                                _dateController.text.isEmpty ||
                                _timeController.text.isEmpty ||
                                _locationController.text.isEmpty ||
                                _descriptionController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Заполните все обязательные поля')));
                              return;
                            }
                            context.read<EventBloc>().add(UpdateEvent(
                              userId,
                              widget.eventId,
                              _titleController.text,
                              _dateController.text,
                              _timeController.text,
                              _locationController.text,
                              _descriptionController.text,
                            ));
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          text: 'Удалить',
                          onPressed: () {
                            context.read<EventBloc>().add(DeleteEvent(userId, widget.eventId));
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}