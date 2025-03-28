part of 'event_bloc.dart';

abstract class EventState extends Equatable {
  const EventState();
  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<Event> events;
  EventLoaded(this.events);
  @override
  List<Object> get props => [events];
}

class EventSuccess extends EventState {}

class EventError extends EventState {
  final String message;
  EventError(this.message);
  @override
  List<Object> get props => [message];
}

class EventDetailsLoaded extends EventState {
  final Event event;

  EventDetailsLoaded(this.event);

  @override
  List<Object> get props => [event];
}
