import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../data/models/folder.dart';
import '../constants/colors.dart';

class FolderTree extends StatelessWidget {
  final List<Folder> folders;
  final List<Folder> allFolders;
  final int level;
  final Function(Folder) onFolderTap;
  final Function(Folder) onFolderLongPress;
  final int? selectedFolderId;

  const FolderTree({
    Key? key,
    required this.folders,
    required this.allFolders,
    this.level = 0,
    required this.onFolderTap,
    required this.onFolderLongPress,
    this.selectedFolderId,
  }) : super(key: key);

  List<Folder> _getChildFolders(int parentId) {
    return allFolders.where((folder) => folder.parentId == parentId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: folders.map((folder) {
        final children = _getChildFolders(folder.id);
        final isSelected = selectedFolderId == folder.id;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => onFolderTap(folder),
              onLongPress: () => onFolderLongPress(folder),
              child: Container(
                padding: EdgeInsets.only(
                  left: (level * 16.0) + 16.0,
                  right: 16.0,
                  top: 12.0,
                  bottom: 12.0,
                ),
                color:
                    isSelected ? AppColors.primaryLight.withOpacity(0.1) : null,
                child: Row(
                  children: [
                    Icon(
                      children.isEmpty ? Icons.folder : Icons.folder_open,
                      color: Color(int.parse(folder.color ?? '0xFF800020')),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        folder.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                      ),
                    ),
                    if (children.isNotEmpty)
                      Text(
                        '(${children.length})',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                  ],
                ),
              ),
            ),
            if (children.isNotEmpty)
              FolderTree(
                folders: children,
                allFolders: allFolders,
                level: level + 1,
                onFolderTap: onFolderTap,
                onFolderLongPress: onFolderLongPress,
                selectedFolderId: selectedFolderId,
              ),
          ],
        );
      }).toList(),
    );
  }
}
