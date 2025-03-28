import 'package:my_meet/domain/entities/event.dart';
import 'package:my_meet/domain/repositories/event_repository.dart';
import '../services/firebase_service.dart';

class EventRepositoryImpl implements EventRepository {
  final FirebaseService _service;

  EventRepositoryImpl(this._service);

  @override
  Future<void> createEvent(String userId, String title, String date, String time, String location, String description, {String? imageUrl, String? geolocation}) {
    return _service.createEvent(userId, title, date, time, location, description, imageUrl: imageUrl, geolocation: geolocation);
  }

  @override
  Stream<List<Event>> getEvents(String userId) {
    return _service.getEvents(userId);
  }

  @override
  Future<void> updateEvent(String userId, String eventId, String newTitle, String newDate, String newTime, String newLocation, String newDescription) {
    return _service.updateEvent(userId, eventId, newTitle, newDate, newTime, newLocation, newDescription);
  }

  @override
  Future<void> deleteEvent(String userId, String eventId) {
    return _service.deleteEvent(userId, eventId);
  }

  @override
  Future<Event> getEvent(String userId, String eventId) {
    return _service.getEvent(userId, eventId);
  }
}