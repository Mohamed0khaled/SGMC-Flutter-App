import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgmc_app/core/localization/app_localizations.dart';
import 'package:sgmc_app/core/theme/app_theme.dart';
import 'package:sgmc_app/data/models/item_model.dart';
import 'package:sgmc_app/presentation/screens/categories_screen.dart';
import 'package:sgmc_app/presentation/screens/item_details_screen.dart';
import 'package:sgmc_app/presentation/screens/settings_screen.dart';
import 'package:sgmc_app/presentation/widgets/app_widgets.dart';
import 'package:sgmc_app/logic/cubits/service/cubit/service_cubit.dart';
import 'package:sgmc_app/logic/cubits/service/cubit/service_state.dart';
import 'package:sgmc_app/logic/cubits/settings/settings_cubit.dart';
import 'package:sgmc_app/logic/cubits/settings/settings_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen to language changes and reload data
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) {
            if (previous is! SettingsLoaded || current is! SettingsLoaded) {
              return false;
            }
            return previous.locale != current.locale;
          },
          listener: (context, state) {
            if (state is SettingsLoaded) {
              context.read<ServiceCubit>().updateLanguage(state.locale.languageCode);
            }
          },
        ),
        // Listen to governorate selection for navigation
        BlocListener<ServiceCubit, ServiceState>(
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
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).selectGovernorate),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ServiceCubit, ServiceState>(
          builder: (context, state) {
            if (state is ServiceLoading) {
              return AppLoadingIndicator(
                message: AppLocalizations.of(context).loadingGovernorates,
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

                  // Global Search Bar
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                    child: TextField(
                      onChanged: (query) {
                        context.read<ServiceCubit>().searchInAllData(query);
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).searchProviders,
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
      return AppEmptyState(
        icon: Icons.location_off_outlined,
        message: AppLocalizations.of(context).noGovernoratesFound,
        description: AppLocalizations.of(context).noGovernoratesDesc,
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
      return AppEmptyState(
        icon: Icons.search_off,
        message: AppLocalizations.of(context).noResultsFound,
        description: AppLocalizations.of(context).noResultsDesc,
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
            // Navigate directly to details screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailsScreen(item: item),
              ),
            );
          },
        );
      },
    );
  }
}
