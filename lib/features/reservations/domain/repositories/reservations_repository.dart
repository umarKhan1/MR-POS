import 'package:mrpos/core/models/reservation.dart';

abstract class ReservationsRepository {
  Stream<List<Reservation>> getReservations(DateTime date);
  Future<void> addReservation(Reservation reservation);
  Future<void> updateReservation(Reservation reservation);
  Future<void> deleteReservation(String id);
}
