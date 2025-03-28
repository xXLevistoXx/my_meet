import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_meet/presentation/blocks/event_bloc.dart';
import 'package:my_meet/presentation/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _geolocationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Создать мероприятие')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
              SizedBox(height: 10),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Дата (yyyy-MM-dd)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Время (HH:mm)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Место',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'URL картинки (необязательно)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _geolocationController,
                decoration: InputDecoration(
                  labelText: 'Геолокация (необязательно)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              SizedBox(height: 20),
              BlocConsumer<EventBloc, EventState>(
                listener: (context, state) {
                  if (state is EventSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Мероприятие создано')));
                    Navigator.pop(context);
                  } else if (state is EventError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  if (state is EventLoading) {
                    return CircularProgressIndicator();
                  }
                  return CustomButton(
                    text: 'Создать',
                    onPressed: () {
                      if (_titleController.text.isEmpty || _dateController.text.isEmpty || _timeController.text.isEmpty || _locationController.text.isEmpty || _descriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Заполните все обязательные поля')));
                        return;
                      }
                      final userId = FirebaseAuth.instance.currentUser!.uid;
                      context.read<EventBloc>().add(CreateEvent(
                        userId,
                        _titleController.text,
                        _dateController.text,
                        _timeController.text,
                        _locationController.text,
                        _descriptionController.text,
                        imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
                        geolocation: _geolocationController.text.isNotEmpty ? _geolocationController.text : null,
                      ));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}