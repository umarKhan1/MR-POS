import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/authentication/presentation/bloc/auth_cubit.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_cubit.dart';

class AppProviders {
  AppProviders._();

  static List<BlocProvider> get providers => [
    BlocProvider<AuthCubit>(
      create: (context) => AuthCubit()..checkAuthStatus(),
    ),
    BlocProvider<OrdersCubit>(create: (context) => OrdersCubit()..loadOrders()),
  ];
}
