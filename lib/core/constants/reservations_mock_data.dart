import 'package:flutter/material.dart';
import 'package:mrpos/core/models/reservation.dart';

class ReservationsMockData {
  ReservationsMockData._();

  static final List<Reservation> reservations = [
    Reservation(
      id: 'res_1',
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '+1 (123) 456-7890',
      emailAddress: 'john.doe@email.com',
      reservationDate: DateTime.now(),
      reservationTime: const TimeOfDay(hour: 13, minute: 0),
      numberOfGuests: 4,
      status: ReservationStatus.confirmed,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Reservation(
      id: 'res_2',
      firstName: 'Jane',
      lastName: 'Smith',
      phoneNumber: '+1 (234) 567-8901',
      emailAddress: 'jane.smith@email.com',
      reservationDate: DateTime.now(),
      reservationTime: const TimeOfDay(hour: 17, minute: 0),
      numberOfGuests: 2,
      status: ReservationStatus.confirmed,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Reservation(
      id: 'res_3',
      firstName: 'Michael',
      lastName: 'Johnson',
      phoneNumber: '+1 (345) 678-9012',
      emailAddress: 'michael.j@email.com',
      reservationDate: DateTime.now(),
      reservationTime: const TimeOfDay(hour: 19, minute: 0),
      numberOfGuests: 6,
      status: ReservationStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Reservation(
      id: 'res_4',
      firstName: 'Sarah',
      lastName: 'Williams',
      phoneNumber: '+1 (456) 789-0123',
      emailAddress: 'sarah.w@email.com',
      reservationDate: DateTime.now(),
      reservationTime: const TimeOfDay(hour: 15, minute: 0),
      numberOfGuests: 3,
      status: ReservationStatus.confirmed,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    Reservation(
      id: 'res_5',
      firstName: 'David',
      lastName: 'Brown',
      phoneNumber: '+1 (567) 890-1234',
      emailAddress: 'david.brown@email.com',
      reservationDate: DateTime.now(),
      reservationTime: const TimeOfDay(hour: 11, minute: 0),
      numberOfGuests: 2,
      status: ReservationStatus.confirmed,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
}
