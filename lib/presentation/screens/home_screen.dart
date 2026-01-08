import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgmc_app/core/theme/app_theme.dart';
import 'package:sgmc_app/data/models/item_model.dart';
import 'package:sgmc_app/presentation/screens/categories_screen.dart';
import 'package:sgmc_app/presentation/screens/items_screen.dart';
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
              final isSearching = state.homeSearchResults != null;
              final displayItems = isSearching
                  ? state.homeSearchResults!
                  : null;

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

                  // Global Search Bar
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                    child: TextField(
                      onChanged: (query) {
                        context.read<ServiceCubit>().searchInAllData(query);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search providers, specialties, areas...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                    ),
                  ),

                  // Content: Search Results or Governorates List
                  Expanded(
                    child: isSearching
                        ? _buildSearchResults(context, displayItems ?? [])
                        : _buildGovernoratesList(context, state),
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

  Widget _buildGovernoratesList(BuildContext context, ServiceLoaded state) {
    if (state.governorates.isEmpty) {
      return const AppEmptyState(
        icon: Icons.location_off_outlined,
        message: 'No Governorates Found',
        description: 'There are no governorates available at the moment.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
      itemCount: state.governorates.length,
      itemBuilder: (context, index) {
        final governorate = state.governorates[index];
        return AppListCard(
          title: governorate,
          onTap: () {
            context.read<ServiceCubit>().selectGovernorate(governorate);
          },
        );
      },
    );
  }

  Widget _buildSearchResults(BuildContext context, List<ItemModel> items) {
    if (items.isEmpty) {
      return const AppEmptyState(
        icon: Icons.search_off,
        message: 'No Results Found',
        description: 'Try adjusting your search query.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return AppListCard(
          title: item.name,
          subtitle: '${item.specialty} • ${item.city}, ${item.governorate}',
          onTap: () {
            // Set governorate and category, then navigate directly to items
            final cubit = context.read<ServiceCubit>();
            cubit.selectGovernorate(item.governorate);
            cubit.selectProviderType(item.providerType);

            // Navigate directly to ItemsScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: const ItemsScreen(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
