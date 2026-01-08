import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgmc_app/core/theme/app_theme.dart';
import 'package:sgmc_app/presentation/screens/categories_screen.dart';
import 'package:sgmc_app/presentation/widgets/app_widgets.dart';
import 'package:sgmc_app/logic/cubits/service/cubit/service_cubit.dart';
import 'package:sgmc_app/logic/cubits/service/cubit/service_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceCubit, ServiceState>(
      listenWhen: (previous, current) {
        // Listen when governorate changes (including from one gov to another)
        if (previous is! ServiceLoaded || current is! ServiceLoaded) {
          return false;
        }
        // Trigger when selectedGovernorate changes
        return previous.selectedGovernorate != current.selectedGovernorate &&
            current.selectedGovernorate != null;
      },
      listener: (context, state) {
        // Navigate to categories AFTER state is updated
        if (state is ServiceLoaded && state.selectedGovernorate != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<ServiceCubit>(),
                child: const CategoriesScreen(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Select Governorate'), elevation: 0),
        body: BlocBuilder<ServiceCubit, ServiceState>(
          builder: (context, state) {
            if (state is ServiceLoading) {
              return const AppLoadingIndicator(
                message: 'Loading governorates...',
              );
            }

            if (state is ServiceLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose Your Location',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppDimensions.spacingSmall),
                        Text(
                          'Select a governorate to view available services',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // Governorates List
                  Expanded(
                    child: state.governorates.isEmpty
                        ? const AppEmptyState(
                            icon: Icons.location_off_outlined,
                            message: 'No Governorates Found',
                            description:
                                'There are no governorates available at the moment.',
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimensions.paddingSmall,
                            ),
                            itemCount: state.governorates.length,
                            itemBuilder: (context, index) {
                              final governorate = state.governorates[index];
                              return AppListCard(
                                title: governorate,
                                onTap: () {
                                  // Just select governorate, navigation happens in listener
                                  context
                                      .read<ServiceCubit>()
                                      .selectGovernorate(governorate);
                                },
                              );
                            },
                          ),
                  ),
                ],
              );
            }

            if (state is ServiceError) {
              return AppErrorState(
                message: state.message,
                onRetry: () {
                  // Retry loading data
                  context.read<ServiceCubit>().loadData();
                },
              );
            }

            return const AppEmptyState(
              icon: Icons.info_outline,
              message: 'No Data Available',
              description:
                  'Please refresh or contact support if the issue persists.',
            );
          },
        ),
      ),
    );
  }
}
