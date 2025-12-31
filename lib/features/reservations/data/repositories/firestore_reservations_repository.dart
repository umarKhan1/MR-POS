import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mrpos/core/models/reservation.dart';
import 'package:mrpos/features/reservations/domain/repositories/reservations_repository.dart';

class FirestoreReservationsRepository implements ReservationsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _collection = _firestore.collection(
    'reservations',
  );

  @override
  Stream<List<Reservation>> getReservations(DateTime date) {
    // We store the date as ISO string, so we filter by the date part
    final dateStr = DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String().split('T')[0];

    return _collection
        .where('reservationDate', isGreaterThanOrEqualTo: dateStr)
        .where(
          'reservationDate',
          isLessThan: DateTime(
            date.year,
            date.month,
            date.day + 1,
          ).toIso8601String().split('T')[0],
        )
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Reservation.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        });
  }

  @override
  Future<void> addReservation(Reservation reservation) async {
    await _collection.add(reservation.toMap());
  }

  @override
  Future<void> updateReservation(Reservation reservation) async {
    await _collection.doc(reservation.id).update(reservation.toMap());
  }

  @override
  Future<void> deleteReservation(String id) async {
    await _collection.doc(id).delete();
  }
}
