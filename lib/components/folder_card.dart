import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../data/models/folder.dart';

class FolderCard extends StatelessWidget {
  final Folder folder;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDelete;

  const FolderCard({
    Key? key,
    required this.folder,
    this.onTap,
    this.onLongPress,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      color: AppColors.cardBackground,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: ListTile(
          leading: const Icon(Icons.folder, color: AppColors.primaryLight),
          title: Text(
            folder.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.bold,
                ),
          ),
          trailing: onDelete != null
              ? IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.textSecondary,
                  onPressed: onDelete,
                )
              : null,
        ),
      ),
    );
  }
}
