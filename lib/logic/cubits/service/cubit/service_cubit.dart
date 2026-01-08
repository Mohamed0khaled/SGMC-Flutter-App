import 'package:bloc/bloc.dart';
import 'package:sgmc_app/data/repositories/service_repository.dart';
import 'package:sgmc_app/logic/cubits/service/cubit/service_state.dart';

/// ServiceCubit - Single Source of Truth for App State
/// Manages the complete data flow: Load → Select Governorate → Select Category → Display Items
class ServiceCubit extends Cubit<ServiceState> {
  final ServiceRepository repository;
  String languageCode;

  ServiceCubit(this.repository, this.languageCode) : super(ServiceInitial());

  /// Load all data from JSON and emit initial state
  /// This is called once when app starts
  Future<void> loadData() async {
    emit(ServiceLoading());

    try {
      // Load complete dataset with language preference
      final items = await repository.getAllItems(languageCode: languageCode);

      // Extract unique governorates
      final governorates = repository.getGovernorates(items);

      // Emit initial state with data loaded
      // providerTypes is empty until governorate is selected
      emit(
        ServiceLoaded(
          items: items,
          governorates: governorates,
          providerTypes: const [], // Empty until governorate selected
          selectedGovernorate: null,
          selectedProviderType: null,
          filteredItems: null,
          groupedItemsByArea: null,
          homeSearchResults: null,
        ),
      );
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  /// Update language and reload data
  Future<void> updateLanguage(String newLanguageCode) async {
    if (languageCode == newLanguageCode) return; // No change needed
    
    languageCode = newLanguageCode;
    await loadData(); // Reload data with new language
  }

  /// Select a governorate and load its provider types (categories)
  /// This method ALWAYS produces a valid providerTypes list
  void selectGovernorate(String governorate) {
    // Guard: ensure we have loaded data
    if (state is! ServiceLoaded) return;

    final current = state as ServiceLoaded;

    print('🔍 DEBUG: Selecting governorate: "$governorate"');
    print('🔍 DEBUG: Total items count: ${current.items.length}');

    // Debug: Check what governorates exist in data
    final uniqueGovs = current.items.map((e) => e.governorate).toSet();
    print('🔍 DEBUG: Unique governorates in data: $uniqueGovs');

    // Extract provider types for this governorate
    // Repository uses normalized comparison to handle case/whitespace issues
    final providerTypes = repository.getProviderTypes(
      current.items,
      governorate,
    );

    print('🔍 DEBUG: Provider types found: ${providerTypes.length}');
    print('🔍 DEBUG: Provider types: $providerTypes');

    // Emit new state with:
    // - Selected governorate
    // - Calculated provider types
    // - Reset all lower-level selections
    emit(
      ServiceLoaded(
        items: current.items,
        governorates: current.governorates,
        providerTypes: providerTypes, // CRITICAL: This must contain data
        selectedGovernorate: governorate,
        // Reset downstream selections
        selectedProviderType: null,
        filteredItems: null,
        groupedItemsByArea: null,
        homeSearchResults: null,
      ),
    );
  }

  /// Select a provider type (category) and load filtered items
  /// Items are automatically grouped by area for display
  void selectProviderType(String providerType) {
    // Guard: ensure we have loaded data and selected governorate
    if (state is! ServiceLoaded) return;

    final current = state as ServiceLoaded;

    // Guard: cannot select category without governorate
    if (current.selectedGovernorate == null) return;

    // Filter items by both governorate AND provider type
    final filteredItems = repository.getItemsByProviderType(
      items: current.items,
      governorate: current.selectedGovernorate!,
      providerType: providerType,
    );

    // Group filtered items by city/area for organized display
    final grouped = repository.groupItemsByArea(filteredItems);

    // Emit new state with filtered and grouped data
    emit(
      ServiceLoaded(
        items: current.items,
        governorates: current.governorates,
        providerTypes: current.providerTypes,
        selectedGovernorate: current.selectedGovernorate,
        selectedProviderType: providerType,
        filteredItems: filteredItems,
        groupedItemsByArea: grouped, // Ready for ItemsScreen
        homeSearchResults: null,
      ),
    );
  }

  /// Search across ALL data (used in HomeScreen)
  /// Does not affect governorate or category selection
  void searchInAllData(String query) {
    if (state is! ServiceLoaded) return;

    final current = state as ServiceLoaded;

    // If query is empty, clear search results
    if (query.trim().isEmpty) {
      emit(
        ServiceLoaded(
          items: current.items,
          governorates: current.governorates,
          providerTypes: current.providerTypes,
          homeSearchResults: null, // Clear search
          selectedGovernorate: current.selectedGovernorate,
          selectedProviderType: current.selectedProviderType,
          filteredItems: current.filteredItems,
          groupedItemsByArea: current.groupedItemsByArea,
        ),
      );
      return;
    }

    // Search in complete dataset
    final results = repository.searchItems(items: current.items, query: query);

    // Emit state with search results
    // Preserve all other state fields
    emit(
      ServiceLoaded(
        items: current.items,
        governorates: current.governorates,
        providerTypes: current.providerTypes,
        homeSearchResults: results, // Used by HomeScreen
        // Preserve selection context
        selectedGovernorate: current.selectedGovernorate,
        selectedProviderType: current.selectedProviderType,
        filteredItems: current.filteredItems,
        groupedItemsByArea: current.groupedItemsByArea,
      ),
    );
  }

  /// Search within selected category (used in ItemsScreen)
  /// Searches only in filteredItems, then re-groups by area
  void searchInCategory(String query) {
    if (state is! ServiceLoaded) return;

    final current = state as ServiceLoaded;

    // Guard: cannot search in category without filtered items
    if (current.filteredItems == null) return;

    // If query is empty, restore original grouping
    if (query.trim().isEmpty) {
      final originalGrouped = repository.groupItemsByArea(
        current.filteredItems!,
      );
      emit(
        ServiceLoaded(
          items: current.items,
          governorates: current.governorates,
          providerTypes: current.providerTypes,
          selectedGovernorate: current.selectedGovernorate,
          selectedProviderType: current.selectedProviderType,
          filteredItems: current.filteredItems,
          groupedItemsByArea: originalGrouped, // Restore original
          homeSearchResults: current.homeSearchResults,
        ),
      );
      return;
    }

    // Search within current category only
    final searchResults = repository.searchItems(
      items: current.filteredItems!,
      query: query,
    );

    // Re-group search results by area
    final newGrouped = repository.groupItemsByArea(searchResults);

    // Emit state with updated grouped data
    emit(
      ServiceLoaded(
        items: current.items,
        governorates: current.governorates,
        providerTypes: current.providerTypes,
        selectedGovernorate: current.selectedGovernorate,
        selectedProviderType: current.selectedProviderType,
        filteredItems: current.filteredItems, // Keep original
        groupedItemsByArea: newGrouped, // Updated with search results
        homeSearchResults: current.homeSearchResults,
      ),
    );
  }
}
