import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/constants/reservations_mock_data.dart';
import 'package:mrpos/core/models/reservation.dart';
import 'package:mrpos/features/reservations/presentation/cubit/reservations_state.dart';

class ReservationsCubit extends Cubit<ReservationsState> {
  ReservationsCubit()
    : super(ReservationsInitial(selectedDate: DateTime.now()));

  void loadReservations() {
    emit(const ReservationsLoading());
    try {
      final currentState = state is ReservationsInitial
          ? state as ReservationsInitial
          : ReservationsInitial(selectedDate: DateTime.now());

      emit(
        ReservationsInitial(
          reservations: ReservationsMockData.reservations,
          selectedDate: currentState.selectedDate,
        ),
      );
    } catch (e) {
      emit(ReservationsError(e.toString()));
    }
  }

  void selectDate(DateTime date) {
    if (state is ReservationsInitial) {
      final currentState = state as ReservationsInitial;
      emit(
        ReservationsInitial(
          reservations: currentState.reservations,
          selectedDate: date,
        ),
      );
    }
  }

  void addReservation(Reservation reservation) {
    if (state is ReservationsInitial) {
      final currentState = state as ReservationsInitial;
      ReservationsMockData.reservations.add(reservation);
      emit(
        ReservationsInitial(
          reservations: List.from(ReservationsMockData.reservations),
          selectedDate: currentState.selectedDate,
        ),
      );
    }
  }

  void updateReservation(Reservation reservation) {
    if (state is ReservationsInitial) {
      final currentState = state as ReservationsInitial;
      final index = ReservationsMockData.reservations.indexWhere(
        (r) => r.id == reservation.id,
      );
      if (index != -1) {
        ReservationsMockData.reservations[index] = reservation;
        emit(
          ReservationsInitial(
            reservations: List.from(ReservationsMockData.reservations),
            selectedDate: currentState.selectedDate,
          ),
        );
      }
    }
  }

  void deleteReservation(String id) {
    if (state is ReservationsInitial) {
      final currentState = state as ReservationsInitial;
      ReservationsMockData.reservations.removeWhere((r) => r.id == id);
      emit(
        ReservationsInitial(
          reservations: List.from(ReservationsMockData.reservations),
          selectedDate: currentState.selectedDate,
        ),
      );
    }
  }
}
