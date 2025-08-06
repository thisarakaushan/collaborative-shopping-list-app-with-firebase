// Packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Models
import '../../data/models/list_item_model.dart';

// Constants
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class ListItemCard extends StatelessWidget {
  final ListItemModel item;
  final Function(bool) onToggleBought;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ListItemCard({
    super.key,
    required this.item,
    required this.onToggleBought,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Row(
          children: [
            Checkbox(
              value: item.isBought,
              onChanged: (value) => onToggleBought(value ?? false),
              activeColor: AppColors.primary,
            ),
            if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  right: AppDimensions.paddingMedium,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: AppDimensions.textSizeSubtitle,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      decoration: item.isBought
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  Text(
                    'Quantity: ${item.quantity}',
                    style: TextStyle(
                      fontSize: AppDimensions.textSizeBody,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Added by: ${item.addedByName}',
                    style: TextStyle(
                      fontSize: AppDimensions.textSizeBody,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(item.updatedAt),
                    style: TextStyle(
                      fontSize: AppDimensions.textSizeBody,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
