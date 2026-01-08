import 'package:equatable/equatable.dart';
import 'package:sgmc_app/data/models/item_model.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceLoaded extends ServiceState {
  final List<ItemModel> items;

  final List<String> governorates;
  final List<String> providerTypes;

  final String? selectedGovernorate;
  final String? selectedProviderType;

  final List<ItemModel>? filteredItems;
  final Map<String, List<ItemModel>>? groupedItemsByArea;

  final List<ItemModel>? homeSearchResults;

  const ServiceLoaded({
    required this.items,
    required this.governorates,
    required this.providerTypes,
    this.selectedGovernorate,
    this.selectedProviderType,
    this.filteredItems,
    this.groupedItemsByArea,
    this.homeSearchResults,
  });

  @override
  List<Object?> get props => [
        items,
        governorates,
        providerTypes,
        selectedGovernorate,
        selectedProviderType,
        filteredItems,
        groupedItemsByArea,
        homeSearchResults,
      ];
}


class ServiceError extends ServiceState {
  final String message;

  const ServiceError(this.message);

  @override
  List<Object?> get props => [message];
}
