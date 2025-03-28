import '../repositories/event_repository.dart';

class CreateEventUseCase {
  final EventRepository repository;

  CreateEventUseCase(this.repository);

  Future<void> call(String userId, String title, String date, String time, String location, String description, {String? imageUrl, String? geolocation}) {
    return repository.createEvent(userId, title, date, time, location, description, imageUrl: imageUrl, geolocation: geolocation);
  }
}