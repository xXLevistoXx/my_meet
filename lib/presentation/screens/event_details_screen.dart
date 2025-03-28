import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_meet/domain/entities/event.dart';
import 'package:my_meet/presentation/blocks/event_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;

  const EventDetailsScreen({required this.eventId, super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    if (context.read<EventBloc>().state is! EventDetailsLoaded) {
      context.read<EventBloc>().add(LoadEventDetails(userId, eventId));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Детали мероприятия')),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventDetailsLoaded) {
            final event = state.event;
            return Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Дата: ${event.date}'),
                      Text('Время: ${event.time}'),
                      Text('Место: ${event.location}'),
                      const SizedBox(height: 8),
                      Text(event.description),
                      if (event.imageUrl != null && event.imageUrl!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Image.network(
                          event.imageUrl!,
                          errorBuilder: (context, error, stackTrace) => const Text('Ошибка загрузки изображения'),
                        ),
                      ],
                      if (event.geolocation != null && event.geolocation!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text('Геолокация: ${event.geolocation}'),
                      ],
                    ],
                  ),
                ),
              ),
            );
          } else if (state is EventError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}