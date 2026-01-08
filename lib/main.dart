import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgmc_app/core/theme/app_theme.dart';
import 'package:sgmc_app/data/data_sources/local_data_source.dart';
import 'package:sgmc_app/data/repositories/service_repository.dart';
import 'package:sgmc_app/logic/cubits/service/cubit/service_cubit.dart';
import 'package:sgmc_app/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ServiceRepository(LocalDataSource());

    return BlocProvider(
      create: (_) => ServiceCubit(repository)..loadData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SGMC Services',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
