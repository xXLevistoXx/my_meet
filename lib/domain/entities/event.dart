class Event {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String description;
  final String? imageUrl;
  final String? geolocation;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    this.imageUrl,
    this.geolocation,
  });
}