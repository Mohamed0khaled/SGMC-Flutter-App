import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgmc_app/core/theme/app_theme.dart';
import 'package:sgmc_app/presentation/screens/items_screen.dart';
import 'package:sgmc_app/presentation/widgets/app_widgets.dart';
import 'package:sgmc_app/logic/cubits/service/cubit/service_cubit.dart';
import 'package:sgmc_app/logic/cubits/service/cubit/service_state.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ServiceCubit, ServiceState>(
          builder: (context, state) {
            if (state is ServiceLoaded && state.selectedGovernorate != null) {
              return Text(state.selectedGovernorate!);
            }
            return const Text('Categories');
          },
        ),
      ),
      body: BlocBuilder<ServiceCubit, ServiceState>(
        builder: (context, state) {
          print('🎨 Categories Screen - State: ${state.runtimeType}');
          
          if (state is! ServiceLoaded) {
            return const AppLoadingIndicator(
              message: 'Loading categories...',
            );
          }

          final categories = state.providerTypes;
          print('🎨 Categories count: ${categories.length}');
          print('🎨 Categories: $categories');

          if (categories.isEmpty) {
            return const AppEmptyState(
              icon: Icons.category_outlined,
              message: 'No Categories Available',
              description: 'No service categories found in this governorate.',
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Categories',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppDimensions.spacingSmall),
                    Text(
                      '${categories.length} categories available',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingSmall,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return AppListCard(
                      title: category,
                      onTap: () {
                        context.read<ServiceCubit>().selectProviderType(category);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ItemsScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
