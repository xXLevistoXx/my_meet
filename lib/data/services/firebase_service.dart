import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:my_meet/domain/entities/event.dart';

class FirebaseService {
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<firebase.UserCredential> login(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<firebase.UserCredential> register(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() {
    return _auth.signOut();
  }

  Future<void> createEvent(String userId, String title, String date, String time, String location, String description, {String? imageUrl, String? geolocation}) {
    return _firestore.collection('users').doc(userId).collection('events').add({
      'title': title,
      'date': date,
      'time': time,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'geolocation': geolocation,
    });
  }

  Stream<List<Event>> getEvents(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => _eventFromMap(doc.data(), doc.id)).toList());
  }

  Future<void> updateEvent(String userId, String eventId, String newTitle, String newDate, String newTime, String newLocation, String newDescription) {
    return _firestore.collection('users').doc(userId).collection('events').doc(eventId).update({
      'title': newTitle,
      'date': newDate,
      'time': newTime,
      'location': newLocation,
      'description': newDescription,
    });
  }

  Future<void> deleteEvent(String userId, String eventId) {
    return _firestore.collection('users').doc(userId).collection('events').doc(eventId).delete();
  }

  Future<Event> getEvent(String userId, String eventId) async {
    final doc = await _firestore.collection('users').doc(userId).collection('events').doc(eventId).get();
    if (!doc.exists) throw Exception('Мероприятие не найдено');
    return _eventFromMap(doc.data()!, doc.id);
  }

  Event _eventFromMap(Map<String, dynamic> map, String id) {
    return Event(
      id: id,
      title: map['title'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      location: map['location'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String?,
      geolocation: map['geolocation'] as String?,
    );
  }
}