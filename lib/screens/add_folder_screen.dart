import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../providers/folder_list_provider.dart';
import '../constants/colors.dart';
import '../data/models/folder.dart';

class AddFolderScreen extends HookConsumerWidget {
  final Folder? parentFolder;

  const AddFolderScreen({Key? key, this.parentFolder}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final selectedColor = useState(AppColors.primary.value.toRadixString(16));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          parentFolder != null ? '${parentFolder!.name}にフォルダを作成' : 'フォルダを作成',
          style: const TextStyle(fontFamily: 'Times New Roman'),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'フォルダ名',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 24),
            const Text('フォルダの色',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ColorOption(
                  color: AppColors.primary.value.toRadixString(16),
                  isSelected: selectedColor.value ==
                      AppColors.primary.value.toRadixString(16),
                  onTap: () => selectedColor.value =
                      AppColors.primary.value.toRadixString(16),
                ),
                _ColorOption(
                  color: '2196F3', // Blue
                  isSelected: selectedColor.value == '2196F3',
                  onTap: () => selectedColor.value = '2196F3',
                ),
                _ColorOption(
                  color: '4CAF50', // Green
                  isSelected: selectedColor.value == '4CAF50',
                  onTap: () => selectedColor.value = '4CAF50',
                ),
                _ColorOption(
                  color: 'FFC107', // Amber
                  isSelected: selectedColor.value == 'FFC107',
                  onTap: () => selectedColor.value = 'FFC107',
                ),
                _ColorOption(
                  color: 'FF5722', // Deep Orange
                  isSelected: selectedColor.value == 'FF5722',
                  onTap: () => selectedColor.value = 'FF5722',
                ),
                _ColorOption(
                  color: '9C27B0', // Purple
                  isSelected: selectedColor.value == '9C27B0',
                  onTap: () => selectedColor.value = '9C27B0',
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await ref
                      .read(folderListProvider(parentFolder?.id).notifier)
                      .addFolder(
                        name: nameController.text,
                        parentId: parentFolder?.id,
                        color: '0xFF${selectedColor.value}',
                      );
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('作成'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final String color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    Key? key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Color(int.parse('0xFF$color')),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
