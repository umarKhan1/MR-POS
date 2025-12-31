import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/models/reservation.dart';
import 'package:mrpos/features/reservations/domain/repositories/reservations_repository.dart';
import 'package:mrpos/features/reservations/presentation/cubit/reservations_state.dart';

class ReservationsCubit extends Cubit<ReservationsState> {
  final ReservationsRepository _repository;
  StreamSubscription? _reservationsSubscription;

  ReservationsCubit(this._repository)
    : super(ReservationsInitial(selectedDate: DateTime.now()));

  void loadReservations() {
    emit(const ReservationsLoading());
    _subscribeToReservations(
      (state is ReservationsInitial)
          ? (state as ReservationsInitial).selectedDate
          : DateTime.now(),
    );
  }

  void _subscribeToReservations(DateTime date) {
    _reservationsSubscription?.cancel();
    _reservationsSubscription = _repository
        .getReservations(date)
        .listen(
          (reservations) {
            emit(
              ReservationsInitial(
                reservations: reservations,
                selectedDate: date,
              ),
            );
          },
          onError: (error) {
            emit(ReservationsError(error.toString()));
          },
        );
  }

  void selectDate(DateTime date) {
    emit(const ReservationsLoading());
    _subscribeToReservations(date);
  }

  Future<void> addReservation(Reservation reservation) async {
    try {
      await _repository.addReservation(reservation);
    } catch (e) {
      emit(ReservationsError(e.toString()));
    }
  }

  Future<void> updateReservation(Reservation reservation) async {
    try {
      await _repository.updateReservation(reservation);
    } catch (e) {
      emit(ReservationsError(e.toString()));
    }
  }

  Future<void> deleteReservation(String id) async {
    try {
      await _repository.deleteReservation(id);
    } catch (e) {
      emit(ReservationsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _reservationsSubscription?.cancel();
    return super.close();
  }
}
