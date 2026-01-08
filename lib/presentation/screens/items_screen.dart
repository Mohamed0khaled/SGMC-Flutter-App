import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgmc_app/logic/cubits/service/cubit/service_cubit.dart';
import 'package:sgmc_app/logic/cubits/service/cubit/service_state.dart';
import '../../data/models/item_model.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ServiceCubit, ServiceState>(
          builder: (context, state) {
            if (state is ServiceLoaded &&
                state.selectedProviderType != null) {
              return Text(state.selectedProviderType!);
            }
            return const Text('Results');
          },
        ),
      ),
      body: BlocBuilder<ServiceCubit, ServiceState>(
        builder: (context, state) {
          if (state is! ServiceLoaded ||
              state.groupedItemsByArea == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final grouped = state.groupedItemsByArea!;

          if (grouped.isEmpty) {
            return const Center(
              child: Text('No services found'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: grouped.entries.map((entry) {
              final areaName = entry.key;
              final items = entry.value;

              return _AreaSection(
                areaName: areaName,
                items: items,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}


class _AreaSection extends StatelessWidget {
  final String areaName;
  final List<ItemModel> items;

  const _AreaSection({
    required this.areaName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Area Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            areaName,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),

        // Items inside area
        ...items.map((item) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(item.name),
              subtitle: Text(item.specialty),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // لاحقًا: Details Screen
              },
            ),
          );
        }),
      ],
    );
  }
}

