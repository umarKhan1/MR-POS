import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/authentication/presentation/bloc/auth_cubit.dart';
import 'package:mrpos/features/menu/data/repositories/firestore_menu_repository.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:mrpos/features/notifications/domain/repositories/notification_repository.dart';
import 'package:mrpos/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:mrpos/features/orders/data/repositories/orders_repository.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:mrpos/features/reservations/presentation/cubit/reservations_cubit.dart';

import 'package:mrpos/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:mrpos/shared/theme/theme_cubit.dart';

class AppProviders {
  AppProviders._();

  static List<BlocProvider> get providers => [
    BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
    BlocProvider<AuthCubit>(
      create: (context) => AuthCubit()..checkAuthStatus(),
    ),
    BlocProvider<NotificationCubit>(
      create: (context) =>
          NotificationCubit(repository: NotificationRepository()),
    ),
    BlocProvider<MenuCubit>(
      create: (context) => MenuCubit(FirestoreMenuRepository()),
    ),
    BlocProvider<OrdersCubit>(
      create: (context) => OrdersCubit(
        repository: OrdersRepository(),
        notificationCubit: context.read<NotificationCubit>(),
      )..loadOrders(),
    ),
    BlocProvider<DashboardCubit>(
      create: (context) =>
          DashboardCubit(OrdersRepository(), FirestoreMenuRepository()),
    ),
    BlocProvider<ReservationsCubit>(
      create: (context) => ReservationsCubit()..loadReservations(),
    ),
  ];
}
