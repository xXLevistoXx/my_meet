import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_meet/domain/entities/event.dart';
import 'package:my_meet/domain/repositories/event_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../main.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository repository;

  EventBloc(this.repository) : super(EventInitial()) {
    on<LoadEvents>((event, emit) async {
      emit(EventLoading());
      try {
        final events = repository.getEvents(event.userId);
        emit(EventLoaded(await events.first));
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });

    on<CreateEvent>((event, emit) async {
      emit(EventLoading());
      try {
        await repository.createEvent(
          event.userId,
          event.title,
          event.date,
          event.time,
          event.location,
          event.description,
          imageUrl: event.imageUrl,
          geolocation: event.geolocation,
        );
        final permissionStatus = await Permission.scheduleExactAlarm.request();
        if (permissionStatus.isGranted) {
          DateTime eventDateTime = DateTime.parse('${event.date} ${event.time}:00').subtract(Duration(minutes: 30));
          await flutterLocalNotificationsPlugin.zonedSchedule(
            eventDateTime.hashCode,
            'Напоминание',
            'Мероприятие "${event.title}" начнется в ${event.time}',
            tz.TZDateTime.from(eventDateTime, tz.local),
            const NotificationDetails(
              android: AndroidNotificationDetails('event_channel', 'Events', channelDescription: 'Notifications for events'),
            ),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
          );
        } else {
          emit(EventError('Не удалось запланировать точное уведомление: разрешение не предоставлено'));
          return;
        }
        emit(EventSuccess());
        add(LoadEvents(event.userId));
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });

    on<UpdateEvent>((event, emit) async {
      emit(EventLoading());
      try {
        await repository.updateEvent(
          event.userId,
          event.eventId,
          event.newTitle,
          event.newDate,
          event.newTime,
          event.newLocation,
          event.newDescription,
        );
        emit(EventSuccess());
        add(LoadEvents(event.userId));
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });

    on<DeleteEvent>((event, emit) async {
      emit(EventLoading());
      try {
        await repository.deleteEvent(event.userId, event.eventId);
        emit(EventSuccess());
        add(LoadEvents(event.userId));
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });

    on<LoadEventDetails>((event, emit) async {
      emit(EventLoading());
      try {
        final eventDetails = await repository.getEvent(event.userId, event.eventId);
        emit(EventDetailsLoaded(eventDetails));
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });
  }
}