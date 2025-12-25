import 'package:mrpos/core/models/reservation.dart';

abstract class ReservationsState {
  const ReservationsState();
}

class ReservationsInitial extends ReservationsState {
  final List<Reservation> reservations;
  final DateTime selectedDate;

  ReservationsInitial({this.reservations = const [], DateTime? selectedDate})
    : selectedDate = selectedDate ?? DateTime.now();

  List<Reservation> get reservationsForSelectedDate {
    return reservations.where((reservation) {
      return reservation.reservationDate.year == selectedDate.year &&
          reservation.reservationDate.month == selectedDate.month &&
          reservation.reservationDate.day == selectedDate.day;
    }).toList();
  }
}

class ReservationsLoading extends ReservationsState {
  const ReservationsLoading();
}

class ReservationsError extends ReservationsState {
  final String message;

  const ReservationsError(this.message);
}
