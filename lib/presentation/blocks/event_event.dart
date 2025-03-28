part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();
  @override
  List<Object> get props => [];
}

class LoadEvents extends EventEvent {
  final String userId;
  LoadEvents(this.userId);
  @override
  List<Object> get props => [userId];
}

class CreateEvent extends EventEvent {
  final String userId;
  final String title;
  final String date;
  final String time;
  final String location;
  final String description;
  final String? imageUrl;
  final String? geolocation;

  CreateEvent(this.userId, this.title, this.date, this.time, this.location, this.description, {this.imageUrl, this.geolocation});
  @override
  List<Object> get props => [userId, title, date, time, location, description, imageUrl ?? '', geolocation ?? ''];
}

class UpdateEvent extends EventEvent {
  final String userId;
  final String eventId;
  final String newTitle;
  final String newDate;
  final String newTime;
  final String newLocation;
  final String newDescription;

  UpdateEvent(this.userId, this.eventId, this.newTitle, this.newDate, this.newTime, this.newLocation, this.newDescription);
  @override
  List<Object> get props => [userId, eventId, newTitle, newDate, newTime, newLocation, newDescription];
}

class DeleteEvent extends EventEvent {
  final String userId;
  final String eventId;
  DeleteEvent(this.userId, this.eventId);
  @override
  List<Object> get props => [userId, eventId];
}

class LoadEventDetails extends EventEvent {
  final String userId;
  final String eventId;

  LoadEventDetails(this.userId, this.eventId);

  @override
  List<Object> get props => [userId, eventId];
}