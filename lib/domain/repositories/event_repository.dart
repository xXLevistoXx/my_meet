import '../entities/event.dart';

abstract class EventRepository {
  Future<void> createEvent(String userId, String title, String date, String time, String location, String description, {String? imageUrl, String? geolocation});
  Stream<List<Event>> getEvents(String userId);
  Future<void> updateEvent(String userId, String eventId, String newTitle, String newDate, String newTime, String newLocation, String newDescription);
  Future<void> deleteEvent(String userId, String eventId);
  Future<Event> getEvent(String userId, String eventId);
}