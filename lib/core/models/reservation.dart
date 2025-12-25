import 'package:flutter/material.dart';

enum ReservationStatus {
  confirmed,
  pending,
  cancelled;

  String get displayName {
    switch (this) {
      case ReservationStatus.confirmed:
        return 'Confirmed';
      case ReservationStatus.pending:
        return 'Pending';
      case ReservationStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case ReservationStatus.confirmed:
        return Colors.green;
      case ReservationStatus.pending:
        return Colors.orange;
      case ReservationStatus.cancelled:
        return Colors.grey;
    }
  }
}

class Reservation {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String emailAddress;
  final DateTime reservationDate;
  final TimeOfDay reservationTime;
  final int numberOfGuests;
  final ReservationStatus status;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.emailAddress,
    required this.reservationDate,
    required this.reservationTime,
    required this.numberOfGuests,
    required this.status,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  Reservation copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? emailAddress,
    DateTime? reservationDate,
    TimeOfDay? reservationTime,
    int? numberOfGuests,
    ReservationStatus? status,
    DateTime? createdAt,
  }) {
    return Reservation(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      reservationDate: reservationDate ?? this.reservationDate,
      reservationTime: reservationTime ?? this.reservationTime,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
