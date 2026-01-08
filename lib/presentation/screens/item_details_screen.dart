import 'package:flutter/material.dart';
import 'package:sgmc_app/core/localization/app_localizations.dart';
import 'package:sgmc_app/core/theme/app_colors.dart';
import 'package:sgmc_app/core/theme/app_text_styles.dart';
import 'package:sgmc_app/core/theme/app_theme.dart';
import 'package:sgmc_app/data/models/item_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailsScreen extends StatelessWidget {
  final ItemModel item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card - Provider Type Badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              color: AppColors.primary.withOpacity(0.05),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.providerType,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.spacingMedium),

            // Provider Information Section
            _buildSection(
              context: context,
              title: l10n.providerInfo,
              icon: Icons.business,
              children: [
                _InfoRow(
                  icon: Icons.medical_services_outlined,
                  label: l10n.providerName,
                  value: item.name,
                ),
                if (item.specialty.isNotEmpty)
                  _InfoRow(
                    icon: Icons.local_hospital_outlined,
                    label: l10n.specialty,
                    value: item.specialty,
                  ),
              ],
            ),

            // Services Section
            if (item.services.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingMedium),
              _buildSection(
                context: context,
                title: l10n.servicesProvided,
                icon: Icons.health_and_safety_outlined,
                children: [_ServicesCard(services: item.services)],
              ),
            ],

            // Location Section
            const SizedBox(height: AppDimensions.spacingMedium),
            _buildSection(
              context: context,
              title: l10n.location,
              icon: Icons.location_on,
              children: [
                _InfoRow(
                  icon: Icons.location_city,
                  label: l10n.governorate,
                  value: item.governorate,
                ),
                if (item.city.isNotEmpty)
                  _InfoRow(
                    icon: Icons.map_outlined,
                    label: l10n.cityArea,
                    value: item.city,
                  ),
                if (item.address.isNotEmpty)
                  _InfoRow(
                    icon: Icons.place_outlined,
                    label: l10n.address,
                    value: item.address,
                    maxLines: 3,
                  ),
              ],
            ),

            // Contact Information Section
            if (item.phone.isNotEmpty || item.email.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingMedium),
              _buildSection(
                context: context,
                title: l10n.contactInfo,
                icon: Icons.contact_phone,
                children: [
                  if (item.phone.isNotEmpty)
                    _ContactRow(
                      icon: Icons.phone,
                      label: l10n.phone,
                      value: item.phone,
                      onTap: () => _launchPhone(context, item.phone),
                    ),
                  if (item.email.isNotEmpty)
                    _ContactRow(
                      icon: Icons.email_outlined,
                      label: l10n.email,
                      value: item.email,
                      onTap: () => _launchEmail(context, item.email),
                    ),
                ],
              ),
            ],

            const SizedBox(height: AppDimensions.spacingLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingSmall),

          // Section Content Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(children: children),
            ),
          ),
        ],
      ),
    );
  }

  void _launchPhone(BuildContext context, String phone) async {
    debugPrint('📞 Attempting to launch phone dialer for: $phone');
    
    // Remove any spaces or special characters except + and digits
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    debugPrint('📞 Cleaned phone number: $cleanPhone');
    
    final uri = Uri(scheme: 'tel', path: cleanPhone);
    debugPrint('📞 URI: $uri');
    
    try {
      final canLaunch = await canLaunchUrl(uri);
      debugPrint('📞 Can launch URL: $canLaunch');
      
      if (canLaunch) {
        final result = await launchUrl(uri, mode: LaunchMode.externalApplication);
        debugPrint('📞 Launch result: $result');
      } else {
        debugPrint('📞 Cannot launch URL - phone app not available');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open phone dialer')),
        );
      }
    } catch (e) {
      debugPrint('📞 Error launching phone dialer: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _launchEmail(BuildContext context, String email) async {
    debugPrint('📧 Attempting to launch email for: $email');
    
    final uri = Uri(scheme: 'mailto', path: email);
    
    try {
      final canLaunch = await canLaunchUrl(uri);
      debugPrint('📧 Can launch URL: $canLaunch');
      
      if (canLaunch) {
        final result = await launchUrl(uri, mode: LaunchMode.externalApplication);
        debugPrint('📧 Launch result: $result');
      } else {
        debugPrint('📧 Cannot launch URL - email app not available');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open email app')),
        );
      }
    } catch (e) {
      debugPrint('📧 Error launching email: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

/// Information Row Widget
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int maxLines;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.6), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Contact Row Widget (with tap action)
class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Services Card Widget
class _ServicesCard extends StatelessWidget {
  final String services;

  const _ServicesCard({required this.services});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Split services by common separators
    final servicesList = services
        .split(RegExp(r'[,،\n]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (servicesList.isEmpty) {
      return Text(
        services,
        style: theme.textTheme.bodyMedium,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: servicesList.map((service) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  service,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
